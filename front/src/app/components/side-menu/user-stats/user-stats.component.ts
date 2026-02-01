import {
  ChangeDetectionStrategy,
  Component,
  inject,
  input,
} from '@angular/core';
import { RouterLink } from '@angular/router';
import { NotificationsStateService } from '../../../notifications/services/notifications-state.service';

@Component({
  selector: 'app-user-stats',
  imports: [RouterLink],
  templateUrl: './user-stats.component.html',
  styleUrl: './user-stats.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class UserStatsComponent {
  private readonly notificationsState = inject(NotificationsStateService);
  diamonds = this.notificationsState.diamonds;
  gainedDiamonds = this.notificationsState.gainedDiamonds;
  unreadNotificationsCount = this.notificationsState.unreadCount;
  context = input<'desktop' | 'mobile'>('desktop');
}
