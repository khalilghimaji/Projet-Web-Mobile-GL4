import { WritableSignal } from '@angular/core';

export interface MatchSignals {
  score: WritableSignal<{ home: number; away: number }>;
  cards: WritableSignal<string[]>;
  substitutions: WritableSignal<string[]>;
}
