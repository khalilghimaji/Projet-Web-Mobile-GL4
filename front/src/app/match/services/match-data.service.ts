import { Injectable, inject, WritableSignal } from '@angular/core';
import { LiveMatchService } from './live-match.service';
import { FinishedMatchService } from './finished-match.service';
import { MatchHeader } from '../sections/match-header/match-header.section';
import { MatchEvent } from '../components/timeline-event/timeline-event.component';
import { Lineups } from '../sections/lineups-pitch/lineups-pitch.section';
import { TeamStats } from '../sections/team-stats/team-stats.section';
import { HeadToHead } from '../sections/head-to-head/head-to-head.section';
import { VideoHighlight } from '../components/video-card/video-card.component';
import { PredictionData, VoteOption } from '../sections/prediction-widget/prediction-widget.section';

/**
 * Coordinates data fetching for both live and finished matches.
 * This service is stateless - it only mutates signals passed to it.
 */
@Injectable({
  providedIn: 'root'
})
export class MatchDataService {
  private liveMatchService = inject(LiveMatchService);
  private finishedMatchService = inject(FinishedMatchService);

  private currentMatchId: string | null = null;
  private isLive = false;

  /**
   * Initialize match data by determining if match is live or finished,
   * then connecting to appropriate data source.
   */
  initializeMatch(
    matchId: string,
    matchHeaderSignal: WritableSignal<MatchHeader>,
    timelineSignal: WritableSignal<MatchEvent[]>,
    lineupsSignal: WritableSignal<Lineups>,
    statsSignal: WritableSignal<TeamStats>,
    h2hSignal: WritableSignal<HeadToHead>,
    highlightsSignal: WritableSignal<VideoHighlight[]>,
    predictionSignal: WritableSignal<PredictionData>
  ): void {
    this.currentMatchId = matchId;

    // Check if match is live (this would normally be an API call)
    this.checkMatchStatus(matchId).then(status => {
      this.isLive = status.isLive;

      if (this.isLive) {
        // Connect to WebSocket for live updates
        this.liveMatchService.connect(
          matchId,
          matchHeaderSignal,
          timelineSignal,
          lineupsSignal,
          statsSignal,
          highlightsSignal
        );
      } else {
        // Fetch finished match data via REST
        this.finishedMatchService.fetchMatchData(
          matchId,
          matchHeaderSignal,
          timelineSignal,
          lineupsSignal,
          statsSignal,
          h2hSignal,
          highlightsSignal,
          predictionSignal
        );
      }
    });
  }

  /**
   * Submit a prediction vote
   */
  submitVote(
    option: VoteOption,
    predictionSignal: WritableSignal<PredictionData>
  ): void {
    if (!this.currentMatchId) return;

    // Optimistically update UI
    const current = predictionSignal();
    predictionSignal.set({
      ...current,
      userVote: option
    });

    // Send to backend (mock for now)
    console.log(`Vote submitted for match ${this.currentMatchId}: ${option}`);

    // In real implementation:
    // this.http.post(`/api/matches/${this.currentMatchId}/vote`, { option })
    //   .subscribe(response => {
    //     predictionSignal.set(response.updatedPrediction);
    //   });
  }

  /**
   * Check if match is currently live
   */
  private async checkMatchStatus(matchId: string): Promise<{ isLive: boolean }> {
    // Mock implementation
    // In real app: return this.http.get(`/api/matches/${matchId}/status`).toPromise();
    return Promise.resolve({ isLive: true });
  }

  /**
   * Cleanup connections when component is destroyed
   */
  cleanup(): void {
    if (this.isLive && this.currentMatchId) {
      this.liveMatchService.disconnect(this.currentMatchId);
    }
    this.currentMatchId = null;
  }
}
