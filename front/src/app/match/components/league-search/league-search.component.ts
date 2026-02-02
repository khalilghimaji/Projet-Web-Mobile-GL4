import { Component, ChangeDetectionStrategy, input, output, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { League } from '../../types/fixture.types';


@Component({
  selector: 'app-league-search',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './league-search.component.html',
  styleUrls: ['./league-search.component.css']
})
export class LeagueSearchComponent {
  leagues = input.required<League[]>();
  placeholder = input<string>('Search leagues (e.g., Premier League, La Liga...)');
  minChars = input<number>(2);
  maxResults = input<number>(10);
  currentLeagueId = input<string>('all');

  leagueSelected = output<League>();
  searchQueryChange = output<string>();
  clearFilter = output<void>();

  searchQuery = signal<string>('');

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

  onSearchInput(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    this.searchQuery.set(value);
    this.searchQueryChange.emit(value);
  }

  onClear(): void {
    this.searchQuery.set('');
    this.searchQueryChange.emit('');
  }

  onLeagueClick(league: League): void {
    this.leagueSelected.emit(league);
    this.searchQuery.set('');
    this.searchQueryChange.emit('');
  }

  onShowAllLeagues(): void {
    this.clearFilter.emit();
  }
}
