export type MatchEventType = 'GOAL' | 'CARD' | 'SUBSTITUTION';

export interface MatchEvent {
  type: MatchEventType;
  team?: 'home' | 'away';
  player?: string;
  sub?: string;
}
