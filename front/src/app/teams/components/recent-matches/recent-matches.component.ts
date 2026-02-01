import { Component, ChangeDetectionStrategy, input , computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Fixture } from '../../models/models';
import { LucideAngularModule, TrendingUp } from 'lucide-angular';

@Component({
  selector: 'app-recent-matches',
  imports: [CommonModule, LucideAngularModule],
  templateUrl: './recent-matches.component.html',
  styleUrl: './recent-matches.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class RecentMatchesComponent {
  // Input signals
  matches = input.required<Fixture[]>();
  teamKey = input.required<number>();





  /**
   * Check if match is a win for the team
   */
  isWin(match: Fixture, teamKey: number): boolean {
    if (!match.event_final_result) return false;
    const [homeScore, awayScore] = match.event_final_result.split('-').map(Number);
    const isHome = Number(match.home_team_key) == teamKey;
    return isHome ? homeScore > awayScore : awayScore > homeScore;
  }

  /**
   * Check if match is a draw
   */
  isDraw(match: Fixture): boolean {
    if (!match.event_final_result) return false;
    const [homeScore, awayScore] = match.event_final_result.split('-').map(Number);
    return homeScore === awayScore;
  }

  /**
   * Check if match is a loss for the team
   */
  isLoss(match: Fixture, teamKey: number): boolean {
    if (!match.event_final_result) return false;
    const [homeScore, awayScore] = match.event_final_result.split('-').map(Number);
    const isHome = Number(match.home_team_key) === teamKey;
    return isHome ? homeScore < awayScore : awayScore < homeScore;
  }

  /**
   * Get match result text
   */
  getMatchResult(match: Fixture, teamKey: number): string {
    if (!match.event_final_result) return 'N/A';
    if (this.isWin(match, teamKey)) return 'WIN';
    if (this.isDraw(match)) return 'DRAW';
    if (this.isLoss(match, teamKey)) return 'LOSS';
    return 'N/A';
  }

  // Icons
  readonly TrendingUp = TrendingUp;
}
