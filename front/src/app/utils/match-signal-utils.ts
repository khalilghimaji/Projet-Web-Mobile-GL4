import { computed, Signal } from '@angular/core';
import { MatchSignals } from '../types/match-signals';

// Example: total goals
export function totalGoalsSignal(signals: MatchSignals): Signal<number> {
  return computed(() => signals.score().home + signals.score().away);
}

// Example: count yellow/red cards
export function cardCountSignal(signals: MatchSignals, player: string): Signal<number> {
  return computed(() => signals.cards().filter(c => c === player).length);
}
