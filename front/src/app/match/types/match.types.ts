/**
 * Core match-related types
 */

export interface Team {
  id: string;
  name: string;
  shortName: string;
  logo: string;
}

export interface Score {
  home: number;
  away: number;
  venue: string;
}

export type MatchStatusType = 'LIVE' | 'FT' | 'HT' | 'SCHEDULED' | 'POSTPONED' | 'CANCELLED';

export interface MatchStatus {
  isLive: boolean;
  minute?: number;
  status: MatchStatusType;
  competition: string;
}

export interface Match {
  id: string;
  homeTeam: Team;
  awayTeam: Team;
  score: Score;
  status: MatchStatus;
  date: Date;
}
