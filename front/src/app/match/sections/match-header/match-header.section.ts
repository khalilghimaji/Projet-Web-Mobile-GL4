import {Component, ChangeDetectionStrategy, computed, Input, Signal} from '@angular/core';
import { CommonModule } from '@angular/common';
import { StatusBadgeComponent, MatchStatus } from '../../components/status-badge/status-badge.component';
import { TeamDisplayComponent, Team } from '../../components/team-display/team-display.component';
import { ScoreDisplayComponent, Score } from '../../components/score-display/score-display.component';
import { MatchTimerComponent } from '../../components/match-timer/match-timer.component';

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
    ScoreDisplayComponent,
    MatchTimerComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './match-header.section.html',
  styleUrl: './match-header.section.css'
})
export class MatchHeaderSection {
  @Input({required:true}) matchHeaderSignal!: Signal<MatchHeader>;

  statusSignal = computed(() => this.matchHeaderSignal().status);
  homeTeamSignal = computed(() => this.matchHeaderSignal().homeTeam);
  awayTeamSignal = computed(() => this.matchHeaderSignal().awayTeam);
  scoreSignal = computed(() => this.matchHeaderSignal().score);

  timerStatusSignal = computed(() => {
    const status = this.matchHeaderSignal().status;
    return {
      status: status.status,
      minute: status.minute || 0,
      isLive: status.isLive
    };
  });
}
