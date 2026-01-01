import {MatchApiService} from './match-api.service';
import {LiveEventsService} from './live-events.service';
import {inject, Injectable, signal} from '@angular/core';
import {rxResource} from '@angular/core/rxjs-interop';
import {concat, tap} from 'rxjs';
import {filter} from 'rxjs/operators';
import {MatchStatus, Score} from '../types/match.types';
import {MatchEvent} from '../types/timeline.types';

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
    score: signal<Score | null>(null),
    time: signal<number | null>(null),
    status: signal<MatchStatus | null>(null),
    timeline: signal<MatchEvent[]>([]),
  };
}

type MatchSignals = ReturnType<typeof createMatchSignals>;

function hydrateFromSnapshot(
  dto: MatchDto,
  s: MatchSignals
) {
  s.score.set(dto.score);
  s.time.set(dto.minute);
  s.status.set(dto.status);
  s.timeline.set(dto.timeline);
}

function applyEvent(
  event: MatchEvent,
  s: MatchSignals
) {
  switch (event.type) {
    case 'goal':
      s.score.set(event.score);
      s.timeline.update(t => [...t, event]);
      break;

    case 'time':
      s.time.set(event.minute);
      break;

    case 'status':
      s.status.set(event.status);
      break;
  }
}

