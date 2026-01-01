export interface Fixture {
  event_key: string;
  event_date: string;
  event_time: string;
  event_home_team: string;
  home_team_key: string;
  home_team_logo: string;
  event_away_team: string;
  away_team_key: string;
  away_team_logo: string;
  event_final_result: string;
  event_halftime_result: string;
  event_status: string;
  event_live: string;
  league_name: string;
  league_key: string;
  league_logo: string;
  country_name: string;
  event_stadium: string;
}

export interface League {
  league_key: string;
  league_name: string;
  league_logo: string;
  country_name: string;
}

export interface FixturesByLeague {
  league: League;
  fixtures: ParsedFixture[];
}

export interface DateTab {
  date: Date;
  dayName: string;
  dayNumber: number;
  isToday: boolean;
}

export type FixtureStatus = 'LIVE' | 'SCHEDULED' | 'FINISHED';

export interface ParsedFixture extends Fixture {
  parsedStatus: FixtureStatus;
  minute?: number;
  homeScore?: number;
  awayScore?: number;
}

