import {
  Component,
  ChangeDetectionStrategy,
  inject,
  signal,
  Signal,
  computed,
  effect,
  input,
  linkedSignal,
  OnInit,
  numberAttribute,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { TeamService } from '../../../services/team.service';
import { ActivatedRoute, Router } from '@angular/router';
import { toSignal } from '@angular/core/rxjs-interop';
import { TeamHeaderComponent } from '../../components/team-header/team-header.component';
import { NextMatchComponent } from '../../components/next-match/next-match.component';
import { RecentMatchesComponent } from '../../components/recent-matches/recent-matches.component';
import { SquadSectionComponent } from '../../components/squad-section/squad-section.component';
import { Fixture } from '../../../models/models';
import { AsyncPipe } from '@angular/common';

@Component({
  selector: 'app-team-detail-page',
  imports: [
    CommonModule,
    TeamHeaderComponent,
    NextMatchComponent,
    RecentMatchesComponent,
    SquadSectionComponent,
  ],
  templateUrl: './team-detail-page.component.html',
  styleUrl: './team-detail-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class TeamDetailPageComponent {
  private readonly teamService = inject(TeamService);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);

  id = input.required<number>();
  teamId = computed(() => Number(this.id()));

  private readonly DAYS_PER_PAGE = 15;
  private readonly MAX_DAYS = 100;

  //fetching team + players
  teamResource = this.teamService.getTeamResource(this.id);

  // fecthing next match
  nextMatchResource = this.teamService.getNextMatchResource(this.id);

  // fecthing recent matches

  realDaysOffset = signal(0);
  hasMoreToLoad = computed(() => this.realDaysOffset() < this.MAX_DAYS);

  accumulatedMatches = linkedSignal<Fixture[] | undefined, Fixture[]>({
    source: () => this.recentMatchesResource.value(),
    computation: (newMatches, previous) => {
      const currentMatches = previous?.value ?? [];
      if (!newMatches || newMatches.length === 0) return currentMatches;

      return [...currentMatches, ...newMatches];
    },
  });

  constructor() {
    // reset pagination when team changes
    effect(() => {
      this.id();
      this.realDaysOffset.set(0);
      this.accumulatedMatches.set([]);
    });
  }

  recentMatchesResource = this.teamService.getRecentMatchesResource(
      this.id,
      computed(() => this.realDaysOffset() + this.DAYS_PER_PAGE),
      this.realDaysOffset
    );


  //load next batch of matches (15 more days)

  loadMoreMatches(): void {
    if (this.hasMoreToLoad() && !this.recentMatchesResource.isLoading()) {
      this.realDaysOffset.update((offset) => offset + this.DAYS_PER_PAGE);
      console.log('Loading more matches, new offset:', this.realDaysOffset());
    }
  }

  incrementTeamId(): void {
    const currentId = this.id();
    const nextId = Number(currentId) + 1;
    this.router.navigate(['/team', nextId]);
  }

  decrementTeamId(): void {
    const currentId = this.id();
    const prevId = Number(currentId) - 1;
    if (prevId > 0) {
      this.router.navigate(['/team', prevId]);
    }
  }
}
