import { Injectable, WritableSignal } from '@angular/core';
import { MatchSignals } from './live-match.service';

@Injectable({ providedIn: 'root' })
export class FinishedMatchService {
  async load(matchId: string, signals: MatchSignals) {
    const res = await fetch(`/api/match/${matchId}`);
    const data = await res.json();

    signals.score.set(data.score);
    signals.cards.set(data.cards);
    signals.substitutions.set(data.substitutions);
  }
}
