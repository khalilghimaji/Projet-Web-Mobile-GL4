import {
  Component,
  OnInit,
  signal,
  inject,
  ChangeDetectionStrategy,
  viewChild,
  ElementRef,
  afterNextRender,
} from '@angular/core';
import { fromEvent } from 'rxjs';
import { CommonModule } from '@angular/common';
import { CardModule } from 'primeng/card';
import { TableModule } from 'primeng/table';
import { AvatarModule } from 'primeng/avatar';
import { SkeletonModule } from 'primeng/skeleton';
import { MessageModule } from 'primeng/message';
import { NotificationsStateService } from '../../services/notifications-state.service';
import { UserService } from '../../services/Api';
import { MedalIconPipe } from '../../shared/pipes/medal-icon.pipe';
import { InitialsPipe } from '../../shared/pipes/initials.pipe';

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
  private readonly notificationsState = inject(NotificationsStateService);
  private readonly userController = inject(UserService);
  private reloadBtn = viewChild<ElementRef<HTMLButtonElement>>('reloadBtn');

  // Signals for reactive state management
  loading = signal<boolean>(true);
  error = signal<string | null>(null);

  // Get rankings from state service
  rankings = this.notificationsState.rankings;
  topThree = this.notificationsState.topThreeRankings;
  remainingRankings = this.notificationsState.remainingRankings;

  constructor() {
    // Setup fromEvent listener after view is rendered
    afterNextRender(() => {
      const btnElement = this.reloadBtn()?.nativeElement;
      if (btnElement) {
        fromEvent(btnElement, 'click').subscribe(() => {
          this.loadRankings();
        });
      }
    });
  }

  ngOnInit(): void {
    this.loadRankings();
  }

  private loadRankings(): void {
    this.loading.set(true);
    this.error.set(null);

    this.userController.userControllerGetRankings().subscribe({
      next: (rankings) => {
        this.notificationsState.setRankings(
          rankings.map((user, index) => ({ ...user, rank: index + 1 })),
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
}
