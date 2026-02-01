import {MatchApiService} from './match-api.service';
import {LiveEventsService} from './live-events.service';
import {inject, Injectable, Signal, signal } from '@angular/core';
import {rxResource} from '@angular/core/rxjs-interop';
import {concat, tap, of, catchError} from 'rxjs';
import {filter} from 'rxjs/operators';
import {MatchEvent} from '../types/timeline.types';
import {MatchHeader} from '../sections/match-header/match-header.section';
import {Lineups} from '../sections/lineups-pitch/lineups-pitch.section';
import {TeamStats} from '../types/stats.types';
import {HeadToHead} from '../types/h2h.types';
import {VideoHighlight} from '../types/highlight.types';
import {mapPlayersToFormation} from '../utils/formation.util';
import {PlayerPosition} from '../types/lineup.types';

const MOCK_MATCHES_KEY = 'mock_matches';

interface StoredMatch {
  event_key: string;
  event_home_team: string;
  event_away_team: string;
  event_final_result: string;
  event_status: string;
  event_live: string;
  league_name: string;
  home_team_logo?: string;
  away_team_logo?: string;
  home_team_key?: string;
  away_team_key?: string;
  event_stadium?: string;
  events?: StoredEvent[];
  lastUpdate: string;
}

interface StoredEvent {
  type: string;
  minute: string;
  player: string;
  team: string;
  score?: string;
}

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
          this.api.getMatch(matchId).pipe(
            tap(dto => {
              console.log('Match data loaded:', matchId);
              hydrateFromSnapshot(dto, signals);
            }),
            catchError(() => {
              console.warn('Match not found in API, checking localStorage:', matchId);
              const cached = loadMatchFromLocalStorage(matchId);
              if (cached) {
                console.log('Match found in localStorage:', matchId);
                hydrateFromLocalStorage(cached, signals);
              } else {
                console.warn('Match not in localStorage, waiting for WebSocket:', matchId);
              }
              return of(null);
            })
          ),

          this.live.events$.pipe(
            filter(e => e.match_id === matchId),
            tap(e => {
              console.log('Live event received for match:', matchId, e.type);
              applyEvent(e, signals);
              updateLocalStorageFromEvent(matchId, e, signals);
            })
          )
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

function getEventStatus(event_live:string, event_status:string){
  if(event_live == '1'){
    if (event_status == 'Half Time') {
      return 'HT';
    }
    return 'LIVE';
  } else if (event_status == 'Finished') {
    return 'FT';
  } else if (event_live == '0' && event_status && event_status !== '') {
    return 'FT';
  } else {
    return 'SCHEDULED'
  }
  console.log("here me",event_status)
}

function hydrateFromSnapshot(
  dto: any,
  s: MatchSignals
) {
  console.log(dto)
  s.matchHeaderSignal.set({
    status:{
      isLive: dto.event_live != '0',
      minute: parseStatusMinute(dto.event_status),
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
      team: c.home_fault ? 'home' : 'away',
      player: c.home_fault || c.away_fault,
      detail: '',
    })
  ))]);
  console.log(`cards ${JSON.stringify(s.timelineSignal())}`)
  s.timelineSignal.update(t=> t.sort((a,b) => a.minute - b.minute));
  console.log(`sorted ${JSON.stringify(s.timelineSignal())}`)

  // Lineups mapping
  if (dto.lineups?.home_team && dto.lineups?.away_team) {
    const homeFormation = dto.event_home_formation || '4-3-3';
    const awayFormation = dto.event_away_formation || '4-3-3';

    s.lineupsSignal.set({
      homeFormation,
      awayFormation,
      homePlayers: mapLineupPlayers(
        dto.lineups.home_team.starting_lineups || [],
        homeFormation,
        'home'
      ),
      awayPlayers: mapLineupPlayers(
        dto.lineups.away_team.starting_lineups || [],
        awayFormation,
        'away'
      ),
    });
    console.log(`lineups set ${JSON.stringify(s.lineupsSignal())}`)
  }

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
    case 'GOAL_SCORED': {
      const goalMinute = parseMinuteString(event.minute);
      s.matchHeaderSignal.update(header => ({
        ...header!,
        status: {
          ...header!.status,
          minute: goalMinute,
        },
        score: {
          ...header!.score,
          home: event.team === 'home' ? header!.score.home + 1 : header!.score.home,
          away: event.team === 'away' ? header!.score.away + 1 : header!.score.away,
        }
      }))
      s.timelineSignal.update(t => [...t,{
        id: `event-goal-${event.minute}-${event.scorer}`,
        minute: goalMinute,
        type: 'GOAL',
        team: event.team,
        player: event.scorer,
      }]);
      break;
    }

    case 'CARD_ISSUED': {
      const cardMinute = parseMinuteString(event.minute);
      s.matchHeaderSignal.update(header => ({
        ...header!,
        status: {
          ...header!.status,
          minute: cardMinute,
        }
      }))
      s.timelineSignal.update(t => [...t,{
        id: `event-card-${event.minute}-${event.player}`,
        minute: cardMinute,
        type: event.card_type === 'yellow card' ? 'YELLOW_CARD' : 'RED_CARD',
        team: event.team,
        player: event.player,
      }]);
      break;
    }

    case 'SUBSTITUTION': {
      const subMinute = parseMinuteString(event.minute);
      s.matchHeaderSignal.update(header => ({
        ...header!,
        status: {
          ...header!.status,
          minute: subMinute,
        }
      }))
      s.timelineSignal.update(t => [...t,{
        id: `event-substitution-${event.minute}-${event.player_in}`,
        minute: subMinute,
        type: 'SUBSTITUTION',
        team: event.team,
        player: event.player_in,
        detail: `OUT: ${event.player_out}`,
      }]);
      break;
    }
    case 'MATCH_ENDED':
      s.matchHeaderSignal.update(header => ({
        ...header!,
        status: {
          ...header!.status,
          minute: 0,
          isLive: false,
          status: 'FT'
        }
      }))
      break;
    case 'HALF_TIME':
      s.matchHeaderSignal.update(header => ({
        ...header!,
        status: {
          minute: 0,
          ...header!.status,
          isLive: true,
          status: 'HT'
        }
      }))
      break;
    case 'SECOND_HALF_STARTED':
      s.matchHeaderSignal.update(header => ({
        ...header!,
        status: {
          ...header!.status,
          isLive: true,
          status: 'LIVE',
          minute: 46,
        }
      }))
      break;
    case 'MATCH_STARTED':
      s.matchHeaderSignal.update(header => ({
        ...header!,
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
        ...t!,
        score: {
          ...t!.score,
          home: Number(event.score.split('-')[0]) || 0,
          away: Number(event.score.split('-')[1]) || 0,
        }
      }));
      break;
    default:
      break;
  }
}

/**
 * Map API lineup data to PlayerPosition array with calculated positions
 */
function mapLineupPlayers(
  apiPlayers: any[],
  formation: string,
  team: 'home' | 'away'
): PlayerPosition[] {
  if (!apiPlayers || apiPlayers.length === 0) {
    return [];
  }

  // Séparer gardien et joueurs de champ
  const goalkeeper = apiPlayers.find(p => p.player_position === '1' || p.player_position === 1);
  const outfieldPlayers = apiPlayers.filter(p => p.player_position !== '1' && p.player_position !== 1);

  // Trier les joueurs de champ par numéro
  outfieldPlayers.sort((a, b) => {
    const numA = Number.parseInt(a.player_number) || 99;
    const numB = Number.parseInt(b.player_number) || 99;
    return numA - numB;
  });

  const players = [];

  // Ajouter le gardien en premier
  if (goalkeeper) {
    players.push({
      id: goalkeeper.player_key || `gk-${team}`,
      number: Number.parseInt(goalkeeper.player_number) || 1,
      name: extractShortName(goalkeeper.player),
      fullName: goalkeeper.player,
      team,
      isGoalkeeper: true,
    });
  }

  // Ajouter EXACTEMENT 10 joueurs de champ (pas plus)
  const maxOutfield = 10;
  for (let i = 0; i < Math.min(maxOutfield, outfieldPlayers.length); i++) {
    const p = outfieldPlayers[i];
    players.push({
      id: p.player_key || `player-${team}-${i}`,
      number: Number.parseInt(p.player_number) || 0,
      name: extractShortName(p.player),
      fullName: p.player,
      team,
      isGoalkeeper: false,
    });
  }

  return mapPlayersToFormation(players, formation, team);
}

/**
 * Extract short name from full player name
 */
function extractShortName(fullName: string): string {
  if (!fullName) return '';
  const parts = fullName.trim().split(' ');
  if (parts.length === 1) return parts[0];
  return parts[parts.length - 1];
}


function loadMatchFromLocalStorage(matchId: string | undefined): StoredMatch | null {
  if (!matchId) return null;
  const cached = localStorage.getItem(MOCK_MATCHES_KEY);
  if (!cached) return null;
  const matches: Record<string, StoredMatch> = JSON.parse(cached);
  return matches[matchId] ?? null;
}

function hydrateFromLocalStorage(cached: StoredMatch, s: MatchSignals): void {
  const [homeScore, awayScore] = (cached.event_final_result || '0-0').split('-').map(Number);

  s.matchHeaderSignal.set({
    status: {
      isLive: cached.event_live === '1',
      minute: parseStatusMinute(cached.event_status),
      status: getEventStatus(cached.event_live, cached.event_status),
      competition: cached.league_name || '',
    },
    homeTeam: {
      id: cached.home_team_key || '',
      name: cached.event_home_team || '',
      shortName: cached.event_home_team || '',
      logo: cached.home_team_logo || '',
    },
    awayTeam: {
      id: cached.away_team_key || '',
      name: cached.event_away_team || '',
      shortName: cached.event_away_team || '',
      logo: cached.away_team_logo || '',
    },
    score: {
      home: homeScore || 0,
      away: awayScore || 0,
      venue: cached.event_stadium || '',
    },
  });

  if (cached.events?.length) {
    s.timelineSignal.set(cached.events.map(e => ({
      id: `event-${e.type}-${e.minute}-${e.player}`,
      type: mapEventType(e.type),
      minute: parseInt(e.minute) || 0,
      team: e.team as 'home' | 'away',
      player: e.player,
    })));
  }
}
function parseMinuteString(timeStr: string): number {
  if (!timeStr) return 0;
  if (timeStr.includes('+')) {
    const [base, added] = timeStr.split('+');
    return (parseInt(base) || 0) + (parseInt(added) || 0);
  }
  return parseInt(timeStr) || 0;
}

function parseStatusMinute(status: string): number {
  if (!status) return 0;
  if (status === 'Half Time') return 0;
  if (status === 'Finished') return 0;
  return parseMinuteString(status);
}


function mapEventType(type: string): 'GOAL' | 'YELLOW_CARD' | 'RED_CARD' | 'SUBSTITUTION' {
  switch (type) {
    case 'GOAL_SCORED': return 'GOAL';
    case 'CARD_ISSUED': return 'YELLOW_CARD';
    case 'SUBSTITUTION': return 'SUBSTITUTION';
    default: return 'GOAL';
  }
}

function updateLocalStorageFromEvent(matchId: string | undefined, event: any, signals: MatchSignals): void {
  if (!matchId) return;

  const cached = localStorage.getItem(MOCK_MATCHES_KEY);
  const matches: Record<string, StoredMatch> = cached ? JSON.parse(cached) : {};

  const header = signals.matchHeaderSignal();
  const existing = matches[matchId];
  const events = existing?.events ?? [];

  if (['GOAL_SCORED', 'CARD_ISSUED', 'SUBSTITUTION'].includes(event.type)) {
    events.push({
      type: event.type,
      minute: event.minute,
      player: event.scorer || event.player || event.player_in,
      team: event.team,
      score: event.score
    });
  }

  matches[matchId] = {
    event_key: matchId,
    event_home_team: event.home_team || header.homeTeam.name,
    event_away_team: event.away_team || header.awayTeam.name,
    event_final_result: event.score || `${header.score.home}-${header.score.away}`,
    event_status: event.minute?.toString() || String(header.status.minute ?? 0),
    event_live: header.status.isLive ? '1' : '0',
    league_name: event.league || header.status.competition,
    home_team_logo: header.homeTeam.logo,
    away_team_logo: header.awayTeam.logo,
    home_team_key: header.homeTeam.id,
    away_team_key: header.awayTeam.id,
    events,
    lastUpdate: new Date().toISOString()
  };

  localStorage.setItem(MOCK_MATCHES_KEY, JSON.stringify(matches));
}
