import { Component, ChangeDetectionStrategy, input, output, computed, viewChild, ElementRef, DestroyRef, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { League } from '../../types/fixture.types';
import { fromEvent, of } from 'rxjs';
import { switchMap, filter } from 'rxjs/operators';
import { takeUntilDestroyed, toObservable } from '@angular/core/rxjs-interop';

@Component({
  selector: 'app-league-filter-chip',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './league-filter-chip.component.html',
  styleUrls: ['./league-filter-chip.component.css']
})
export class LeagueFilterChipComponent {
  league = input.required<League | null>();
  selectedLeagueId = input.required<string>();
  chipClicked = output<string>();

  private destroyRef = inject(DestroyRef);
  chipButtonRef = viewChild<ElementRef>('chipButton');

  isAllLeagues = computed(() => this.league() === null);

  isSelected = computed(() => {
    const league = this.league();
    const selectedId = this.selectedLeagueId();

    if (league === null) {
      return selectedId === 'all';
    }

    return league.league_key === selectedId;
  });

  constructor() {
    // Optimisation fromEvent pour les clics sur le chip
    toObservable(this.chipButtonRef)
      .pipe(
        switchMap((ref) => {
          if (!ref?.nativeElement) return of(null);
          return fromEvent<MouseEvent>(ref.nativeElement, 'click').pipe(
            takeUntilDestroyed(this.destroyRef)
          );
        }),
        filter((event): event is MouseEvent => event !== null)
      )
      .subscribe(() => {
        const league = this.league();
        const leagueId = league === null ? 'all' : league.league_key;
        this.chipClicked.emit(leagueId);
      });
  }
}

