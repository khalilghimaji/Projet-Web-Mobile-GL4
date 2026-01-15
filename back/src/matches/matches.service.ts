import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Prediction } from './entities/prediction.entity';
import { User } from '../auth/entities/user.entity';
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

  async getMatchPredictions(matchId: string): Promise<Prediction[]> {
    return this.predictionRepository.find({
      where: { matchId },
    });
  }

  async getUserPrediction(
    userId: string,
    matchId: string,
  ): Promise<Prediction | null> {
    return this.predictionRepository.findOne({
      where: { userId, matchId },
    });
  }

  async notifyMatch(
    id: string,
    actualScoreFirst: number,
    actualScoreSecond: number,
  ): Promise<void> {
    await this.predictionCalculator.calculateAndApplyGainsAtMatchEnd(
      await this.getMatchPredictions(id),
      actualScoreFirst,
      actualScoreSecond,
      this.userRepository,
      this.predictionRepository,
    );
  }

  async makePrediction(
    userId: string,
    matchId: string,
    scoreFirst: number,
    scoreSecond: number,
    diamondsBet: number,
  ): Promise<Prediction> {
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

  async updatePrediction(
    userId: string,
    matchId: string,
    scoreFirst?: number,
    scoreSecond?: number,
    newDiamondsBet?: number,
  ): Promise<Prediction> {
    // Check if match has begun
    const began = await this.verifyMatchBegan(matchId);
    if (began) {
      throw new BadRequestException(
        'Cannot update prediction after match has started',
      );
    }

    const prediction = await this.predictionRepository.findOne({
      where: { userId, matchId },
    });

    if (!prediction) {
      throw new NotFoundException('Prediction not found');
    }

    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');

    // Handle diamond bet change
    if (
      newDiamondsBet !== undefined &&
      newDiamondsBet !== prediction.numberOfDiamondsBet
    ) {
      const oldBet = prediction.numberOfDiamondsBet;
      const diamondDifference = newDiamondsBet - oldBet;

      if (diamondDifference > 0) {
        // User is betting more diamonds
        if (user.diamonds < diamondDifference) {
          throw new BadRequestException('Not enough diamonds');
        }
      }

      user.diamonds -= diamondDifference;
      user.score -= diamondDifference;

      await this.userRepository.save(user);

      if (diamondDifference !== 0) {
        await this.notificationsService.notify({
          userId: user.id,
          type: NotificationType.CHANGE_OF_POSSESSED_GEMS,
          message:
            diamondDifference > 0
              ? `You spent ${diamondDifference} more diamonds for your updated prediction! You now have ${user.diamonds} diamonds.`
              : `You got ${Math.abs(diamondDifference)} diamonds back from your updated prediction! You now have ${user.diamonds} diamonds.`,
          data: { gain: -diamondDifference, newDiamonds: user.diamonds },
        });

        await notifyUsersAboutRankingUpdate(
          this.userRepository,
          this.notificationsService,
        );
      }

      prediction.numberOfDiamondsBet = newDiamondsBet;
    }

    // Update scores
    if (scoreFirst !== undefined) {
      prediction.scoreFirstEquipe = scoreFirst;
    }
    if (scoreSecond !== undefined) {
      prediction.scoreSecondEquipe = scoreSecond;
    }

    await this.predictionRepository.save(prediction);
    return prediction;
  }
}
