import { Injectable } from '@nestjs/common';
import { Prediction } from './entities/prediction.entity';
import { NotificationsService } from '../notifications/notifications.service';
import { NotificationType } from '../Enums/notification-type.enum';
import { Repository } from 'typeorm';
import { User } from 'src/auth/entities/user.entity';

@Injectable()
export class PredictionCalculatorService {
  constructor(private readonly notificationsService: NotificationsService) {}

  async calculateAndApplyGainsAtMatchEnd(
    predictions: Prediction[],
    actualScoreFirst: number,
    actualScoreSecond: number,
    userRepository: Repository<User>,
    predictionRepository: Repository<Prediction>,
  ): Promise<void> {
    for (const prediction of predictions) {
      const gain = this.calculateGain(
        prediction.scoreFirstEquipe,
        prediction.scoreSecondEquipe,
        prediction.numberOfDiamondsBet,
        actualScoreFirst,
        actualScoreSecond,
      );

      if (gain > 0) {
        prediction.user.diamonds += gain;
        await userRepository.save(prediction.user);
        await this.notificationsService.notify({
          userId: prediction.user.id,
          type: NotificationType.CHANGE_OF_POSSESSED_GEMS,
          message: `You gained ${gain} diamonds for your prediction! And now you have ${prediction.user.diamonds} diamonds.`,
          data: { gain, newDiamonds: prediction.user.diamonds },
        });
        prediction.pointsEarned = 0;
        await predictionRepository.save(prediction);
      }
    }
  }

  async calculateAndApplyGainsAtMatchUpdate(
    predictions: Prediction[],
    actualScoreFirst: number,
    actualScoreSecond: number,
    predictionRepository: Repository<Prediction>,
  ): Promise<void> {
    const users = new Set<string>();
    for (const prediction of predictions) {
      const gain = this.calculateGain(
        prediction.scoreFirstEquipe,
        prediction.scoreSecondEquipe,
        prediction.numberOfDiamondsBet,
        actualScoreFirst,
        actualScoreSecond,
      );
      prediction.pointsEarned = gain;
      await predictionRepository.save(prediction);
      users.add(prediction.user.id);
    }
    const notifications: Promise<void>[] = [];
    for (const userId of users) {
      notifications.push(
        (async () => {
          const result = await predictionRepository
            .createQueryBuilder('prediction')
            .select('SUM(prediction.pointsEarned)', 'sum')
            .where('prediction.userId = :userId', { userId })
            .getRawOne();
          const sum = result.sum || 0;
          await this.notificationsService.notify({
            userId,
            type: NotificationType.DIAMOND_UPDATE,
            message: '',
            data: { gain: sum, newDiamonds: 0 },
          });
        })(),
      );
    }
    await Promise.all(notifications);
  }

  private calculateGain(
    predFirst: number,
    predSecond: number,
    actualFirst: number,
    actualSecond: number,
    diamondsBet: number,
  ): number {
    // Exact match
    if (predFirst === actualFirst && predSecond === actualSecond) {
      return 20;
    }

    const predDiff = predFirst - predSecond;
    const actualDiff = actualFirst - actualSecond;
    const predWinner = predDiff > 0 ? 1 : predDiff < 0 ? 2 : 0;
    const actualWinner = actualDiff > 0 ? 1 : actualDiff < 0 ? 2 : 0;

    // Correct winner and goal difference
    if (
      predWinner === actualWinner &&
      predWinner !== 0 &&
      predDiff === actualDiff
    ) {
      return 10;
    }

    // Correct winner
    if (predWinner === actualWinner && predWinner !== 0) {
      return 5;
    }

    // Close scores (difference of 1 in each score)
    if (
      Math.abs(predFirst - actualFirst) <= 1 &&
      Math.abs(predSecond - actualSecond) <= 1
    ) {
      return 2;
    }

    return 0;
  }
}
