import { Component, ChangeDetectionStrategy, input, output, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { League } from '../../types/fixture.types';

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

  isAllLeagues = computed(() => this.league() === null);

  isSelected = computed(() => {
    const league = this.league();
    const selectedId = this.selectedLeagueId();

    if (league === null) {
      return selectedId === 'all';
    }

    return league.league_key === selectedId;
  });
}

