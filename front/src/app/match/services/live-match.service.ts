import { Injectable, WritableSignal } from '@angular/core';
import { MatchHeader } from '../sections/match-header/match-header.section';
import { MatchEvent } from '../components/timeline-event/timeline-event.component';
import { Lineups } from '../sections/lineups-pitch/lineups-pitch.section';
import { TeamStats } from '../sections/team-stats/team-stats.section';
import { VideoHighlight } from '../components/video-card/video-card.component';

/**
 * Handles WebSocket connections for live match updates.
 * This service is stateless - it only mutates signals passed to it.
 */
@Injectable({
  providedIn: 'root'
})
export class LiveMatchService {
  private connections = new Map<string, WebSocket>();

  /**
   * Connect to WebSocket for live match updates
   */
  connect(
    matchId: string,
    matchHeaderSignal: WritableSignal<MatchHeader>,
    timelineSignal: WritableSignal<MatchEvent[]>,
    lineupsSignal: WritableSignal<Lineups>,
    statsSignal: WritableSignal<TeamStats>,
    highlightsSignal: WritableSignal<VideoHighlight[]>
  ): void {
    // Prevent duplicate connections
    if (this.connections.has(matchId)) {
      return;
    }

    // In real implementation, connect to actual WebSocket server
    // const ws = new WebSocket(`wss://api.example.com/matches/${matchId}/live`);

    // Mock WebSocket with simulated updates
    const mockWs = this.createMockWebSocket(
      matchId,
      matchHeaderSignal,
      timelineSignal,
      statsSignal
    );

    this.connections.set(matchId, mockWs as any);
  }

  /**
   * Disconnect WebSocket for a specific match
   */
  disconnect(matchId: string): void {
    const ws = this.connections.get(matchId);
    if (ws) {
      ws.close();
      this.connections.delete(matchId);
    }
  }

  /**
   * Mock WebSocket that simulates real-time updates
   * In production, replace this with actual WebSocket implementation
   */
  private createMockWebSocket(
    matchId: string,
    matchHeaderSignal: WritableSignal<MatchHeader>,
    timelineSignal: WritableSignal<MatchEvent[]>,
    statsSignal: WritableSignal<TeamStats>
  ): { close: () => void } {
    // Simulate periodic updates
    const interval = setInterval(() => {
      // Update match minute
      const currentHeader = matchHeaderSignal();
      if (currentHeader.status.minute && currentHeader.status.minute < 90) {
        matchHeaderSignal.update(header => ({
          ...header,
          status: {
            ...header.status,
            minute: header.status.minute! + 1
          }
        }));
      }

      // Simulate random stat updates
      if (Math.random() > 0.7) {
        statsSignal.update(stats => ({
          ...stats,
          stats: stats.stats.map(stat => ({
            ...stat,
            homeValue: stat.homeValue + (Math.random() > 0.5 ? 1 : 0),
            awayValue: stat.awayValue + (Math.random() > 0.5 ? 1 : 0)
          }))
        }));
      }

      // Simulate new events (rare)
      if (Math.random() > 0.95) {
        const newEvent: MatchEvent = {
          id: `event_${Date.now()}`,
          minute: currentHeader.status.minute || 78,
          type: 'YELLOW_CARD',
          team: Math.random() > 0.5 ? 'home' : 'away',
          player: 'Player Name',
          detail: 'Foul'
        };

        timelineSignal.update(events => [...events, newEvent]);
      }
    }, 2000);

    // Return mock WebSocket object
    return {
      close: () => clearInterval(interval)
    };
  }

  /**
   * Example of how to handle real WebSocket messages
   */
  private handleWebSocketMessage(
    message: any,
    matchHeaderSignal: WritableSignal<MatchHeader>,
    timelineSignal: WritableSignal<MatchEvent[]>,
    statsSignal: WritableSignal<TeamStats>
  ): void {
    const { type, data } = message;

    switch (type) {
      case 'MATCH_UPDATE':
        matchHeaderSignal.update(header => ({
          ...header,
          status: { ...header.status, ...data.status },
          score: { ...header.score, ...data.score }
        }));
        break;

      case 'NEW_EVENT':
        timelineSignal.update(events => [...events, data.event]);
        break;

      case 'STATS_UPDATE':
        statsSignal.update(stats => ({
          ...stats,
          stats: data.stats
        }));
        break;

      default:
        console.warn('Unknown WebSocket message type:', type);
    }
  }
}
