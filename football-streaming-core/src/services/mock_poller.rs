use actix::Addr;
use chrono::Utc;
use tokio::time::{interval, Duration};

use crate::actors::broadcaster::{BroadcastMessage, Broadcaster};
use crate::models::MatchEvent;

/// Mock state tracking for realistic match simulation
struct MatchState {
    minute: u32,
    home_score: u32,
    away_score: u32,
    phase: MatchPhase,
}

#[derive(Debug, Clone, PartialEq)]
enum MatchPhase {
    NotStarted,
    FirstHalf,
    HalfTime,
    SecondHalf,
    FullTime,
}

pub struct MockPoller {
    poll_interval: u64,
    broadcaster: Addr<Broadcaster>,
}

impl MockPoller {
    pub fn new(poll_interval: u64, broadcaster: Addr<Broadcaster>) -> Self {
        Self {
            poll_interval,
            broadcaster,
        }
    }

    pub async fn start(self) {
        tracing::warn!(
            "🧪 MOCK_MODE enabled: simulating realistic match with timer progression every {}s",
            self.poll_interval
        );

        let mut ticker = interval(Duration::from_secs(self.poll_interval.max(1)));

        // Match metadata
        let match_id = "mock-001".to_string();
        let home_team = "Real Madrid".to_string();
        let away_team = "Barcelona".to_string();
        let league = "La Liga".to_string();
        let league_id = "140".to_string();

        // Match state
        let mut state = MatchState {
            minute: 0,
            home_score: 0,
            away_score: 0,
            phase: MatchPhase::NotStarted,
        };

        loop {
            ticker.tick().await;

            let events = self.get_events_for_minute(&mut state, &match_id, &home_team, &away_team, &league, &league_id);

            for event in events {
                tracing::info!("📡 Broadcasting: {:?} at minute {}", event, state.minute);
                self.broadcaster.do_send(BroadcastMessage { event });
            }

            // Progress time
            if state.phase == MatchPhase::FirstHalf && state.minute < 47 {
                state.minute += 1;
            } else if state.phase == MatchPhase::SecondHalf && state.minute < 95 {
                state.minute += 1;
            }
        }
    }

    fn get_events_for_minute(
        &self,
        state: &mut MatchState,
        match_id: &str,
        home_team: &str,
        away_team: &str,
        league: &str,
        league_id: &str,
    ) -> Vec<MatchEvent> {
        let mut events = Vec::new();

        match (state.phase.clone(), state.minute) {
            // Kick-off
            (MatchPhase::NotStarted, _) => {
                state.phase = MatchPhase::FirstHalf;
                state.minute = 1;

                events.push(MatchEvent::MatchStarted {
                    match_id: match_id.to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league: league.to_string(),
                    league_id: league_id.to_string(),
                    start_time: Utc::now().format("%Y-%m-%d %H:%M").to_string(),
                    timestamp: Utc::now(),
                });

                events.push(MatchEvent::ScoreUpdate {
                    match_id: match_id.to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    score: format!("{}-{}", state.home_score, state.away_score),
                    status: "1st Half".to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            // First Half Events
            (MatchPhase::FirstHalf, 8) => {
                // Yellow card
                events.push(MatchEvent::CardIssued {
                    match_id: match_id.to_string(),
                    minute: "8".to_string(),
                    player: "Sergio Ramos".to_string(),
                    team: "home".to_string(),
                    card_type: "yellow".to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            (MatchPhase::FirstHalf, 12) => {
                // Goal for home team
                state.home_score += 1;

                events.push(MatchEvent::GoalScored {
                    match_id: match_id.to_string(),
                    minute: "12".to_string(),
                    scorer: "Karim Benzema".to_string(),
                    team: "home".to_string(),
                    score: format!("{}-{}", state.home_score, state.away_score),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });

                events.push(MatchEvent::ScoreUpdate {
                    match_id: match_id.to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    score: format!("{}-{}", state.home_score, state.away_score),
                    status: "1st Half".to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            (MatchPhase::FirstHalf, 23) => {
                // Yellow card away
                events.push(MatchEvent::CardIssued {
                    match_id: match_id.to_string(),
                    minute: "23".to_string(),
                    player: "Gerard Piqué".to_string(),
                    team: "away".to_string(),
                    card_type: "yellow".to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            (MatchPhase::FirstHalf, 28) => {
                // Goal for away team
                state.away_score += 1;

                events.push(MatchEvent::GoalScored {
                    match_id: match_id.to_string(),
                    minute: "28".to_string(),
                    scorer: "Lionel Messi".to_string(),
                    team: "away".to_string(),
                    score: format!("{}-{}", state.home_score, state.away_score),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });

                events.push(MatchEvent::ScoreUpdate {
                    match_id: match_id.to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    score: format!("{}-{}", state.home_score, state.away_score),
                    status: "1st Half".to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            (MatchPhase::FirstHalf, 35) => {
                // Substitution
                events.push(MatchEvent::Substitution {
                    match_id: match_id.to_string(),
                    minute: "35".to_string(),
                    player_in: "Vinícius Jr".to_string(),
                    player_out: "Eden Hazard".to_string(),
                    team: "home".to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            (MatchPhase::FirstHalf, 42) => {
                // Goal for home team
                state.home_score += 1;

                events.push(MatchEvent::GoalScored {
                    match_id: match_id.to_string(),
                    minute: "42".to_string(),
                    scorer: "Vinícius Jr".to_string(),
                    team: "home".to_string(),
                    score: format!("{}-{}", state.home_score, state.away_score),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });

                events.push(MatchEvent::ScoreUpdate {
                    match_id: match_id.to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    score: format!("{}-{}", state.home_score, state.away_score),
                    status: "1st Half".to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            // Half Time (minute 47 = 45+2)
            (MatchPhase::FirstHalf, 47) => {
                state.phase = MatchPhase::HalfTime;

                events.push(MatchEvent::HalfTime {
                    match_id: match_id.to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    halftime_score: format!("{}-{}", state.home_score, state.away_score),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            // Second Half Start
            (MatchPhase::HalfTime, _) => {
                state.phase = MatchPhase::SecondHalf;
                state.minute = 46;

                events.push(MatchEvent::SecondHalfStarted {
                    match_id: match_id.to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });

                events.push(MatchEvent::ScoreUpdate {
                    match_id: match_id.to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    score: format!("{}-{}", state.home_score, state.away_score),
                    status: "2nd Half".to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            // Second Half Events
            (MatchPhase::SecondHalf, 52) => {
                // Substitution
                events.push(MatchEvent::Substitution {
                    match_id: match_id.to_string(),
                    minute: "52".to_string(),
                    player_in: "Ansu Fati".to_string(),
                    player_out: "Ousmane Dembélé".to_string(),
                    team: "away".to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            (MatchPhase::SecondHalf, 58) => {
                // Red card!
                events.push(MatchEvent::CardIssued {
                    match_id: match_id.to_string(),
                    minute: "58".to_string(),
                    player: "Sergio Ramos".to_string(),
                    team: "home".to_string(),
                    card_type: "red".to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            (MatchPhase::SecondHalf, 65) => {
                // Goal for away team
                state.away_score += 1;

                events.push(MatchEvent::GoalScored {
                    match_id: match_id.to_string(),
                    minute: "65".to_string(),
                    scorer: "Ansu Fati".to_string(),
                    team: "away".to_string(),
                    score: format!("{}-{}", state.home_score, state.away_score),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });

                events.push(MatchEvent::ScoreUpdate {
                    match_id: match_id.to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    score: format!("{}-{}", state.home_score, state.away_score),
                    status: "2nd Half".to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            (MatchPhase::SecondHalf, 73) => {
                // Substitution
                events.push(MatchEvent::Substitution {
                    match_id: match_id.to_string(),
                    minute: "73".to_string(),
                    player_in: "Luka Modrić".to_string(),
                    player_out: "Toni Kroos".to_string(),
                    team: "home".to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            (MatchPhase::SecondHalf, 81) => {
                // Goal for away team (winner!)
                state.away_score += 1;

                events.push(MatchEvent::GoalScored {
                    match_id: match_id.to_string(),
                    minute: "81".to_string(),
                    scorer: "Pedri".to_string(),
                    team: "away".to_string(),
                    score: format!("{}-{}", state.home_score, state.away_score),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });

                events.push(MatchEvent::ScoreUpdate {
                    match_id: match_id.to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    score: format!("{}-{}", state.home_score, state.away_score),
                    status: "2nd Half".to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            (MatchPhase::SecondHalf, 87) => {
                // Yellow card
                events.push(MatchEvent::CardIssued {
                    match_id: match_id.to_string(),
                    minute: "87".to_string(),
                    player: "Casemiro".to_string(),
                    team: "home".to_string(),
                    card_type: "yellow".to_string(),
                    home_team: home_team.to_string(),
                    away_team: away_team.to_string(),
                    league_id: league_id.to_string(),
                    timestamp: Utc::now(),
                });
            }

            // Full Time (minute 93 = 90+3)
            (MatchPhase::SecondHalf, 93) => {
                state.phase = MatchPhase::FullTime;

                events.push(MatchEvent::MatchEnded {
                    match_id: match_id.to_string(),
                    home_team: home_team.to_string(),
                    home_team_key: "real-madrid".to_string(),
                    away_team: away_team.to_string(),
                    away_team_key: "barcelona".to_string(),
                    final_score: format!("{}-{}", state.home_score, state.away_score),
                    halftime_score: "2-1".to_string(),
                    league: league.to_string(),
                    league_key: league_id.to_string(),
                    country: "Spain".to_string(),
                    timestamp: Utc::now(),
                });
            }

            // Restart the match after Full Time
            (MatchPhase::FullTime, _) => {
                tracing::info!("🔄 Restarting mock match simulation...");
                state.minute = 0;
                state.home_score = 0;
                state.away_score = 0;
                state.phase = MatchPhase::NotStarted;
            }

            _ => {
                // Regular minute updates (no special events)
                // Send periodic score updates to show timer progression
                if state.phase == MatchPhase::FirstHalf && state.minute % 5 == 0 {
                    events.push(MatchEvent::ScoreUpdate {
                        match_id: match_id.to_string(),
                        home_team: home_team.to_string(),
                        away_team: away_team.to_string(),
                        score: format!("{}-{}", state.home_score, state.away_score),
                        status: "1st Half".to_string(),
                        league_id: league_id.to_string(),
                        timestamp: Utc::now(),
                    });
                } else if state.phase == MatchPhase::SecondHalf && state.minute % 5 == 0 {
                    events.push(MatchEvent::ScoreUpdate {
                        match_id: match_id.to_string(),
                        home_team: home_team.to_string(),
                        away_team: away_team.to_string(),
                        score: format!("{}-{}", state.home_score, state.away_score),
                        status: "2nd Half".to_string(),
                        league_id: league_id.to_string(),
                        timestamp: Utc::now(),
                    });
                }
            }
        }

        events
    }
}

