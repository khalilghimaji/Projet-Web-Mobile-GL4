import {MatchApiService} from './match-api.service';
import {LiveEventsService} from './live-events.service';
import {inject, Injectable, Signal, signal } from '@angular/core';
import {rxResource} from '@angular/core/rxjs-interop';
import {concat, tap} from 'rxjs';
import {filter} from 'rxjs/operators';
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

  create(matchId: Signal<string|undefined>) {
    console.log(`creating signals for match id ${matchId()}`);
    const signals = createMatchSignals();

    const resource = rxResource({
      params: () => matchId(),
      stream: ({params: matchId}) =>
        concat(
          // Initial HTTP snapshot
          this.api.getMatch(matchId).pipe(
            tap(dto => hydrateFromSnapshot(dto, signals))
          ),

          // Live WebSocket updates
          // this.live.events$.pipe(
          //   filter(e => e.matchId === matchId),
          //   tap(e => applyEvent(e, signals))
          // )
        ),
    });

    return {
      resource, // lifecycle owner
      matchHeaderSignal: signals.matchHeaderSignal.asReadonly(),
      timelineSignal: signals.timelineSignal.asReadonly(),
      lineupsSignal: signals.lineupsSignal.asReadonly(),
      statsSignal: signals.statsSignal.asReadonly(),
      h2hSignal: signals.h2hSignal.asReadonly(),
      highlightsSignal: signals.highlightsSignal.asReadonly(),
    };
  }
}

function createMatchSignals() {
  return {
    matchHeaderSignal: signal<MatchHeader>({
      status: {
        isLive: false,
        minute: 0,
        status: 'SCHEDULED',
        competition: '',
      },
      homeTeam: {
        id: '',
        name: '',
        shortName: '',
        logo: '',
      },
      awayTeam: {
        id: '',
        name: '',
        shortName: '',
        logo: '',
      },
      score: {
        home: 0,
        away: 0,
        venue: '',
      },
    }),
    timelineSignal: signal<MatchEvent[]>([]),
    lineupsSignal: signal<Lineups>({
      homeFormation:'',
      awayFormation:'',
      homePlayers:[],
      awayPlayers:[],
    }),
    statsSignal: signal<TeamStats>({
      stats: [],
    }),
    h2hSignal: signal<HeadToHead>({
      homeTeamLogo: '',
      awayTeamLogo: '',
      recentForm: [],
    }),
    highlightsSignal: signal<VideoHighlight[]>([]),
  };
}

type MatchSignals = ReturnType<typeof createMatchSignals>;

// todo
function getEventStatus(event_live:string, event_status:string){
  if(event_live == '1'){
    return 'LIVE';
  } else if (event_status == 'Finished') {
    return 'FT';
  } else {
    return 'SCHEDULED'
  }
}

function hydrateFromSnapshot(
  dto: any,
  s: MatchSignals
) {
  console.log(dto)
  s.matchHeaderSignal.set({
    status:{
      isLive: dto.event_live != '0',
      minute: Number.parseInt(dto.event_status),
      status: getEventStatus(dto.event_live, dto.event_status),
      competition: dto.league_name,
    },
    homeTeam: {
      id: dto.home_team_key,
      name: dto.event_home_team,
      shortName: dto.event_home_team,
      logo: dto.home_team_logo,
    },
    awayTeam: {
      id: dto.away_team_key,
      name: dto.event_away_team,
      shortName: dto.event_away_team,
      logo: dto.away_team_logo,
    },
    score: {
      home: dto.event_final_result.split('-')[0] ? Number(dto.event_final_result.split('-')[0]) : 0,
      away: dto.event_final_result.split('-')[1] ? Number(dto.event_final_result.split('-')[1]) : 0,
      venue: dto.event_stadium,
    },
  });
  s.timelineSignal.update(t => [...t, ...(dto.goalscorers.map(
    (g:any) => ({
      id: `event-goal-${g.time}-${g.home_scorer || g.away_scorer}`,
      type: 'GOAL' as const,
      minute: g.time,
      team: g.home_scorer ? 'home' : 'away',
      player: g.home_scorer || g.away_scorer,
      detail: g.home_assist ? `Assist: ${g.home_assist}` : g.away_assist ? `Assist: ${g.away_assist}`: '',
    })
  ))]);
  console.log(`goal scorers ${JSON.stringify(s.timelineSignal())}`)
  s.timelineSignal.update(t => [...t, ...(dto.substitutes.map(
    (s:any) => ({
      id: `event-substitution-${s.time}-${s.home_scorer?.in || s.away_scorer?.in}`,
      type: 'SUBSTITUTION' as const,
      minute: s.time,
      team: s.home_scorer != '' ? 'home' : 'away',
      player: s.home_scorer != '' ? s.home_scorer.in : s.away_scorer.in,
      detail: `OUT: ${s.home_scorer != '' ? s.home_scorer.out : s.away_scorer.out}`,
    })
  ))]);
  console.log(`substitutions ${JSON.stringify(s.timelineSignal())}`)
  s.timelineSignal.update(t => [...t, ...(dto.cards.map(
    (c:any) => ({
      id: `event-card-${c.time}-${c.home_fault || c.away_fault}`,
      type: c.card === 'yellow card' ? 'YELLOW_CARD' as const : 'RED_CARD' as const,
      minute: c.time,
      team: c.info,
      player: c.info == 'home' ? c.home_fault : c.away_fault,
      detail: '',
    })
  ))]);
  console.log(`cards ${JSON.stringify(s.timelineSignal())}`)
  s.timelineSignal.update(t=> t.sort((a,b) => a.minute - b.minute));
  // todo
  // s.lineupsSignal.set({
  //
  // })
  console.log(`sorted ${JSON.stringify(s.timelineSignal())}`)
  s.statsSignal.set({stats:dto.statistics.map((s:any) => (
    {
      label: s.type,
      homeValue: Number.parseFloat(s.home),
      awayValue: Number.parseFloat(s.away),
    })
  )});
  console.log(`stats set ${JSON.stringify(s.statsSignal())}`)
  s.h2hSignal.set({
    homeTeamLogo: dto.home_team_logo,
    awayTeamLogo: dto.away_team_logo,
    recentForm: dto.h2h.H2H.map((h:any) => {
      const final_result = h.event_final_result;
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
  console.log(`h2h ${JSON.stringify(s.h2hSignal())}`)
  // todo
  s.highlightsSignal.set(dto.highlights.map((h:any) => ({
    title: h.video_title,
    url: h.video_url,
  })));
}

function applyEvent(
  event: any,
  s: MatchSignals
) {
  switch (event.type) {
    case 'GOAL_SCORED':
      s.matchHeaderSignal.update(header => ({
        ...(header!),
        score: {
          ...header!.score,
          home: event.team === 'home' ? header!.score.home + 1 : header!.score.home,
          away: event.team === 'away' ? header!.score.away + 1 : header!.score.away,
        }
      }))
      s.timelineSignal.update(t => [...t,{
        id: `event-goal-${event.minute}-${event.scorer}`,
        minute: event.minute,
        type: 'GOAL',
        team: event.team,
        player: event.scorer,
      }]);
      break;

    case 'CARD_ISSUED':
      s.timelineSignal.update(t => [...t,{
        id: `event-card-${event.minute}-${event.player}`,
        minute: event.minute,
        type: event.card_type === 'yellow card' ? 'YELLOW_CARD' : 'RED_CARD',
        team: event.team,
        player: event.player,
      }]);
      break;

    case 'SUBSTITUTION':
      s.timelineSignal.update(t => [...t,{
        id: `event-substitution-${event.minute}-${event.player_in}`,
        minute: event.minute,
        type: 'SUBSTITUTION',
        team: event.team,
        player: event.player_in,
        detail: `OUT: ${event.player_out}`,
      }]);
      break;
    case 'MATCH_ENDED':
      s.matchHeaderSignal.update(header => ({
        ...(header!),
        status: {
          ...header!.status,
          isLive: false,
          status: 'FT'
        }
      }))
      break;
    case 'MATCH_STARTED':
      s.matchHeaderSignal.update(header => ({
        ...(header!),
        status: {
          ...header!.status,
          isLive: true,
          status: 'LIVE',
          minute: Math.max(0, Math.floor((Date.now() - new Date(event.start_time).getTime()) / 60000)),
        }
      }))
      break;
    case 'SCORE_UPDATE':
      s.matchHeaderSignal.update(t=> ({
        ...(t!),
        score: {
          ...t!.score,
          home: event.score.split('-')[0],
          away: event.score.split('-')[1],
        }
      }));
      break;
    default:
      break;
  }
}

