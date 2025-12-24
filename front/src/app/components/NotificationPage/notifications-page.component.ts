import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NotificationsApiService } from '../../services/notifications-api.service';
import { Notification } from '../../services/Api/model/notification';
import { catchError, EMPTY, map, scan, startWith, switchMap } from 'rxjs';
import { NotificationElementComponent } from './notification-element/notification-element.component';
import { rxResource } from '@angular/core/rxjs-interop';
@Component({
  selector: 'app-notifications-page',
  templateUrl: './notifications-page.component.html',
  styleUrls: ['./notifications-page.component.css'],
  imports: [CommonModule, NotificationElementComponent],
  standalone: true,
})
export class NotificationsPageComponent {
  private notificationsApi = inject(NotificationsApiService);
  private initialNotifs$ = this.notificationsApi.getUserNotifications();
  notifications = rxResource({
    stream: () =>
      this.initialNotifs$.pipe(
        map((res) => res.map((n) => ({ ...n, isRealTime: false }))),
        switchMap((initial) =>
          this.notificationsApi.connectToSSE().pipe(
            scan(
              (curr, notification) => [
                { ...notification, isRealTime: true },
                ...curr,
              ],
              initial
            ),
            startWith(initial),
            catchError((error) => {
              console.error('SSE error:', error);
              return EMPTY;
            })
          )
        )
      ),
  });

  constructor() {}

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
          this.notifications!.update((notifications) =>
            notifications?.filter((n) => n.id !== notification.id)
          );
        },
        error: (error) => {
          console.error('Error deleting notification:', error);
        },
      });
  }
}
