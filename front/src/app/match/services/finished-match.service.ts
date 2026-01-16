// obsolete: this was used for mock

import { Injectable, inject, WritableSignal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';
import { MatchHeader } from '../sections/match-header/match-header.section';
import { MatchEvent } from '../components/timeline-event/timeline-event.component';
import { Lineups } from '../sections/lineups-pitch/lineups-pitch.section';
import { TeamStats } from '../sections/team-stats/team-stats.section';
import { HeadToHead } from '../sections/head-to-head/head-to-head.section';
import { VideoHighlight } from '../components/video-card/video-card.component';
import { PredictionData } from '../sections/prediction-widget/prediction-widget.section';

/**
 * Handles REST API calls for finished match data.
 * This service is stateless - it only mutates signals passed to it.
 */
@Injectable({
  providedIn: 'root'
})
export class FinishedMatchService {
  private http = inject(HttpClient);
  private readonly API_BASE = '/api/matches';

  /**
   * Fetch all match data for a finished match
   */
  async fetchMatchData(
    matchId: string,
    matchHeaderSignal: WritableSignal<MatchHeader>,
    timelineSignal: WritableSignal<MatchEvent[]>,
    lineupsSignal: WritableSignal<Lineups>,
    statsSignal: WritableSignal<TeamStats>,
    h2hSignal: WritableSignal<HeadToHead>,
    highlightsSignal: WritableSignal<VideoHighlight[]>,
    predictionSignal: WritableSignal<PredictionData>
  ): Promise<void> {
    try {
      // Fetch all data in parallel
      const [
        headerData,
        timelineData,
        lineupsData,
        statsData,
        h2hData,
        highlightsData,
        predictionData
      ] = await Promise.all([
        this.fetchMatchHeader(matchId),
        this.fetchTimeline(matchId),
        this.fetchLineups(matchId),
        this.fetchStats(matchId),
        this.fetchH2H(matchId),
        this.fetchHighlights(matchId),
        this.fetchPrediction(matchId)
      ]);

      // Update all signals
      matchHeaderSignal.set(headerData);
      timelineSignal.set(timelineData);
      lineupsSignal.set(lineupsData);
      statsSignal.set(statsData);
      h2hSignal.set(h2hData);
      highlightsSignal.set(highlightsData);
      predictionSignal.set(predictionData);

    } catch (error) {
      console.error('Error fetching finished match data:', error);
      // In production, handle errors appropriately (show error UI, retry logic, etc.)
    }
  }

  /**
   * Fetch match header (status, teams, score)
   */
  private async fetchMatchHeader(matchId: string): Promise<MatchHeader> {
    // Mock implementation
    // In production: return firstValueFrom(this.http.get<MatchHeader>(`${this.API_BASE}/${matchId}/header`));

    return Promise.resolve({
      status: {
        isLive: false,
        status: 'FT',
        competition: 'Premier League'
      },
      homeTeam: {
        id: '1',
        name: 'Manchester City',
        shortName: 'Man City',
        logo: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDxATQOCxFeu0VbSZnfrJOdTBOsEvUGlw3vDjG9a34mtXxaggfz7ze8RsABg_8c2l6hbnoTFmcjROuBcMzw7DdzuVmx-c60W0Zl6YKvhOYIeI3T9kKCkuV9iyTqz6jmDre7mm4NzdggYmEbqZL0NO6-ltj_fM6qEnmxJDRAB-ClfqHTyni31OJM-7R3dx3JIJtMZHbe_DZbuvNa3vi1KzkJqhMni4TT5hJWvAYw-JD6iBTeln105bE7sfFJ7sgheldQD0MTRo39slbP'
      },
      awayTeam: {
        id: '2',
        name: 'Arsenal',
        shortName: 'Arsenal',
        logo: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAvL0NcFCzV8KPEdLYmseF0LGw2mvLVus_X6MBhmhp5JZgAS7I4NRZG14MN6viKH4KLo65KkCKeArZ_p4tFOeeyaCYb_eRMPocqtMm7CMalufmf8HqhwsPkc7R736nIxhjirN_MINYtYTmnJmnidsotHtbGV8dhqCzvcUM9a-ujQpWFHNRPncvA_8-sLYlcvrXFvWlhMmIxLPtzBP-FAe-25XwxqWxqvgPfBZDR6NBdmVGUP7sSGnv7b049DJP0nyX2brrgd0NSC9Hk'
      },
      score: {
        home: 2,
        away: 1,
        venue: 'Etihad Stadium'
      }
    });
  }

  /**
   * Fetch match timeline events
   */
  private async fetchTimeline(matchId: string): Promise<MatchEvent[]> {
    // Mock implementation
    return Promise.resolve([
      {
        id: '1',
        minute: 12,
        type: 'GOAL',
        team: 'home',
        player: 'E. Haaland',
        detail: 'Assist: K. De Bruyne'
      },
      {
        id: '2',
        minute: 44,
        type: 'GOAL',
        team: 'away',
        player: 'B. Saka',
        detail: 'Penalty'
      }
    ]);
  }

  /**
   * Fetch lineups
   */
  private async fetchLineups(matchId: string): Promise<Lineups> {
    // Mock implementation - return same data as page initialization
    return Promise.resolve({
      homeFormation: '4-3-3',
      awayFormation: '4-2-3-1',
      homePlayers: [],
      awayPlayers: []
    });
  }

  /**
   * Fetch team statistics
   */
  private async fetchStats(matchId: string): Promise<TeamStats> {
    // Mock implementation
    return Promise.resolve({
      stats: [
        { label: 'Possession', homeValue: 60, awayValue: 40, isPercentage: true },
        { label: 'Shots', homeValue: 12, awayValue: 5 },
        { label: 'Shots on Target', homeValue: 5, awayValue: 2 },
        { label: 'Corners', homeValue: 8, awayValue: 3 }
      ]
    });
  }

  /**
   * Fetch head-to-head data
   */
  private async fetchH2H(matchId: string): Promise<HeadToHead> {
    // Mock implementation
    return Promise.resolve({
      homeTeamLogo: 'https://example.com/home-logo.png',
      awayTeamLogo: 'https://example.com/away-logo.png',
      recentForm: ['W', 'D', 'L', 'W', 'L']
    });
  }

  /**
   * Fetch video highlights
   */
  private async fetchHighlights(matchId: string): Promise<VideoHighlight[]> {
    // Mock implementation
    return Promise.resolve([
      {
        id: '1',
        title: 'Goal Highlight: E. Haaland opens the score',
        thumbnail: 'https://example.com/thumbnail1.jpg',
        duration: '02:14',
        url: '#'
      }
    ]);
  }

  /**
   * Fetch prediction data
   */
  private async fetchPrediction(matchId: string): Promise<PredictionData> {
    // Mock implementation
    return Promise.resolve({
      totalVotes: 12500,
      homePercentage: 45,
      drawPercentage: 20,
      awayPercentage: 35
    });
  }
}
