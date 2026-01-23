import {
  ChangeDetectionStrategy,
  Component,
  inject,
  viewChild,
  ElementRef,
  afterNextRender,
  DestroyRef,
} from '@angular/core';
import { fromEvent } from 'rxjs';
import { NotificationsStateService } from '../../services/notifications-state.service';
import { Notification } from '../../services/Api/model/notification';
import { NotificationElementComponent } from '../../components/notification-element/notification-element.component';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
@Component({
  selector: 'app-notifications-page',
  templateUrl: './notifications-page.component.html',
  styleUrls: ['./notifications-page.component.css'],
  imports: [NotificationElementComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  standalone: true,
})
export class NotificationsPageComponent {
  notificationsState = inject(NotificationsStateService);
  private reloadBtn = viewChild<ElementRef<HTMLButtonElement>>('reloadBtn');

  notifications = this.notificationsState.notifications;
  private readonly destroyRef = inject(DestroyRef);

  constructor() {
    afterNextRender(() => {
      const btnElement = this.reloadBtn()?.nativeElement;
      if (btnElement) {
        fromEvent(btnElement, 'click')
          .pipe(takeUntilDestroyed(this.destroyRef))
          .subscribe(() => {
            this.notificationsState.reloadNotifications();
          });
      }
    });
  }

  markAsRead(notification: Notification): void {
    this.notificationsState.markNotificationAsRead(notification.id.toString());
  }

  deleteNotification(notification: Notification): void {
    this.notificationsState.deleteNotification(notification.id.toString());
  }
}
