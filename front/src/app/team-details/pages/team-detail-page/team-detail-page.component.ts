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

  private readonly DAYS_PER_PAGE = 30;
  private readonly MAX_DAYS = 120;

  //fetching team + players
  teamResource = this.teamService.getTeamResource(this.id);

  // fecthing next match
  nextMatchResource = this.teamService.getNextMatchResource(this.id);

  // fecthing recent matches

  hasMoreToLoad = computed(() => this.realDaysOffset() < this.MAX_DAYS);

  realDaysOffset = linkedSignal({
    source: () => this.id(),
    computation: () => {
      console.log('resetting');
      return 0;
    },
  });

  recentMatchesResource = this.teamService.getRecentMatchesResource(
    this.id,
    computed(() => this.realDaysOffset() + this.DAYS_PER_PAGE),
    this.realDaysOffset
  );

  //load next batch of matches (30 more days)

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

  accumulatedMatches = linkedSignal<
    { id: number; matches: Fixture[] | undefined },
    Fixture[]
  >({
    source: () => ({
      id: this.id(),
      matches: this.recentMatchesResource.value(),
    }),
    computation: (source, previous) => {
      // if we have a new team
      const isNewTeam = previous && source.id !== previous.source.id;

      if (isNewTeam) {
        return source.matches ?? [];
      }

      // if the resource value still undefined because off fetching
      if (!source.matches) {
        return previous ? previous.value : [];
      }

      console.log(previous!.value, 'then vs now', source.matches);

      //appending new matches

      const existing = previous!.value;

      const newUniqueMatches = source.matches.filter(
        (newM) => !existing.find((oldM) => oldM.event_key === newM.event_key)
      );

      
      const updatedList = [...existing, ...newUniqueMatches];

      

      return updatedList;
    },
  });
}
