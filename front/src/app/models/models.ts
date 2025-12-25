export interface Team {
  team_key: string;
  team_name: string;
  team_logo: string;
  players?: Player[];
}

export interface Player {
  player_key: number;
  player_name: string;
  player_number: string;
  player_type: string; // "Goalkeepers" | "Defenders" | "Midfielders" | "Forwards"
  player_age: string;
  player_match_played: string;
  player_goals: string;
  player_assists: string;
  player_yellow_cards: string;
  player_red_cards: string;
  player_rating: string;
  player_image: string;
  player_country: string | null;
}

export interface Fixture {
  event_key: string;
  event_date: string;
  event_time: string;
  event_home_team: string;
  home_team_key: string;
  event_away_team: string;
  away_team_key: string;
  event_final_result: string;
  event_status: string;
  league_name: string;
  country_name: string;
}

export interface Standing {
  standing_place: string;
  standing_team: string;
  standing_PTS: string;
  standing_W: string;
  standing_D: string;
  standing_L: string;
  team_key: string;
}

// View Models (for components)
export interface TeamHeader {
  name: string;
  logo: string;
  country?: string;
  venue?: string;
}

export interface PlayerCardData {
  id: number;
  name: string;
  photo: string;
  position: string;
  number: string;
  goals: number;
  assists: number;
  rating: string;
}

export interface FormResult {
  result: 'W' | 'D' | 'L';
  opponent: string;
  date: string;
  score?: string;
}

export interface NextMatchData {
  opponent: string;
  opponentLogo: string;
  date: Date;
  league: string;
  venue: string;
}