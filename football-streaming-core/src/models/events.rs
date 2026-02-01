use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum MatchEvent {
    #[serde(rename = "MATCH_STARTED")]
    MatchStarted {
        match_id: String,
        home_team: String,
        away_team: String,
        league: String,
        league_id: String,
        start_time: String,
        timestamp: DateTime<Utc>,
    },
    
    #[serde(rename = "GOAL_SCORED")]
    GoalScored {
        match_id: String,
        minute: String,
        scorer: String,
        team: String,
        score: String,
        home_team: String,
        away_team: String,
        league_id: String,
        timestamp: DateTime<Utc>,
    },
    
    #[serde(rename = "SCORE_UPDATE")]
    ScoreUpdate {
        match_id: String,
        home_team: String,
        away_team: String,
        score: String,
        status: String,
        league_id: String,
        timestamp: DateTime<Utc>,
    },
    
    #[serde(rename = "CARD_ISSUED")]
    CardIssued {
        match_id: String,
        minute: String,
        player: String,
        team: String,
        card_type: String,
        home_team: String,
        away_team: String,
        league_id: String,
        timestamp: DateTime<Utc>,
    },
    
    #[serde(rename = "SUBSTITUTION")]
    Substitution {
        match_id: String,
        minute: String,
        player_in: String,
        player_out: String,
        team: String,
        home_team: String,
        away_team: String,
        league_id: String,
        timestamp: DateTime<Utc>,
    },
    
    #[serde(rename = "HALF_TIME")]
    HalfTime {
        match_id: String,
        home_team: String,
        away_team: String,
        halftime_score: String,
        league_id: String,
        timestamp: DateTime<Utc>,
    },

    #[serde(rename = "SECOND_HALF_STARTED")]
    SecondHalfStarted {
        match_id: String,
        home_team: String,
        away_team: String,
        league_id: String,
        timestamp: DateTime<Utc>,
    },

    #[serde(rename = "MATCH_ENDED")]
    MatchEnded {
        match_id: String,
        home_team: String,
        home_team_key: String,
        away_team: String,
        away_team_key: String,
        final_score: String,
        halftime_score: String,
        league: String,
        league_key: String,
        country: String,
        timestamp: DateTime<Utc>,
    },
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ClientMessage {
    pub action: String,
    #[serde(default)]
    pub data: Option<serde_json::Value>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SubscriptionData {
    #[serde(default)]
    pub match_id: Option<String>,
    #[serde(default)]
    pub league_id: Option<String>,
}