export interface Team {
  team_key: number;
  team_name: string;
  team_logo: string;
  players?: Player[];
  coaches?: Coach[];
}

export interface Coach {
  coach_name: string;
  coach_country: string | null;
  coach_age: string | null;
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
  player_injured: string;
  player_is_captain: string;
  player_saves: string;
  player_substitute_out: string;
  player_substitutes_on_bench: string;
  player_birthdate: string;
  player_shots_total: string;
  player_goals_conceded: string;
  player_fouls_committed: string;
  player_tackles: string;
  player_blocks: string;
  player_crosses_total: string;
  player_interceptions: string;
  player_clearances: string;
  player_dispossesed: string;
  player_inside_box_saves: string;
  player_duels_total: string;
  player_duels_won: string;
  player_dribble_attempts: string;
  player_dribble_succ: string;
  player_pen_comm: string;
  player_pen_won: string;
  player_pen_scored: string;
  player_pen_missed: string;
  player_passes: string;
  player_passes_accuracy: string;
  player_key_passes: string;
  player_woordworks: string;
}

export interface Fixture {
  event_key: string;
  event_date: string;
  event_time: string;
  event_home_team: string;
  home_team_key: number;
  home_team_logo: string;
  event_away_team: string;
  away_team_key: number;
  away_team_logo: string;
  event_final_result: string;
  event_status: string;
  event_stadium: string;
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