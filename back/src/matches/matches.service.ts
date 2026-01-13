import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Match } from './entities/match.entity';
import { Prediction } from './entities/prediction.entity';
import { User } from '../auth/entities/user.entity';
import { MatchStatus } from '../Enums/matchstatus.enum';
import {
  notifyUsersAboutRankingUpdate,
  PredictionCalculatorService,
} from './prediction-calculator.service';
import { NotificationType } from 'src/Enums/notification-type.enum';
import { NotificationsService } from 'src/notifications/notifications.service';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class MatchesService {
  constructor(
    @InjectRepository(Match)
    private readonly matchRepository: Repository<Match>,
    @InjectRepository(Prediction)
    private readonly predictionRepository: Repository<Prediction>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly predictionCalculator: PredictionCalculatorService,
    private readonly notificationsService: NotificationsService,
    private readonly configService: ConfigService,
  ) {}

  async verifyMatchBegan(id: string): Promise<boolean> {
    // fetch from api the match status using all sports api
    const apiKey = this.configService.get<string>('ALL_SPORTS_API_KEY');
    //also need the timezone of the server to send to the api
    const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    const response = await fetch(
      `https://apiv2.allsportsapi.com/football?met=Fixtures&APIkey=${apiKey}&matchId=${id}&timezone=${timezone}`,
    );
    const data = await response.json();
    const success = data.success;
    if (success !== 1) {
      throw new NotFoundException('Match not found in external API');
    }
    if (data.result && data.result.length > 0) {
      const matchData = data.result[0];
      const eventDate = matchData.event_date;
      const eventTime = matchData.event_time;
      // the time is in format HH:MM so we need to combine date and time
      const eventDateTimeString = `${eventDate}T${eventTime}:00`;
      const eventDateTime = new Date(eventDateTimeString);
      const currentDate = new Date();
      if (eventDateTime < currentDate) {
        return true;
      }
    }
    return false;
  }
  async canPredict(
    userId: string,
    matchId: string,
    numberOfDiamondsBet: number,
  ) {
    const began = await this.verifyMatchBegan(matchId);
    if (began) {
      return false;
    }
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) return false;
    if (user.diamonds < numberOfDiamondsBet) return false;

    const exists = await this.predictionRepository.exists({
      where: {
        userId,
        matchId,
      },
    });

    if (exists) {
      return false;
    }
    return true;
  }

  async addDiamond(userId: string, numberOfDiamonds: number) {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');
    user.diamonds += numberOfDiamonds;
    user.score += numberOfDiamonds;
    const newdiamonds = user.diamonds;
    await this.userRepository.save(user);
    await this.notificationsService.notify({
      userId: userId,
      type: NotificationType.CHANGE_OF_POSSESSED_GEMS,
      message: `You received ${numberOfDiamonds} diamonds!`,
      data: { gain: numberOfDiamonds, newDiamonds: newdiamonds },
    });
    await notifyUsersAboutRankingUpdate(
      this.userRepository,
      this.notificationsService,
    );
  }

  async terminateMatch(
    id: string,
    actualScoreFirst: number,
    actualScoreSecond: number,
  ): Promise<Match> {
    const match = await this.matchRepository.findOne({
      where: { id },
      relations: ['predictions', 'predictions.user'],
    });
    if (!match) throw new NotFoundException('Match not found');
    if (match.status !== MatchStatus.ONGOING)
      throw new BadRequestException('Match is not ongoing');
    match.status = MatchStatus.COMPLETED;
    match.scoreFirstTeam = actualScoreFirst;
    match.scoreSecondTeam = actualScoreSecond;

    // Calculate gains
    await this.predictionCalculator.calculateAndApplyGainsAtMatchEnd(
      match.predictions,
      actualScoreFirst,
      actualScoreSecond,
      this.userRepository,
      this.predictionRepository,
    );

    return this.matchRepository.save(match);
  }

  async updateMatch(
    id: string,
    actualScoreFirst: number,
    actualScoreSecond: number,
  ): Promise<Match> {
    if (actualScoreFirst > 0 || actualScoreSecond > 0) {
      const match = await this.matchRepository.findOne({
        where: { id },
        relations: ['predictions', 'predictions.user'],
      });
      if (!match) throw new NotFoundException('Match not found');
      if (match.status !== MatchStatus.ONGOING)
        throw new BadRequestException('Match is not ongoing');
      match.scoreFirstTeam = actualScoreFirst;
      match.scoreSecondTeam = actualScoreSecond;

      // Calculate gains
      await this.predictionCalculator.calculateAndApplyGainsAtMatchUpdate(
        match.predictions,
        actualScoreFirst,
        actualScoreSecond,
        this.predictionRepository,
        this.userRepository,
      );

      return this.matchRepository.save(match);
    }
    throw new BadRequestException('No score update provided');
  }

  async makePrediction(
    userId: string,
    matchId: string,
    scoreFirst: number,
    scoreSecond: number,
    diamondsBet: number,
  ): Promise<Prediction> {
    const match = await this.matchRepository.findOne({
      where: { id: matchId },
    });
    if (!match) throw new NotFoundException('Match not found');
    if (match.status !== MatchStatus.ONGOING)
      throw new BadRequestException('Match is not active');

    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');
    if (user.diamonds < diamondsBet)
      throw new BadRequestException('Not enough diamonds');

    const exists = await this.predictionRepository.exists({
      where: {
        userId,
        matchId,
      },
    });

    if (exists) {
      throw new BadRequestException(
        'Prediction already exists for this user and this match',
      );
    }

    // Deduct diamonds
    user.diamonds -= diamondsBet;
    user.score -= diamondsBet;
    await this.userRepository.save(user);

    await this.notificationsService.notify({
      userId: user.id,
      type: NotificationType.CHANGE_OF_POSSESSED_GEMS,
      message: `You spent ${diamondsBet} diamonds for your prediction! And now you have ${user.diamonds} diamonds.`,
      data: { gain: -diamondsBet, newDiamonds: user.diamonds },
    });

    await notifyUsersAboutRankingUpdate(
      this.userRepository,
      this.notificationsService,
    );

    const prediction = this.predictionRepository.create({
      userId,
      matchId,
      scoreFirstEquipe: scoreFirst,
      scoreSecondEquipe: scoreSecond,
      numberOfDiamondsBet: diamondsBet,
      pointsEarned: 0,
    });
    await this.predictionRepository.save(prediction);
    return prediction;
  }
}
