import { inject, Injectable, signal, Signal } from '@angular/core';
import { rxResource } from '@angular/core/rxjs-interop';
import { concat, tap, filter, catchError, of } from 'rxjs';
import { FixturesApiService } from './fixtures-api.service';
import { LiveEventsService } from './live-events.service';
import { Fixture, League } from '../types/fixture.types';


export interface FixturesRequest {
  from: string;       // Date de début au format YYYY-MM-DD
  to: string;         // Date de fin au format YYYY-MM-DD
  leagueId?: string;  // ID de la ligue (optionnel, undefined = toutes les ligues)
}

@Injectable({ providedIn: 'root' })
export class FixturesResourceFactory {
  private api = inject(FixturesApiService);
  private live = inject(LiveEventsService);


  create(request: Signal<FixturesRequest>) {
    console.log('FixturesResourceFactory.create() - Creating new Fixtures Store');

    const signals = createFixturesSignals();


    const resource = rxResource({
      params: () => request(),

      stream: ({params}) =>
        concat(
          // Chargement initial via HTTP API
          this.api.getFixtures(params.from, params.to, params.leagueId).pipe(
            tap(fixtures => {
              console.log(`Fixtures loaded: ${fixtures.length} matches`);
              hydrateFixtures(fixtures, signals);
            }),
            catchError(error => {
              console.error('Error loading fixtures:', error);
              return of([]);
            })
          ),

          // mises a jour en temps réel via WebSocket
          this.live.events$.pipe(
            filter(event => isFixtureEvent(event)),
            tap(event => {
              console.log('Live event received:', event.type, event.match_id);
              applyLiveUpdate(event, signals);
            }),
            catchError(error => {
              console.error('WebSocket error:', error);
              return of(null);
            })
          )
        ),
    });


    return {
      resource,
      fixtures: signals.fixtures.asReadonly(),
      lastUpdate: signals.lastUpdate.asReadonly(),
    };
  }


  createFeaturedLeaguesResource() {
    console.log('FixturesResourceFactory.createFeaturedLeaguesResource()');

    const leaguesSignal = signal<League[]>([]);
    const loadingSignal = signal<boolean>(true);

    const resource = rxResource({
      stream: () =>
        this.api.getFeaturedLeagues().pipe(
          tap(leagues => {
            console.log(`Featured leagues loaded: ${leagues.length}`);
            leaguesSignal.set(leagues);
            loadingSignal.set(false);
          }),
          catchError(error => {
            console.error(' Error loading featured leagues:', error);
            loadingSignal.set(false);
            return of([]);
          })
        ),
    });

    return {
      resource,
      leagues: leaguesSignal.asReadonly(),
      loading: loadingSignal.asReadonly()
    };
  }
}


function createFixturesSignals() {
  return {
    // Liste complète des fixtures chargées
    fixtures: signal<Fixture[]>([]),

    // Timestamp de la dernière mise à jour (HTTP ou WebSocket)
    lastUpdate: signal<Date | null>(null),
  };
}


type FixturesSignals = ReturnType<typeof createFixturesSignals>;


function hydrateFixtures(fixtures: Fixture[], s: FixturesSignals) {
  console.log(`Hydrating ${fixtures.length} fixtures`);
  s.fixtures.set(fixtures);
  s.lastUpdate.set(new Date());
}

function isFixtureEvent(event: any): boolean {
  const relevantTypes = [
    'SCORE_UPDATE',
    'GOAL_SCORED',
    'MATCH_STARTED',
    'MATCH_ENDED',
    'HALF_TIME',
    'SECOND_HALF_STARTED',
    'CARD_ISSUED',
    'SUBSTITUTION'
  ];

  return event &&
    event.type &&
    relevantTypes.includes(event.type) &&
    event.match_id !== undefined;
}

function applyLiveUpdate(event: any, s: FixturesSignals) {
  const matchId = event.match_id;

  s.fixtures.update(fixtures => {
    const index = fixtures.findIndex(f => f.event_key === matchId);
    let updated = [...fixtures];

    // Si le match n'existe pas, on le crée automatiquement
    if (index === -1) {
      console.log(`Match not found in fixtures: ${matchId} - Creating new fixture from WebSocket event`);

      const newFixture: Fixture = {
        event_key: matchId,
        event_date: new Date().toISOString().split('T')[0],
        event_time: new Date().toTimeString().split(' ')[0],
        event_home_team: event.home_team || 'Home Team',
        event_away_team: event.away_team || 'Away Team',
        event_final_result: event.score || '0-0',
        event_halftime_result: '',
        event_status: '1',
        event_live: '1',
        league_name: event.league || 'Unknown League',
        league_key: event.league_id || '',
        league_logo: '',
        home_team_logo: '',
        away_team_logo: '',
        home_team_key: '',
        away_team_key: '',
        event_stadium: '',
        country_name: '',
      };

      updated.push(newFixture);
    }

    const fixtureIndex = index === -1 ? updated.length - 1 : index;
    const fixture = { ...updated[fixtureIndex] };

    switch (event.type) {
      case 'SCORE_UPDATE':
      case 'GOAL_SCORED':
        if (event.score) {
          fixture.event_final_result = event.score;
        }
        fixture.event_live = '1';
        if (event.minute) {
          fixture.event_status = event.minute.toString();
        }
        break;

      case 'MATCH_STARTED':
        fixture.event_live = '1';
        fixture.event_status = '1'; // Minute 1
        break;

      case 'HALF_TIME':
        fixture.event_live = '1';
        fixture.event_status = 'Half Time';
        if (event.halftime_score) {
          fixture.event_halftime_result = event.halftime_score;
        }
        break;
      case 'SECOND_HALF_STARTED':
        fixture.event_live = '1';
        fixture.event_status = '45'; // Reprise à 45 minutes
        break;


      case 'MATCH_ENDED':
        fixture.event_live = '0';
        fixture.event_status = 'Finished';
        if (event.final_score) {
          fixture.event_final_result = event.final_score;
        }
        break;

      case 'CARD_ISSUED':
      case 'SUBSTITUTION':

        break;
    }

    updated[fixtureIndex] = fixture;
    saveMatchToLocalStorage(fixture, event);
    console.log(`Fixture updated: ${fixture.event_key} - ${fixture.event_status}`);
    return updated;
  });

  s.lastUpdate.set(new Date());
}

const MOCK_MATCHES_KEY = 'mock_matches';

function saveMatchToLocalStorage(fixture: Fixture, event: any): void {
  const cached = localStorage.getItem(MOCK_MATCHES_KEY);
  const matches: Record<string, StoredMatch> = cached ? JSON.parse(cached) : {};

  const existing = matches[fixture.event_key];
  const events = existing?.events ?? [];

  if (isTimelineEvent(event)) {
    events.push({
      type: event.type,
      minute: event.minute,
      player: event.scorer || event.player || event.player_in,
      team: event.team,
      score: event.score
    });
  }

  matches[fixture.event_key] = {
    ...fixture,
    events,
    lastUpdate: new Date().toISOString()
  };

  localStorage.setItem(MOCK_MATCHES_KEY, JSON.stringify(matches));
}

function isTimelineEvent(event: any): boolean {
  return ['GOAL_SCORED', 'CARD_ISSUED', 'SUBSTITUTION'].includes(event.type);
}

interface StoredMatch extends Fixture {
  events: StoredEvent[];
  lastUpdate: string;
}

interface StoredEvent {
  type: string;
  minute: string;
  player: string;
  team: string;
  score?: string;
}

