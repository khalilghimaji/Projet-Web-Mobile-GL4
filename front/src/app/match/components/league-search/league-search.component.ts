import { Component, ChangeDetectionStrategy, input, output, signal, computed, DestroyRef, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Subject } from 'rxjs';
import { debounceTime, distinctUntilChanged } from 'rxjs/operators';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { League } from '../../types/fixture.types';


@Component({
  selector: 'app-league-search',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './league-search.component.html',
  styleUrls: ['./league-search.component.css']
})
export class LeagueSearchComponent implements OnInit {
  private destroyRef = inject(DestroyRef);

  leagues = input.required<League[]>();
  placeholder = input<string>('Search leagues (e.g., Premier League, La Liga...)');
  minChars = input<number>(2);
  maxResults = input<number>(10);
  currentLeagueId = input<string>('all');

  leagueSelected = output<League>();
  searchQueryChange = output<string>();
  clearFilter = output<void>();

  rawSearchQuery = signal<string>('');
  searchQuery = signal<string>('');

  private searchSubject$ = new Subject<string>();

  showClearFilterButton = computed(() => {
    return this.currentLeagueId() !== 'all';
  });

  filteredLeagues = computed(() => {
    const query = this.searchQuery().toLowerCase().trim();
    const allLeagues = this.leagues();

    if (!query || query.length < this.minChars()) {
      return [];
    }

    return allLeagues
      .filter(league =>
        league.league_name.toLowerCase().includes(query) ||
        league.country_name.toLowerCase().includes(query)
      )
      .slice(0, this.maxResults());
  });

  ngOnInit(): void {
    this.searchSubject$
      .pipe(
        debounceTime(500),
        distinctUntilChanged(),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe(searchText => {
        console.log('Search query (debounced):', searchText);
        this.searchQuery.set(searchText);
        this.searchQueryChange.emit(searchText);
      });
  }

  onSearchInput(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    this.rawSearchQuery.set(value);
    this.searchSubject$.next(value);
  }

  onClear(): void {
    this.rawSearchQuery.set('');
    this.searchQuery.set('');
    this.searchQueryChange.emit('');
  }

  onLeagueClick(league: League): void {
    this.leagueSelected.emit(league);
    this.rawSearchQuery.set('');
    this.searchQuery.set('');
    this.searchQueryChange.emit('');
  }

  onShowAllLeagues(): void {
    this.clearFilter.emit();
  }
}
