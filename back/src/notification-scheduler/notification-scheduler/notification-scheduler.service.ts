import { Injectable, Logger } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import {Not, Repository} from 'typeorm';
import { Notification } from 'src/notifications/entities/notification.entity';
import { NotificationsService } from "../../notifications/notifications.service";
import { NotificationType } from 'src/Enums/notification-type.enum';

@Injectable()
export class NotificationSchedulerService {
  private readonly logger = new Logger(NotificationSchedulerService.name);

  constructor(
      @InjectRepository(Notification)
      private readonly notificationRepository: Repository<Notification>,
      private readonly notificationsService: NotificationsService,
  ) {}

  @Cron('* * * * *')
  async handleCron() {
    this.logger.log('Running notification scheduler every minute');
    const now = new Date();
    const twentyFourHoursAgo = new Date(now.getTime() - 24 * 60 * 60 * 1000);
  }
}

