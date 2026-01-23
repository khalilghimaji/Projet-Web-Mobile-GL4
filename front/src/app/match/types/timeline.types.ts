/**
 * Match event and timeline types
 */

export type EventType = 'GOAL' | 'YELLOW_CARD' | 'RED_CARD' | 'SUBSTITUTION';

export type TeamSide = 'home' | 'away';

export interface MatchEvent {
  id: string;
  minute: number;
  type: EventType;
  team: TeamSide;
  player: string;
  detail?: string; // Additional context (assist, reason, substitution info, etc.)
  timestamp?: Date;
}

export interface Timeline {
  events: MatchEvent[];
  lastUpdated: Date;
}
