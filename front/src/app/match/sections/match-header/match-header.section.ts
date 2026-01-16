import {Component, ChangeDetectionStrategy, input, computed, Input, Signal} from '@angular/core';
import { CommonModule } from '@angular/common';
import { StatusBadgeComponent, MatchStatus } from '../../components/status-badge/status-badge.component';
import { TeamDisplayComponent, Team } from '../../components/team-display/team-display.component';
import { ScoreDisplayComponent, Score } from '../../components/score-display/score-display.component';

export interface MatchHeader {
  status: MatchStatus;
  homeTeam: Team;
  awayTeam: Team;
  score: Score;
}

@Component({
  selector: 'app-match-header',
  standalone: true,
  imports: [
    CommonModule,
    StatusBadgeComponent,
    TeamDisplayComponent,
    ScoreDisplayComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="relative px-4 pt-6 pb-2">
      <div class="flex flex-col items-center">
        <!-- Status Badge -->
        <div class="mb-4">
          <app-status-badge [statusSignal]="statusSignal" />
        </div>

        <!-- Teams and Score -->
        <div class="flex items-center justify-between w-full max-w-sm px-4">
          <!-- Home Team -->
          <app-team-display [teamSignal]="homeTeamSignal" />

          <!-- Score -->
          <app-score-display [scoreSignal]="scoreSignal" />

          <!-- Away Team -->
          <app-team-display [teamSignal]="awayTeamSignal" />
        </div>
      </div>
    </div>
  `,
  styles: [`
    :host {
      display: block;
    }
  `]
})
export class MatchHeaderSection {
  // Signal reference from parent (page)
  @Input({required:true}) matchHeaderSignal!: Signal<MatchHeader>;

  // Derived signals for child components
  statusSignal = computed(() => this.matchHeaderSignal().status);
  homeTeamSignal = computed(() => this.matchHeaderSignal().homeTeam);
  awayTeamSignal = computed(() => this.matchHeaderSignal().awayTeam);
  scoreSignal = computed(() => this.matchHeaderSignal().score);
}
