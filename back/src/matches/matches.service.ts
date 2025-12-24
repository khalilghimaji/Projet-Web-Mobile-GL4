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
import { PredictionCalculatorService } from './prediction-calculator.service';
import { NotificationType } from 'src/Enums/notification-type.enum';
import { NotificationsService } from 'src/notifications/notifications.service';

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
  ) {}

  async activateMatch(id: string): Promise<Match> {
    let match = await this.matchRepository.findOne({ where: { id } });
    if (!match) {
      match = this.matchRepository.create({ id, status: MatchStatus.ONGOING });
    } else {
      if (match.status !== MatchStatus.INACTIVE)
        throw new BadRequestException('Match is not inactive');
      match.status = MatchStatus.ONGOING;
    }
    return this.matchRepository.save(match);
  }

  async disableMatch(id: string): Promise<Match> {
    const match = await this.matchRepository.findOne({ where: { id } });
    if (!match) throw new NotFoundException('Match not found');
    if (match.status !== MatchStatus.ONGOING)
      throw new BadRequestException('Match is not ongoing');
    match.status = MatchStatus.INACTIVE;
    return this.matchRepository.save(match);
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
    await this.predictionCalculator.calculateAndApplyGains(
      match.predictions,
      actualScoreFirst,
      actualScoreSecond,
      this.userRepository,
    );

    return this.matchRepository.save(match);
  }

  async makePrediction(
    userId: string,
    matchId: string,
    scoreFirst: number,
    scoreSecond: number,
  ): Promise<Prediction> {
    const match = await this.matchRepository.findOne({
      where: { id: matchId },
    });
    if (!match) throw new NotFoundException('Match not found');
    if (match.status !== MatchStatus.ONGOING)
      throw new BadRequestException('Match is not active');

    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');
    if (user.diamonds < 5) throw new BadRequestException('Not enough diamonds');

    // Deduct diamonds
    user.diamonds -= 5;
    await this.userRepository.save(user);

    await this.notificationsService.notify({
      userId: user.id,
      type: NotificationType.CHANGE_OF_POSSESSED_GEMS,
      message: `You spent 5 diamonds for your prediction! And now you have ${user.diamonds} diamonds.`,
      data: { gain: -5, newDiamonds: user.diamonds },
    });

    const prediction = this.predictionRepository.create({
      userId,
      matchId,
      scoreFirstEquipe: scoreFirst,
      scoreSecondEquipe: scoreSecond,
    });
    await this.predictionRepository.save(prediction);
    return prediction;
  }
}
