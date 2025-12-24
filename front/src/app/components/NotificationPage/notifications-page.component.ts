import { Component, OnInit, OnDestroy, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NotificationsApiService } from '../../services/notifications-api.service';
import { Notification } from '../../services/Api/model/notification';
import { Subscription } from 'rxjs';
import { NotificationElementComponent } from './notification-element/notification-element.component';

@Component({
  selector: 'app-notifications-page',
  templateUrl: './notifications-page.component.html',
  styleUrls: ['./notifications-page.component.css'],
  imports: [CommonModule, NotificationElementComponent],
  standalone: true,
})
export class NotificationsPageComponent implements OnInit, OnDestroy {
  notifications = signal<Notification[]>([]);
  private sseSubscription: Subscription | null = null;

  constructor(private notificationsApi: NotificationsApiService) {}

  ngOnInit(): void {
    this.loadNotifications();
    this.connectToSSE();
  }

  ngOnDestroy(): void {
    this.disconnectSSE();
  }

  private loadNotifications(): void {
    this.notificationsApi.getUserNotifications().subscribe({
      next: (notifications) => {
        this.notifications.set(notifications);
      },
      error: (error) => {
        console.error('Error loading notifications:', error);
      },
    });
  }

  private connectToSSE(): void {
    this.sseSubscription = this.notificationsApi.connectToSSE().subscribe({
      next: (notification) => {
        this.notifications.update((notifications) => [
          notification,
          ...notifications,
        ]); // Add new notification to the top
      },
      error: (error) => {
        console.error('SSE error:', error);
      },
    });
  }

  private disconnectSSE(): void {
    if (this.sseSubscription) {
      this.sseSubscription.unsubscribe();
    }
    this.notificationsApi.disconnectSSE();
  }

  markAsRead(notification: Notification): void {
    this.notificationsApi.markAsRead(notification.id.toString()).subscribe({
      next: () => {
        notification.read = true;
      },
      error: (error) => {
        console.error('Error marking as read:', error);
      },
    });
  }

  deleteNotification(notification: Notification): void {
    this.notificationsApi
      .deleteNotification(notification.id.toString())
      .subscribe({
        next: () => {
          this.notifications.update((notifications) =>
            notifications.filter((n) => n.id !== notification.id)
          );
        },
        error: (error) => {
          console.error('Error deleting notification:', error);
        },
      });
  }
}
