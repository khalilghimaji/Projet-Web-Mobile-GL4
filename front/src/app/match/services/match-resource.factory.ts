import {MatchApiService} from './match-api.service';
import {LiveEventsService} from './live-events.service';
import {inject, Injectable, signal} from '@angular/core';
import {rxResource} from '@angular/core/rxjs-interop';
import {concat, tap} from 'rxjs';
import {filter} from 'rxjs/operators';
import {MatchStatus, Score} from '../types/match.types';
import {MatchEvent} from '../types/timeline.types';
import {MatchHeader} from '../sections/match-header/match-header.section';
import {Lineups} from '../sections/lineups-pitch/lineups-pitch.section';
import {TeamStats} from '../types/stats.types';
import {HeadToHead} from '../types/h2h.types';
import {VideoHighlight} from '../types/highlight.types';

@Injectable({ providedIn: 'root' })
export class MatchResourceFactory {
  private api = inject(MatchApiService);
  private live = inject(LiveEventsService);

  create(matchId: string) {
    const signals = createMatchSignals();

    const resource = rxResource({
      stream: () =>
        concat(
          // Initial HTTP snapshot
          this.api.getMatch(matchId).pipe(
            tap(dto => hydrateFromSnapshot(dto, signals))
          ),

          // Live WebSocket updates
          this.live.events$.pipe(
            filter(e => e.id === matchId),
            tap(e => applyEvent(e, signals))
          )
        ),
    });

    return {
      resource, // lifecycle owner
      ...signals, // granular signals
    };
  }
}

function createMatchSignals() {
  return {
    matchHeaderSignal: signal<MatchHeader|null>(null),
    timelineSignal: signal<MatchEvent[]>([]),
    lineupsSignal: signal<Lineups|null>(null),
    statsSignal: signal<TeamStats|null>(null),
    h2hSignal: signal<HeadToHead|null>(null),
    highlightsSignal: signal<VideoHighlight[]>([]),
  };
}

type MatchSignals = ReturnType<typeof createMatchSignals>;

function hydrateFromSnapshot(
  dto: any,
  s: MatchSignals
) {
  s.matchHeaderSignal.set({
    status:dto.event_status,
    homeTeam: dto.event_home_team,
    awayTeam: dto.event_away_team,
    score: dto.event_ft_result,
  });
  s.timelineSignal.update(t => [...t, dto.goalscorers.map(
    g => ({
      type: 'GOAL' as const,
      minute: g.time,
      team: g.home_scorer ? 'home' : 'away',
      player: g.home_scorer || g.away_scorer,
      detail: g.home_assist ? `Assist: ${g.home_assist}` : g.away_assist ? `Assist: ${g.away_assist}`: '',
    })
  )]);
  s.timelineSignal.update(t => [...t, dto.substitutions.map(
    s => ({
      type: 'SUBSTITUTION' as const,
      minute: s.time,
      team: s.home_scorer ? 'home' : 'away',
      player: s.home_scorer ? s.home_scorer.in : s.away_scorer.in,
      detail: `OUT: ${s.home_scorer ? s.home_scorer.out : s.away_scorer.out}`,
    })
  )]);
  s.timelineSignal.update(t => [...t, dto.cards.map(
    c => ({
      type: c.card === 'yellow card' ? 'YELLOW_CARD' as const : 'RED_CARD' as const,
      minute: c.time,
      team: c.info,
      player: c.info == 'home' ? c.home_fault : c.away_fault,
      detail: '',
    })
  )]);
  s.timelineSignal.update(t=> t.sort((a,b) => a.minute - b.minute));
  // todo
  // s.lineupsSignal.set({
  //
  // })
  s.statsSignal.set(dto.statistics.map(s => (
    {
      label: s.type,
      homeValue: s.home,
      awayValue: s.away,
    })
  ));
  s.h2hSignal.set({
    homeTeamLogo: dto.home_team_logo,
    awayTeamLogo: dto.away_team_logo,
    recentForm: dto.h2h.map(h => {
      const final_result = h.H2H.event_final_result;
      let [homeGoals, awayGoals] = final_result.split('-').map(Number);
      let outcome: 'W' | 'D' | 'L';
      if (homeGoals > awayGoals) {
        outcome = 'W';
      } else if (homeGoals < awayGoals) {
        outcome = 'L';
      } else {
        outcome = 'D';
      }
      return outcome;
    }),
  })
  // todo
  s.highlightsSignal.set(dto.highlights.map(h => ({
    title: h.video_title,
    url: h.video_url,
  })));
}

function applyEvent(
  event: MatchEvent,
  s: MatchSignals
) {
  switch (event.type) {
    case 'GOAL':
      s.score.set(event.score);
      s.timeline.update(t => [...t, event]);
      break;

    case 'YELLOW_CARD':
      break;

    case 'RED_CARD':
      break;
  }
}

