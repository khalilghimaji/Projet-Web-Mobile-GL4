import {Component, ChangeDetectionStrategy, signal, inject, OnInit, OnDestroy, input, computed} from '@angular/core';
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
import {MatchResourceFactory} from '../../services/match-resource.factory';

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
export class MatchDetailPage implements OnInit {
  // Injected dependencies
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
    userVote: 'HOME',
    voteEnabled: true
  });

  activeTabSignal = signal<TabType>('OVERVIEW');

  ngOnInit(): void {
  }

  onTabChange(tab: TabType): void {
    console.log('Tab changed to:', tab);
    this.activeTabSignal.set(tab);
  }

  onVote(option: VoteOption): void {
    console.log('Vote selected:', option);
    this.predictionSignal.update((prev => ({...prev, userVote: option})));
    // Update prediction via service
    // this.matchDataService.submitVote(option, this.predictionSignal);
  }

  onBack(): void {
    this.router.navigate(['/matches']);
  }
}
