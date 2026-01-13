import {
  Component,
  OnInit,
  signal,
  inject,
  computed,
  ChangeDetectionStrategy,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { CardModule } from 'primeng/card';
import { TableModule } from 'primeng/table';
import { AvatarModule } from 'primeng/avatar';
import { SkeletonModule } from 'primeng/skeleton';
import { MessageModule } from 'primeng/message';
import { NotificationsApiService } from '../../services/notifications-api.service';
import { NotificationDataAnyOf1RankingsInner } from '../../services/Api/model/notificationDataAnyOf1RankingsInner';
import { UserService } from '../../services/Api';
import { MedalIconPipe } from '../../shared/pipes/medal-icon.pipe';
import { InitialsPipe } from '../../shared/pipes/initials.pipe';

interface RankingUser extends NotificationDataAnyOf1RankingsInner {
  rank?: number;
}

@Component({
  selector: 'app-ranking-page',
  standalone: true,
  imports: [
    CommonModule,
    CardModule,
    TableModule,
    AvatarModule,
    SkeletonModule,
    MessageModule,
    MedalIconPipe,
    InitialsPipe,
  ],
  templateUrl: './ranking-page.component.html',
  styleUrls: ['./ranking-page.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class RankingPageComponent implements OnInit {
  private readonly notificationsService = inject(NotificationsApiService);
  private readonly userController = inject(UserService);
  // Signals for reactive state management
  rankings = signal<RankingUser[]>([]);
  loading = signal<boolean>(true);
  error = signal<string | null>(null);

  // Computed signals
  topThree = computed(() => this.rankings().slice(0, 3));
  remainingRankings = computed(() => this.rankings().slice(3));

  ngOnInit(): void {
    this.loadRankings();
    this.subscribeToRankingUpdates();
  }

  private loadRankings(): void {
    this.loading.set(true);
    this.error.set(null);

    this.userController.userControllerGetRankings().subscribe({
      next: (rankings) => {
        this.rankings.set(
          rankings.map((user, index) => ({ ...user, rank: index + 1 }))
        );
        this.loading.set(false);
      },
      error: (err) => {
        console.error('Error loading rankings:', err);
        this.error.set('Failed to load rankings. Please try again later.');
        this.loading.set(false);
      },
    });
  }

  private subscribeToRankingUpdates(): void {
    this.notificationsService.connectToSSE().subscribe({
      next: (notification) => {
        if (notification.type === 'RANKING_UPDATE' && notification.data) {
          const data = notification.data;
          if (data.rankings) {
            this.rankings.set(
              data.rankings.map((user: RankingUser, index: number) => ({
                ...user,
                rank: index + 1,
              }))
            );
          }
        }
      },
      error: (err) => {
        console.error('SSE connection error:', err);
      },
    });
  }
}
