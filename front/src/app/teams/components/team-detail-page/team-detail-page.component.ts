import { Component, ChangeDetectionStrategy, inject, signal, computed, effect, input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TeamService } from '../../services/team.service';
import { ActivatedRoute, Router } from '@angular/router';
import { toSignal } from '@angular/core/rxjs-interop';
import { TeamHeaderComponent } from '../team-header/team-header.component';
import { NextMatchComponent } from '../next-match/next-match.component';
import { RecentMatchesComponent } from '../recent-matches/recent-matches.component';
import { SquadSectionComponent } from '../squad-section/squad-section.component';
import { Fixture } from '../../models/models';
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
  private readonly MAX_DAYS = 45;


  //fetching team + players
  teamResource = this.teamService.getTeamResource(this.teamId);

  // fecthing next match
  nextMatchResource = this.teamService.getNextMatchResource(this.teamId);


  // fecthing recent matches


  realDaysOffset = signal(0);
  toDaysOffset = signal(0);
  hasMoreToLoad = computed(() => this.realDaysOffset() < this.MAX_DAYS);

  accumulatedMatches = signal<Fixture[]>([]);

  recentMatchesResource = this.teamService.getRecentMatchesResource(
    this.teamId,
    computed(() => this.realDaysOffset() + this.DAYS_PER_PAGE),
    this.toDaysOffset
  );



  constructor() {
    // reset pagination when team changes
    effect(() => {
      this.teamId();
      this.realDaysOffset.set(0);
      this.accumulatedMatches.set([]);
    });


    effect(() => {
      const newMatches = this.recentMatchesResource.value();
      if (newMatches && newMatches.length > 0) {

        this.accumulatedMatches.update(current => [...current, ...newMatches]);
      }
    });
  }

    //load next batch of matches (15 more days)

  loadMoreMatches(): void {
    if (this.hasMoreToLoad() && !this.recentMatchesResource.isLoading()) {
      this.realDaysOffset.update(offset => offset + this.DAYS_PER_PAGE);
    }
  }


  incrementTeamId(): void {
    const currentId = this.teamId();
    const nextId = currentId + 1;
    this.router.navigate(['/team', nextId]);
  }


  decrementTeamId(): void {
    const currentId = this.teamId();
    const prevId = currentId - 1;
    if (prevId > 0) {
      this.router.navigate(['/team', prevId]);
    }
  }
}
