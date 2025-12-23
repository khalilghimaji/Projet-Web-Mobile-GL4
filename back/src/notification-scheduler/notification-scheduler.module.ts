import { Module } from '@nestjs/common';
import { ScheduleModule } from '@nestjs/schedule';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Notification } from 'src/notifications/entities/notification.entity';
import { NotificationSchedulerService } from './notification-scheduler/notification-scheduler.service';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [
    ScheduleModule.forRoot(),
    TypeOrmModule.forFeature([Notification]),
    NotificationsModule,
  ],
  providers: [NotificationSchedulerService],
  exports: [NotificationSchedulerService],
})
export class NotificationSchedulerModule {}
