import { Injectable, Signal, WritableSignal, signal } from '@angular/core';

export interface MatchEvent {
  type: 'GOAL' | 'CARD' | 'SUBSTITUTION';
  team?: 'home' | 'away';
  player?: string;
  sub?: string;
}

export interface MatchSignals {
  score: WritableSignal<{ home: number; away: number }>;
  cards: WritableSignal<string[]>;
  substitutions: WritableSignal<string[]>;
}

@Injectable({ providedIn: 'root' })
export class LiveMatchService {
  connect(matchId: string, signals: MatchSignals) {
    const ws = new WebSocket(`wss://match/${matchId}`);
    ws.onmessage = (msg) => {
      const e: MatchEvent = JSON.parse(msg.data);
      switch (e.type) {
        case 'GOAL':
          signals.score.update(s => ({ ...s, [e.team!]: s[e.team!] + 1 }));
          break;
        case 'CARD':
          signals.cards.update(c => [...c, e.player!]);
          break;
        case 'SUBSTITUTION':
          signals.substitutions.update(s => [...s, e.sub!]);
          break;
      }
    };
  }
}
