import { Injectable } from '@nestjs/common';
import { Prediction } from './entities/prediction.entity';
import {
  NotificationsService,
  UserRanking,
} from '../notifications/notifications.service';
import { NotificationType } from '../Enums/notification-type.enum';
import { Repository } from 'typeorm';
import { User } from 'src/auth/entities/user.entity';
import { RedisCacheService } from 'src/Common/cache/redis-cache.service';

@Injectable()
export class PredictionCalculatorService {
  constructor(
    private readonly notificationsService: NotificationsService,
    private readonly cacheService: RedisCacheService,
  ) {}

  async calculateAndApplyGainsAtMatchEnd(
    predictions: Prediction[],
    actualScoreFirst: number,
    actualScoreSecond: number,
    userRepository: Repository<User>,
    predictionRepository: Repository<Prediction>,
  ): Promise<void> {
    const processes: Promise<void>[] = [];
    console.log('Calculating gains for these predictions : ', predictions);
    for (const prediction of predictions) {
      processes.push(
        (async () => {
          const gain = this.calculateGain(
            prediction.scoreFirstEquipe,
            prediction.scoreSecondEquipe,
            actualScoreFirst,
            actualScoreSecond,
            prediction.numberOfDiamondsBet,
          );
          prediction.pointsEarned = 0;
          await predictionRepository.save(prediction);
          const result = await predictionRepository
            .createQueryBuilder('prediction')
            .select('SUM(prediction.pointsEarned)', 'sum')
            .where('prediction.userId = :userId', {
              userId: prediction.user.id,
            })
            .getRawOne();
          const sum = result.sum || 0;
          await this.notificationsService.notify({
            userId: prediction.user.id,
            type: NotificationType.DIAMOND_UPDATE,
            message:
              'The match ended. With the score ' +
              `${actualScoreFirst} - ${actualScoreSecond}`,
            data: { gain: sum, newDiamonds: 0 },
          });
          prediction.user.diamonds += gain;
          await userRepository.save(prediction.user);
          await this.notificationsService.notify({
            userId: prediction.user.id,
            type: NotificationType.CHANGE_OF_POSSESSED_GEMS,
            message: `You gained ${gain} diamonds for your prediction! And now you have ${prediction.user.diamonds} diamonds.`,
            data: { gain, newDiamonds: prediction.user.diamonds },
          });
          await this.cacheService.storeUserGains(prediction.user.id, sum);
        })(),
      );
    }
    await Promise.all(processes);
  }

  async calculateAndApplyGainsAtMatchUpdate(
    predictions: Prediction[],
    actualScoreFirst: number,
    actualScoreSecond: number,
    predictionRepository: Repository<Prediction>,
    userRepository: Repository<User>,
  ): Promise<void> {
    console.log('Calculating gains for these predictions : ', predictions);
    const users = new Set<{ id: string; gain: number }>();
    for (const prediction of predictions) {
      const gain = this.calculateGain(
        prediction.scoreFirstEquipe,
        prediction.scoreSecondEquipe,
        actualScoreFirst,
        actualScoreSecond,
        prediction.numberOfDiamondsBet,
      );
      prediction.pointsEarned = gain;
      await predictionRepository.save(prediction);
      users.add({ id: prediction.user.id, gain });
    }
    const notifications: Promise<void>[] = [];
    for (const userId of users) {
      notifications.push(
        (async () => {
          const result = await predictionRepository
            .createQueryBuilder('prediction')
            .select('SUM(prediction.pointsEarned)', 'sum')
            .where('prediction.userId = :userId', { userId: userId.id })
            .getRawOne();
          const sum = result.sum || 0;
          await this.notificationsService.notify({
            userId: userId.id,
            type: NotificationType.DIAMOND_UPDATE,
            message:
              'There was a match update of the match you predicted. And the new score is ' +
              `${actualScoreFirst} - ${actualScoreSecond}`,
            data: { gain: sum, newDiamonds: 0 },
          });
          await updateRankingScore(userId.id, sum, userRepository);
          await this.cacheService.storeUserGains(userId.id, sum);
        })(),
      );
    }
    await Promise.all(notifications);
    await notifyUsersAboutRankingUpdate(
      userRepository,
      this.notificationsService,
    );
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
async function updateRankingScore(
  id: string,
  gain: number,
  userRepository: Repository<User>,
) {
  const user = await userRepository.findOne({ where: { id } });
  if (user) {
    const currentScore = Number(user.diamonds) || 0;
    user.score = currentScore + Number(gain);
    await userRepository.save(user);
  }
}
export async function notifyUsersAboutRankingUpdate(
  userRepository: Repository<User>,
  notificationsService: NotificationsService,
  save = false,
) {
  const usersWithRankingsWithIds = await userRepository.find({
    order: { score: 'DESC' },
    select: ['firstName', 'lastName', 'score', 'imageUrl', 'id'],
  });
  const usersWithRankings: UserRanking[] = usersWithRankingsWithIds.map(
    (user) => ({
      firstName: user.firstName,
      lastName: user.lastName,
      score: user.score,
      imageUrl: user.imageUrl,
    }),
  );
  for (const user of usersWithRankingsWithIds) {
    const rank = usersWithRankingsWithIds.indexOf(user) + 1;
    await notificationsService.notify(
      {
        userId: user.id,
        type: NotificationType.RANKING_UPDATE,
        message: `You are now at rank ${rank}.`,
        data: { rankings: usersWithRankings },
      },
      save
    );
  }
}
