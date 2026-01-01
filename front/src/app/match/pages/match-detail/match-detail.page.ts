import { Component, ChangeDetectionStrategy, signal, inject, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';

// Services
import { MatchDataService } from '../../services/match-data.service';

// Sections
import { MatchHeaderSection, MatchHeader } from '../../sections/match-header/match-header.section';
import { PredictionWidgetSection, PredictionData, VoteOption } from '../../sections/prediction-widget/prediction-widget.section';
import { TabsNavigationSection, TabType } from '../../sections/tabs-navigation/tabs-navigation.section';
import { MatchTimelineSection } from '../../sections/match-timeline/match-timeline.section';
import { LineupsPitchSection, Lineups } from '../../sections/lineups-pitch/lineups-pitch.section';
import { TeamStatsSection, TeamStats } from '../../sections/team-stats/team-stats.section';
import { HeadToHeadSection, HeadToHead } from '../../sections/head-to-head/head-to-head.section';
import { HighlightsSection } from '../../sections/highlights/highlights.section';

// Types
import { MatchEvent } from '../../components/timeline-event/timeline-event.component';
import { VideoHighlight } from '../../components/video-card/video-card.component';

@Component({
  selector: 'app-match-detail',
  standalone: true,
  imports: [
    CommonModule,
    MatchHeaderSection,
    PredictionWidgetSection,
    TabsNavigationSection,
    MatchTimelineSection,
    LineupsPitchSection,
    TeamStatsSection,
    HeadToHeadSection,
    HighlightsSection
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './match-detail.page.html',
  styleUrls: ['./match-detail.page.css']
})
export class MatchDetailPage implements OnInit, OnDestroy {
  // Injected dependencies
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private matchDataService = inject(MatchDataService);

  // State signals - owned by this page
  matchHeaderSignal = signal<MatchHeader>({
    status: {
      isLive: true,
      minute: 78,
      status: 'LIVE',
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

  timelineSignal = signal<MatchEvent[]>([
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
    },
    {
      id: '3',
      minute: 56,
      type: 'YELLOW_CARD',
      team: 'home',
      player: 'Rodri',
      detail: 'Foul'
    },
    {
      id: '4',
      minute: 62,
      type: 'SUBSTITUTION',
      team: 'away',
      player: 'Trossard',
      detail: 'OUT: Martinelli'
    }
  ]);

  lineupsSignal = signal<Lineups>({
    homeFormation: '4-3-3',
    awayFormation: '4-2-3-1',
    homePlayers: [
      // GK
      { number: 31, name: 'Ederson', position: { x: '50%', y: '8%' }, team: 'home', isGoalkeeper: true },
      // DEF
      { number: 2, name: 'Walker', position: { x: '15%', y: '20%' }, team: 'home' },
      { number: 3, name: 'Dias', position: { x: '38%', y: '20%' }, team: 'home' },
      { number: 5, name: 'Stones', position: { x: '62%', y: '20%' }, team: 'home' },
      { number: 24, name: 'Gvardiol', position: { x: '85%', y: '20%' }, team: 'home' },
      // MID
      { number: 16, name: 'Rodri', position: { x: '25%', y: '35%' }, team: 'home' },
      { number: 17, name: 'KDB', position: { x: '50%', y: '35%' }, team: 'home' },
      { number: 20, name: 'Bernardo', position: { x: '75%', y: '35%' }, team: 'home' },
      // FWD
      { number: 47, name: 'Foden', position: { x: '20%', y: '48%' }, team: 'home' },
      { number: 9, name: 'Haaland', position: { x: '50%', y: '48%' }, team: 'home' },
      { number: 11, name: 'Doku', position: { x: '80%', y: '48%' }, team: 'home' }
    ],
    awayPlayers: [
      // GK
      { number: 22, name: 'Raya', position: { x: '50%', y: '92%' }, team: 'away', isGoalkeeper: true },
      // DEF
      { number: 4, name: 'White', position: { x: '15%', y: '80%' }, team: 'away' },
      { number: 2, name: 'Saliba', position: { x: '38%', y: '80%' }, team: 'away' },
      { number: 6, name: 'Gabriel', position: { x: '62%', y: '80%' }, team: 'away' },
      { number: 35, name: 'Zinchenko', position: { x: '85%', y: '80%' }, team: 'away' },
      // MID
      { number: 41, name: 'Rice', position: { x: '35%', y: '68%' }, team: 'away' },
      { number: 20, name: 'Jorginho', position: { x: '65%', y: '68%' }, team: 'away' },
      // AM
      { number: 7, name: 'Saka', position: { x: '20%', y: '56%' }, team: 'away' },
      { number: 8, name: 'Odegaard', position: { x: '50%', y: '56%' }, team: 'away' },
      { number: 11, name: 'Martinelli', position: { x: '80%', y: '56%' }, team: 'away' },
      // ST
      { number: 9, name: 'Jesus', position: { x: '50%', y: '45%' }, team: 'away' }
    ]
  });

  statsSignal = signal<TeamStats>({
    stats: [
      { label: 'Possession', homeValue: 60, awayValue: 40, isPercentage: true },
      { label: 'Shots', homeValue: 12, awayValue: 5 },
      { label: 'Shots on Target', homeValue: 5, awayValue: 2 },
      { label: 'Corners', homeValue: 8, awayValue: 3 }
    ]
  });

  h2hSignal = signal<HeadToHead>({
    homeTeamLogo: 'https://lh3.googleusercontent.com/aida-public/AB6AXuATN7cPIKM3nMFl-2OVxe0YCdx22SucrmgKZf6LvzD36eNoV046cAQut4UHnJ7jKcKrVZiOcivLIKPhZHSeaQseZNeAcsChqmHOr0qNyFBonhjhLtzC1tuLo3-pjw_ah4KhJr3Df_qvhV5ZjtHjd7rQ91ZfpVQI4FlOz75mfudqpuAxC3F0Dc4nCh8BmFigO_ml-tP90QPjik6gYpsqMt5Anb2c2ih9IPAo56-Jt0jI6oJydJVVgUYG6bZcSrr4JvQ4dVxwsk1VhdsM',
    awayTeamLogo: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBhhCl3LdxiWNmUaTH-kwWQcw7hmjKFtdue1eNr-dpNzPhqS8pClc88SH-vh5ewZXEwbtmu_c5VdjIlI2KvB30tJCmKHY-M4GL6F-PcCrCfUoqgJCUZ5S0xZbWEdQ-Nrg600LbBVfy2rvC164iJFYS78P7-9ku2allDrxhXhRYzO9WD7WXFr46jI2a82OrcqMVdHKuoPhB4qP1zypeKwvlKYia9SPl91s9bTFQlklpPyUdVI0o3VNzbkjInVyWtiyONKdlGBNAjtxoA',
    recentForm: ['W', 'D', 'L', 'W', 'L']
  });

  highlightsSignal = signal<VideoHighlight[]>([
    {
      id: '1',
      title: 'Goal Highlight: E. Haaland opens the score',
      thumbnail: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCLSG94dyWCYvd9Vzp74K4PH1CepNv2gtjWTOvNhi8tXInzLli_wMTjs86zeAWzgjJS3Okj6wH4-6z7mzs9UPOUtn-CaqEdpmpSHcdZ5b8v-aONznf6BxyFF3IdGnnaaPuPlPx4ztSbEMJanvhCuvcatVGKYTmkLDQPooy9VJhgj2-Xx2AF8uW6Z5VYMxxQJsfLIAK3XZfKEZKUBLX5b0cf8Fv9zIC0mHeNakhANIQzNnb6kUJrRMLshPBwLYTNv2ziOSrdmBliaKXz',
      duration: '02:14',
      url: '#'
    },
    {
      id: '2',
      title: 'Penalty Check: VAR Decision on Saka foul',
      thumbnail: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBHXm6jZnltzwkVonRDAgmAIccxKbJZSXZXoPvAgPxntVFY-7OCceMrnAG7yf2qX5Ho85juHr-Vb61qFRliquS9ovOr_ebztXgJESDQZP8NFRlQlWUOSO3qfGJGOxLubrknF_asQDt7lrMIQbCNC8NAtG_uHEzyCd-_I9TLECP1ShZgVMF-JgsHZaYFjSuS1RPjhlxrX_wUQcMSYUvg1w_sU0C1ZGd9Uxb0poWrpIdTWH68xXAzJ6e0MXl2Ikf7Ue9HxwLhCmZlwqVe',
      duration: '00:45',
      url: '#'
    },
    {
      id: '3',
      title: 'Pre-match: Pep Guardiola Interview',
      thumbnail: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQ1ky_6QmlVv9SDvHnONhCHHjjkoj90sM_3Y7U5c2W6zt4J6wTaFTuv9ejhQnRBU6Gch-4TGlOWTI0ZCjLUC3wowEb2dbp4JWKwJFNQndYGCNc04jBhoZaA5P56XiZ7EwWkgVMEMWDWAp18wXdXCLSGwz_qXli0cNRG45M0Q24pnbVUtt9EyoLqqbr-WnmVD8O6-SjZ2s_42EidmaSy2WthctUMjRpMa6UrB5Vsk3Ziu7eUFe3ru21Bve_jZKYofZQhbzYytI3VpDb',
      duration: '03:20',
      url: '#'
    }
  ]);

  predictionSignal = signal<PredictionData>({
    totalVotes: 12500,
    homePercentage: 45,
    drawPercentage: 20,
    awayPercentage: 35,
    userVote: 'HOME'
  });

  activeTabSignal = signal<TabType>('OVERVIEW');

  ngOnInit(): void {
    const matchId = this.route.snapshot.paramMap.get('id');

    if (matchId) {
      // Initialize match data via service
      // Service will mutate the signals based on live/finished status
      this.matchDataService.initializeMatch(
        matchId,
        this.matchHeaderSignal,
        this.timelineSignal,
        this.lineupsSignal,
        this.statsSignal,
        this.h2hSignal,
        this.highlightsSignal,
        this.predictionSignal
      );
    }
  }

  ngOnDestroy(): void {
    // Cleanup WebSocket connections if any
    this.matchDataService.cleanup();
  }

  onTabChange(tab: TabType): void {
    this.activeTabSignal.set(tab);
  }

  onVote(option: VoteOption): void {
    console.log('Vote selected:', option);
    // Update prediction via service
    this.matchDataService.submitVote(option, this.predictionSignal);
  }

  onBack(): void {
    this.router.navigate(['/matches']);
  }
}
