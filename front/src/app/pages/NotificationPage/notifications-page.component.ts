import { ChangeDetectionStrategy, Component, inject } from '@angular/core';

import { NotificationsApiService } from '../../services/notifications-api.service';
import { Notification } from '../../services/Api/model/notification';
import {
  catchError,
  EMPTY,
  filter,
  map,
  scan,
  startWith,
  switchMap,
} from 'rxjs';

import { rxResource } from '@angular/core/rxjs-interop';
import { NotificationElementComponent } from '../../components/notification-element/notification-element.component';
@Component({
  selector: 'app-notifications-page',
  templateUrl: './notifications-page.component.html',
  styleUrls: ['./notifications-page.component.css'],
  imports: [NotificationElementComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
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
            filter(
              (event) =>
                event.type === 'CHANGE_OF_POSSESSED_GEMS' ||
                event.type === 'DIAMOND_UPDATE' ||
                event.type === 'RANKING_UPDATE'
            ),
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
        this.notifications!.update((notifications) =>
          notifications?.map((n) =>
            n.id === notification.id ? { ...n, read: true } : n
          )
        );
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
