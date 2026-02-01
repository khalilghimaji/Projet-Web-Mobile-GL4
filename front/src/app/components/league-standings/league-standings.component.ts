import {
  Component,
  Input,
  inject,
  computed,
  signal,
  input,
  ChangeDetectionStrategy,
  DestroyRef,
  viewChild,
  ElementRef,
  viewChildren,
} from '@angular/core';
import { CommonModule, DatePipe } from '@angular/common';
import { StandingsService } from '../../services/standings.service';
import { StandingEntry } from '../../models/models';
import { LoadingComponent } from '../loading/loading.component';
import { Router } from '@angular/router';
import { toObservable, takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { switchMap, map } from 'rxjs/operators';
import { fromEvent, of, merge } from 'rxjs';

@Component({
  selector: 'app-league-standings',
  standalone: true,
  imports: [CommonModule, LoadingComponent, DatePipe],
  templateUrl: './league-standings.component.html',
  styleUrl: './league-standings.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class LeagueStandingsComponent {
  leagueId = input.required<string>();
  standingsService = inject(StandingsService);
  router = inject(Router);

  private destroRef = inject(DestroyRef);
  standingsTable = viewChild<ElementRef>('standingsTable');

  constructor() {
    toObservable(this.standingsTable)
      .pipe(
        switchMap((table) => {
          if (!table) return of(null);
          return fromEvent<MouseEvent>(table.nativeElement, 'click');
        }),
        takeUntilDestroyed(this.destroRef),
      )
      .subscribe((event) => {
        if (!event) return;
        const target = event.target as HTMLElement;
        const row = target.closest('tr');
        const teamId = row?.dataset['teamId'];
        if (teamId) {
          this.goToTeam(teamId);
        }
      });
  }

  selectedView = signal<'total' | 'home' | 'away'>('total');

  standingsRes = this.standingsService.getStandingsResource(() =>
    this.leagueId(),
  );

  currentStandings = computed(() => {
    const data = this.standingsRes.value();
    if (!data) return [] as StandingEntry[];

    return data.result[this.selectedView()];
  });

  setView(view: 'total' | 'home' | 'away') {
    this.selectedView.set(view);
  }

  backToLeagues() {
    this.router.navigate(['/standings']);
  }

  goToTeam(teamId: string) {
    this.router.navigate(['/team', teamId]);
  }

  isPositive = (val: string) => parseInt(val) > 0;
  isNegative = (val: string) => parseInt(val) < 0;
}
