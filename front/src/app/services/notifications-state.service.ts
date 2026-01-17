import { Injectable, signal, computed, inject, effect } from '@angular/core';
import { rxResource } from '@angular/core/rxjs-interop';
import { NotificationsApiService } from './notifications-api.service';
import { AuthService } from './auth.service';
import { Notification } from './Api/model/notification';
import { NotificationDataAnyOf1RankingsInner } from './Api/model/notificationDataAnyOf1RankingsInner';
import {
  switchMap,
  map,
  filter,
  scan,
  startWith,
  catchError,
  EMPTY,
  tap,
} from 'rxjs';

interface RankingUser extends NotificationDataAnyOf1RankingsInner {
  rank?: number;
}

@Injectable({
  providedIn: 'root',
})
export class NotificationsStateService {
  private readonly notificationsApi = inject(NotificationsApiService);
  private readonly authService = inject(AuthService);

  // State signals
  private readonly _diamonds = signal(0);
  private readonly _gainedDiamonds = signal(0);
  private readonly _rankings = signal<RankingUser[]>([]);

  // Notifications using rxResource
  readonly notifications = rxResource({
    stream: () => {
      // Only load if authenticated
      if (!this.authService.isAuthenticated()) {
        return EMPTY;
      }

      return this.notificationsApi.getUserNotifications().pipe(
        map((res) => res.map((n) => ({ ...n, isRealTime: false }))),
        switchMap((initial) =>
          this.notificationsApi.connectToSSE().pipe(
            tap((notification: Notification) => {
              this.handleNotification(notification);
            }),
            filter((notification) => notification.type !== 'RANKING_UPDATE'),
            scan(
              (curr, notification) => [
                { ...notification, isRealTime: true },
                ...curr,
              ],
              initial,
            ),
            startWith(initial),
            catchError((error) => {
              console.error('SSE error in notifications resource:', error);
              return EMPTY;
            }),
          ),
        ),
      );
    },
  });

  // Public readonly signals
  readonly diamonds = this._diamonds.asReadonly();
  readonly gainedDiamonds = this._gainedDiamonds.asReadonly();
  readonly rankings = this._rankings.asReadonly();

  // Computed signals
  readonly topThreeRankings = computed(() => this._rankings().slice(0, 3));
  readonly remainingRankings = computed(() => this._rankings().slice(3));
  readonly unreadCount = computed(() => {
    const notifs = this.notifications.value();
    return notifs?.filter((n) => !n.read).length ?? 0;
  });

  constructor() {
    // Sync diamonds with user data on auth changes
    effect(() => {
      if (!this.authService.isAuthenticated()) {
        this._diamonds.set(0);
        this._gainedDiamonds.set(0);
        this._rankings.set([]);
      } else {
        this._diamonds.set(this.authService.currentUser()?.diamonds || 0);
      }
    });
  }

  private handleNotification(notification: Notification): void {
    switch (notification.type) {
      case 'CHANGE_OF_POSSESSED_GEMS':
        if (notification.data?.newDiamonds !== undefined) {
          this._diamonds.set(notification.data.newDiamonds);
        }
        break;

      case 'DIAMOND_UPDATE':
        if (notification.data?.gain !== undefined) {
          this._gainedDiamonds.set(Number(notification.data.gain));
        }
        break;

      case 'RANKING_UPDATE':
        if (notification.data?.rankings) {
          this._rankings.set(
            notification.data.rankings.map(
              (user: RankingUser, index: number) => ({
                ...user,
                rank: index + 1,
              }),
            ),
          );
        }
        break;

      default:
        // Other notification types are handled by rxResource and added to the list
        break;
    }
  }

  setRankings(rankings: RankingUser[]): void {
    this._rankings.set(rankings);
  }

  markNotificationAsRead(notificationId: string): void {
    this.notificationsApi.markAsRead(notificationId).subscribe({
      next: () => {
        this.notifications.update((notifications) =>
          notifications?.map((n) =>
            n.id.toString() === notificationId ? { ...n, read: true } : n,
          ),
        );
      },
      error: (error) => {
        console.error('Error marking notification as read:', error);
      },
    });
  }

  deleteNotification(notificationId: string): void {
    this.notificationsApi.deleteNotification(notificationId).subscribe({
      next: () => {
        this.notifications.update((notifications) =>
          notifications?.filter((n) => n.id.toString() !== notificationId),
        );
      },
      error: (error) => {
        console.error('Error deleting notification:', error);
      },
    });
  }

  reloadNotifications(): void {
    this.notifications.reload();
  }
}
