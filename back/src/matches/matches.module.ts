import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Match } from './entities/match.entity';
import { Prediction } from './entities/prediction.entity';
import { MatchesService } from './matches.service';
import { MatchesController } from './matches.controller';
import { AuthModule } from '../auth/auth.module';
import { NotificationsModule } from '../notifications/notifications.module';
import { PredictionCalculatorService } from './prediction-calculator.service';
import { User } from 'src/auth/entities/user.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Match, Prediction, User]),
    AuthModule,
    NotificationsModule,
  ],
  providers: [MatchesService, PredictionCalculatorService],
  controllers: [MatchesController],
})
export class MatchesModule {}
