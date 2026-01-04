import { Component, ChangeDetectionStrategy, inject, signal, computed, effect } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TeamService } from '../../services/team.service';
import { ActivatedRoute, Router } from '@angular/router';
import { toSignal } from '@angular/core/rxjs-interop';
import { 
  map, 
  switchMap, 
  scan, 
  catchError, 
  EMPTY, 
  tap, 
  finalize, 
  BehaviorSubject, 
  concatMap, 
  takeWhile,
  Observable 
} from 'rxjs';
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
    AsyncPipe
  ],
  templateUrl: './team-detail-page.component.html',
  styleUrl: './team-detail-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class TeamDetailPageComponent {

  private readonly teamService = inject(TeamService);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  
  teamId = toSignal(
    this.route.params.pipe(map(params => Number(params['id']))),
    { requireSync: true }
  );

  
  //fetching team + players
  teamResource = this.teamService.getTeamResource(this.teamId);

  // fecthing next match
  nextMatchResource = this.teamService.getNextMatchResource(this.teamId);


  // fecthing recent matches 
  private readonly DAYS_PER_PAGE = 15;
  private readonly MAX_DAYS = 45;
  
  // BehaviorSubjects for pagination
  demandedDaysOffset$ = new BehaviorSubject<number>(0);
  realDaysOffset$ = new BehaviorSubject<number>(0);
  hasMoreMatches$ = new BehaviorSubject<boolean>(true);

  matches$: Observable<Fixture[]> = this.route.params.pipe(
    map(params => Number(params['id'])),
    switchMap(teamId => 
      this.demandedDaysOffset$.pipe(
    scan(
      (acc, cur) => ({
        previous: acc.current,
        current: cur,
        difference: this.DAYS_PER_PAGE
      }),
      {
        previous: null as number | null,
        current: null as number | null,
        difference: this.DAYS_PER_PAGE
      } as {
        previous: number | null;
        current: number | null;
        difference: number;
      }
    ),
        map(({ current, difference }) => ({
          fromDaysAgo: current! + difference,
          toDaysAgo: current!
        })),
        concatMap((range) =>
          this.teamService.fetchMatchesByRange(
            teamId,
            range.fromDaysAgo,
            range.toDaysAgo
          )
        ),
        takeWhile((matches) => matches.length > 0, false),
        scan(
          (allMatches, newMatches) => [...allMatches, ...newMatches],
          [] as Fixture[]
        ),
        tap(() => this.realDaysOffset$.next(this.realDaysOffset$.getValue() + this.DAYS_PER_PAGE)),
        finalize(() => this.hasMoreMatches$.next(false)),
        catchError((err) => {
          console.error('Error loading matches', err);
          return EMPTY;
        })
      )
    )
  );

  cachedMatches = toSignal(this.matches$, { initialValue: [] });
  hasMoreToLoad = toSignal(this.hasMoreMatches$, { initialValue: true });


  constructor() {
    // reset pagination when team changes
    effect(() => {
      const teamId = this.teamId();
      this.demandedDaysOffset$.next(0);
      this.realDaysOffset$.next(0);
      this.hasMoreMatches$.next(true);
    });
  }

    //load next batch of matches (15 more days)

  loadMoreMatches(): void {
    if (this.hasMoreToLoad() && this.realDaysOffset$.getValue() < this.MAX_DAYS) {
      const currentOffset = this.realDaysOffset$.getValue();
      this.demandedDaysOffset$.next(currentOffset);
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
