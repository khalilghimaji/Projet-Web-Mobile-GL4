import { Injectable } from '@nestjs/common';
import { Subject, Observable } from 'rxjs';
import { InjectRepository } from '@nestjs/typeorm';
import { Notification } from './entities/notification.entity';
import { Repository } from 'typeorm';
import { NotificationType } from '../Enums/notification-type.enum';

interface NotificationPayload {
  userId: string;
  type: NotificationType;
  message: string;
  data?: DataMessage | UserRankingMessage;
}

interface DataMessage {
  gain: number;
  newDiamonds: number;
}

export interface UserRanking {
  firstName: string;
  lastName: string;
  score: number;
  imageUrl: string;
}

export interface UserRankingMessage {
  rankings: UserRanking[];
}
@Injectable()
export class NotificationsService {
  private clients: Map<string, Subject<MessageEvent>> = new Map();

  constructor(
    @InjectRepository(Notification)
    private readonly notificationRepository: Repository<Notification>,
  ) {}

  subscribe(userId: string): Observable<MessageEvent> {
    const subject = new Subject<MessageEvent>();
    this.clients.set(userId, subject);
    console.log(`User ${userId} subscribed to SSE`);
    return subject.asObservable();
  }

  async notify(payload: NotificationPayload, save = true): Promise<void> {
    const notification = await this.storeNotification(payload, save);
    notification.data = { ...payload.data };
    const client = this.clients.get(payload.userId);
    if (client) {
      const messageEvent = new MessageEvent('message', {
        data: JSON.stringify(notification),
      });
      client.next(messageEvent);
      console.log(
        `Notification sent to user ${payload.userId}: ${payload.message}`,
      );
    }
  }

  async storeNotification(
    payload: NotificationPayload,
    save,
  ): Promise<Notification> {
    const notification = this.notificationRepository.create({
      userId: payload.userId,
      type: payload.type,
      message: payload.message,
      data: payload.data,
      read: false,
    });
    if (save) {
      return this.notificationRepository.save(notification);
    } else {
      return notification;
    }
  }

  async getUserNotifications(userId: string): Promise<Notification[]> {
    return this.notificationRepository.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }

  async markNotificationAsRead(id: string): Promise<void> {
    await this.notificationRepository.update(id, { read: true });
  }
  async deleteNotification(id: string): Promise<void> {
    await this.notificationRepository.delete(id);
    console.log(`Notification ${id} deleted from the database.`);
  }
}
