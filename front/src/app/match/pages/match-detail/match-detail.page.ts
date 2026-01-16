import {Component, ChangeDetectionStrategy, signal, inject, input, computed} from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';


// Sections
import { MatchHeaderSection } from '../../sections/match-header/match-header.section';
import { PredictionWidgetSection, PredictionData, VoteOption } from '../../sections/prediction-widget/prediction-widget.section';
import { TabsNavigationSection, TabType } from '../../sections/tabs-navigation/tabs-navigation.section';
import { MatchTimelineSection } from '../../sections/match-timeline/match-timeline.section';
import { LineupsPitchSection } from '../../sections/lineups-pitch/lineups-pitch.section';
import { TeamStatsSection } from '../../sections/team-stats/team-stats.section';
import { HeadToHeadSection } from '../../sections/head-to-head/head-to-head.section';
import { HighlightsSection } from '../../sections/highlights/highlights.section';

import {MatchResourceFactory} from '../../services/match-resource.factory';
import {
  ScorePredictionPopupComponent
} from '../../../components/score-prediction-popup/score-prediction-popup.component';

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
    HighlightsSection,
    ScorePredictionPopupComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './match-detail.page.html',
  styleUrls: ['./match-detail.page.css']
})
export class MatchDetailPage {
  matchId = input<string>()
  private router = inject(Router);
  private matchResourceFactory = inject(MatchResourceFactory);
  store = this.matchResourceFactory.create(this.matchId);
  // State signals - owned by this page

  predictionSignal = signal<PredictionData>({
    totalVotes: 12500,
    homePercentage: 45,
    drawPercentage: 20,
    awayPercentage: 35,
    // userVote: {
    //   option:'HOME',
    //   home_score:2,
    //   away_score:1,
    //   diamonds:100
    // },
    voteEnabled: true
  });

  activeTabSignal = signal<TabType>('OVERVIEW');

  homeTeamName = computed(() => this.store.matchHeaderSignal().homeTeam.name)
  awayTeamName = computed(() => this.store.matchHeaderSignal().awayTeam.name)
  homeTeamFlag = computed(() => this.store.matchHeaderSignal().homeTeam.logo)
  awayTeamFlag = computed(() => this.store.matchHeaderSignal().awayTeam.logo)

  showPredictionPopup = signal(false);


  onTabChange(tab: TabType): void {
    console.log('Tab changed to:', tab);
    this.activeTabSignal.set(tab);
  }

  onVote(option: VoteOption): void {
    console.log('Vote selected:', option);
    this.predictionSignal.update((prev => ({...prev, userVote: {
      home_score: prev.userVote?.home_score || 0,
      away_score: prev.userVote?.away_score || 0,
      diamonds: prev.userVote?.diamonds || 0,
      option: option
      }})));
    // Update prediction via service
    // this.matchDataService.submitVote(option, this.predictionSignal);
  }

  onBack(): void {
    this.router.navigate(['/matches']);
  }
}
