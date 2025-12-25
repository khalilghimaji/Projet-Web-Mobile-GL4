import { Component, ChangeDetectionStrategy, computed, inject} from '@angular/core';
import { CommonModule } from '@angular/common';
import { TeamService } from '../../services/team.service';
import { ActivatedRoute } from '@angular/router';
import { toSignal } from '@angular/core/rxjs-interop';
import { map } from 'rxjs/operators';
import { Team, Player, Fixture } from '../../models/models';

@Component({
  selector: 'app-team-detail-page',
  imports: [CommonModule],
  templateUrl: './team-detail-page.component.html',
  styleUrl: './team-detail-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class TeamDetailPageComponent {

  private readonly teamService = inject(TeamService);
  private readonly route = inject(ActivatedRoute);
  teamId = toSignal(
    this.route.params.pipe(map(params => Number(params['id']))),
    { requireSync: true }
    
  );

  teamResource = this.teamService.getTeamResource(this.teamId);
  matchesResource = this.teamService.getRecentMatchesResource(this.teamId);
  nextMatchResource = this.teamService.getNextMatchResource(this.teamId);

  /**
   * Filter players by position
   */
  getPlayersByPosition(players: Player[], position: string): Player[] {
    return players.filter(p => p.player_type === position);
  }

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
}
