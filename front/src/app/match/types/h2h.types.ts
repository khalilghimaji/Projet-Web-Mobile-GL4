/**
 * Head-to-head history types
 */

export type FormResult = 'W' | 'D' | 'L';

export interface HeadToHead {
  homeTeamLogo: string;
  awayTeamLogo: string;
  recentForm: FormResult[]; // Last 5 matches (most recent first)
  totalMatches?: number;
  homeWins?: number;
  awayWins?: number;
  draws?: number;
}

export interface PastMatch {
  id: string;
  date: Date;
  homeScore: number;
  awayScore: number;
  competition: string;
  venue: string;
}

export interface DetailedH2H extends HeadToHead {
  pastMatches: PastMatch[];
  homeGoalsScored: number;
  awayGoalsScored: number;
  averageGoals: number;
}
