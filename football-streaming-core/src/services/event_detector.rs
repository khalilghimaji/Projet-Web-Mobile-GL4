use chrono::Utc;
use crate::models::{Match, MatchEvent};

pub struct EventDetector;

impl EventDetector {
    pub fn new() -> Self {
        Self
    }

    pub fn detect_changes(&self, old_match: Option<&Match>, new_match: &Match) -> Vec<MatchEvent> {
        let mut events = Vec::new();

        // First time seeing this match (just started)
        if old_match.is_none() {
            events.push(MatchEvent::MatchStarted {
                match_id: new_match.event_key.clone(),
                home_team: new_match.event_home_team.clone(),
                away_team: new_match.event_away_team.clone(),
                league: new_match.league_name.clone(),
                league_id: new_match.league_key.clone(),
                start_time: format!("{} {}", new_match.event_date, new_match.event_time),
                timestamp: Utc::now(),
            });
            return events;
        }

        let old = old_match.unwrap();

        // Goal scored
        if new_match.goalscorers.len() > old.goalscorers.len() {
            if let Some(goal) = new_match.goalscorers.last() {
                let scorer = if !goal.home_scorer.is_empty() {
                    goal.home_scorer.clone()
                } else {
                    goal.away_scorer.clone()
                };
                
                let team = if !goal.home_scorer.is_empty() { "home" } else { "away" };

                events.push(MatchEvent::GoalScored {
                    match_id: new_match.event_key.clone(),
                    minute: goal.time.clone(),
                    scorer,
                    team: team.to_string(),
                    score: goal.score.clone(),
                    home_team: new_match.event_home_team.clone(),
                    away_team: new_match.event_away_team.clone(),
                    league_id: new_match.league_key.clone(),
                    timestamp: Utc::now(),
                });
            }
        }

        // Card issued
        if new_match.cards.len() > old.cards.len() {
            if let Some(card) = new_match.cards.last() {
                let player = if !card.home_fault.is_empty() {
                    card.home_fault.clone()
                } else {
                    card.away_fault.clone()
                };
                
                let team = if !card.home_fault.is_empty() { "home" } else { "away" };

                events.push(MatchEvent::CardIssued {
                    match_id: new_match.event_key.clone(),
                    minute: card.time.clone(),
                    player,
                    team: team.to_string(),
                    card_type: card.card.clone(),
                    home_team: new_match.event_home_team.clone(),
                    away_team: new_match.event_away_team.clone(),
                    league_id: new_match.league_key.clone(),
                    timestamp: Utc::now(),
                });
            }
        }

        // Substitution
        if new_match.substitutes.len() > old.substitutes.len() {
            if let Some(sub) = new_match.substitutes.last() {
                let (player_in, player_out, team) = if !sub.home_scorer.player_in.is_empty() {
                    (
                        sub.home_scorer.player_in.clone(),
                        sub.home_scorer.player_out.clone(),
                        "home",
                    )
                } else {
                    (
                        sub.away_scorer.player_in.clone(),
                        sub.away_scorer.player_out.clone(),
                        "away",
                    )
                };

                events.push(MatchEvent::Substitution {
                    match_id: new_match.event_key.clone(),
                    minute: sub.time.clone(),
                    player_in,
                    player_out,
                    team: team.to_string(),
                    home_team: new_match.event_home_team.clone(),
                    away_team: new_match.event_away_team.clone(),
                    league_id: new_match.league_key.clone(),
                    timestamp: Utc::now(),
                });
            }
        }

        // Match ended
        if old.event_status != "Finished" && new_match.event_status == "Finished" {
            events.push(MatchEvent::MatchEnded {
                match_id: new_match.event_key.clone(),
                home_team: new_match.event_home_team.clone(),
                home_team_key: new_match.home_team_key.clone(),
                away_team: new_match.event_away_team.clone(),
                away_team_key: new_match.away_team_key.clone(),
                final_score: new_match.event_final_result.clone(),
                halftime_score: new_match.event_halftime_result.clone(),
                league: new_match.league_name.clone(),
                league_key: new_match.league_key.clone(),
                country: new_match.country_name.clone(),
                timestamp: Utc::now(),
            });
        }

        events
    }
}