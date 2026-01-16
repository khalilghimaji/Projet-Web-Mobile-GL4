import {
  Component,
  ChangeDetectionStrategy,
  signal,
  inject,
  input,
  computed, linkedSignal,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';

// Sections
import { MatchHeaderSection } from '../../sections/match-header/match-header.section';
import {
  PredictionWidgetSection,
  PredictionData,
  VoteOption,
} from '../../sections/prediction-widget/prediction-widget.section';
import {
  TabsNavigationSection,
  TabType,
} from '../../sections/tabs-navigation/tabs-navigation.section';
import { MatchTimelineSection } from '../../sections/match-timeline/match-timeline.section';
import { LineupsPitchSection } from '../../sections/lineups-pitch/lineups-pitch.section';
import { TeamStatsSection } from '../../sections/team-stats/team-stats.section';
import { HeadToHeadSection } from '../../sections/head-to-head/head-to-head.section';
import { HighlightsSection } from '../../sections/highlights/highlights.section';

import { MatchResourceFactory } from '../../services/match-resource.factory';
import {
  ScorePredictionPopupComponent,
  TeamPrediction,
} from '../../../components/score-prediction-popup/score-prediction-popup.component';
import { catchError, forkJoin, map, of, tap } from 'rxjs';
import {MatchesService, MatchStat, Prediction} from '../../../services/Api';
import { rxResource } from '@angular/core/rxjs-interop';

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
    ScorePredictionPopupComponent,
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './match-detail.page.html',
  styleUrls: ['./match-detail.page.css'],
})
export class MatchDetailPage {
  matchId = input<string>();
  private router = inject(Router);
  private readonly matchesService = inject(MatchesService);
  private matchResourceFactory = inject(MatchResourceFactory);
  store = this.matchResourceFactory.create(this.matchId);
  // State signals - owned by this page

  activeTabSignal = signal<TabType>('OVERVIEW');

  homeTeamName = computed(() => this.store.matchHeaderSignal().homeTeam.name);
  awayTeamName = computed(() => this.store.matchHeaderSignal().awayTeam.name);
  homeTeamFlag = computed(() => this.store.matchHeaderSignal().homeTeam.logo);
  awayTeamFlag = computed(() => this.store.matchHeaderSignal().awayTeam.logo);

  existingPrediction = rxResource({
    params: () => ({ matchId: this.matchId() }),
    stream: ({ params }) => {
      if (!params.matchId) {
        return of(null);
      }
      return forkJoin([
        this.matchesService
          .matchesControllerGetUserPrediction(String(params.matchId))
          .pipe(
            catchError(() => of(null))
          ),
        this.matchesService
          .matchesControllerGetPredictionsStatsForMatch(String(params.matchId))
          .pipe(catchError(() => of(null))),
      ]).pipe(
        map(([userPrediction, matchStats]) => ({
          userPrediction: (userPrediction as Prediction) || null,
          matchStats: matchStats || null,
        }))
      );
    },
  });

  showPredictionPopup = signal(false);

  predictionSignal = linkedSignal<{userPrediction:Prediction,matchStats:MatchStat|null}|null|undefined,PredictionData>(
    {
      source: () => this.existingPrediction.value(),
      computation: (source, previous) => {
        if (source === null || source === undefined) {
          return previous?.value || {
            totalVotes: 0,
            homePercentage: 0,
            drawPercentage: 0,
            awayPercentage: 0,
            voteEnabled: false,
            userVote: undefined,
          };
        }
        if (source.matchStats) {
          return ({
            totalVotes: source.matchStats.totalVotes,
            homePercentage: source.matchStats.homePercentage,
            drawPercentage: source.matchStats.drawPercentage,
            awayPercentage: source.matchStats.awayPercentage,
            voteEnabled: source.matchStats.voteEnabled,
            userVote: source.userPrediction
              ? {
                option:
                  source.userPrediction.scoreFirstEquipe >
                  source.userPrediction.scoreSecondEquipe
                    ? 'HOME'
                    : source.userPrediction.scoreFirstEquipe <
                    source.userPrediction.scoreSecondEquipe
                      ? 'AWAY'
                      : 'DRAW',

                home_score: source.userPrediction?.scoreFirstEquipe || 0,
                away_score: source.userPrediction?.scoreSecondEquipe || 0,
                diamonds: source.userPrediction?.numberOfDiamondsBet || 1,
              }
              : undefined,
          });
        } else {
          return previous?.value || {
            totalVotes: 0,
            homePercentage: 0,
            drawPercentage: 0,
            awayPercentage: 0,
            voteEnabled: false,
            userVote: undefined,
          };
        }
      },
    },
  );
  predictionPopupData = computed<TeamPrediction>(() => ({
    team1Score: this.predictionSignal().userVote?.home_score || 0,
    team2Score: this.predictionSignal().userVote?.away_score || 0,
    matchId: Number(this.matchId()),
    numberOfDiamonds: this.predictionSignal().userVote?.diamonds || 1,
    isUpdating: !!this.predictionSignal().userVote,
  }));

  onTabChange(tab: TabType): void {
    console.log('Tab changed to:', tab);
    this.activeTabSignal.set(tab);
  }

  onVote(option: VoteOption): void {
    console.log('Vote selected:', option);
    this.predictionSignal.update((prev) => ({
      ...prev,
      userVote: {
        home_score: prev.userVote?.home_score || 0,
        away_score: prev.userVote?.away_score || 0,
        diamonds: prev.userVote?.diamonds || 0,
        option: option,
      },
    }));
    // Update prediction via service
    // this.matchDataService.submitVote(option, this.predictionSignal);
  }

  onBack(): void {
    this.router.navigate(['/matches']);
  }

  onPredict($event: TeamPrediction) {
    this.predictionSignal.update((p) => ({
      totalVotes: p.totalVotes + (p.userVote ? 0 : 1),
      ...this.calculateNewPercentage(p, this.computeOption($event)),
      voteEnabled: p.voteEnabled,
      userVote: {
        home_score: $event.team1Score!,
        away_score: $event.team2Score!,
        diamonds: $event.numberOfDiamonds!,
        option: this.computeOption($event),
      },
    }));
  }

  private calculateNewPercentage(
    oldPrediction: PredictionData,
    newOption: VoteOption
  ) {
    let totalVotes =
      oldPrediction.totalVotes + (oldPrediction.userVote ? 0 : 1);
    let homeVotes = Math.round(
      (oldPrediction.homePercentage / 100) * oldPrediction.totalVotes
    );
    let drawVotes = Math.round(
      (oldPrediction.drawPercentage / 100) * oldPrediction.totalVotes
    );
    let awayVotes = Math.round(
      (oldPrediction.awayPercentage / 100) * oldPrediction.totalVotes
    );

    // If user had already voted, we don't increase total votes
    if (oldPrediction.userVote) {
      // If user is changing vote, adjust counts
      if (oldPrediction.userVote.option === 'HOME') homeVotes--;
      else if (oldPrediction.userVote.option === 'DRAW') drawVotes--;
      else if (oldPrediction.userVote.option === 'AWAY') awayVotes--;
    }
    // Add the new vote
    if (newOption === 'HOME') {
      homeVotes++;
    } else if (newOption === 'DRAW') {
      drawVotes++;
    } else {
      awayVotes++;
    }
    return {
      homePercentage: (homeVotes / totalVotes) * 100,
      drawPercentage: (drawVotes / totalVotes) * 100,
      awayPercentage: (awayVotes / totalVotes) * 100,
    };
  }

  private computeOption(event: TeamPrediction): VoteOption {
    if (event.team1Score! > event.team2Score!) {
      return 'HOME';
    } else if (event.team1Score! < event.team2Score!) {
      return 'AWAY';
    } else {
      return 'DRAW';
    }
  }
}
