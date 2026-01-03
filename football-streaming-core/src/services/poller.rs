use actix::Addr;
use anyhow::Result;
use dashmap::DashMap;
use std::sync::Arc;
use tokio::time::{interval, Duration};

use crate::actors::broadcaster::{Broadcaster, BroadcastMessage};
use crate::models::{ApiResponse, Match};
use crate::services::event_detector::EventDetector;

pub struct Poller {
    api_key: String,
    client: reqwest::Client,
    cache: Arc<DashMap<String, Match>>,
    poll_interval: u64,
    broadcaster: Addr<Broadcaster>,
    event_detector: EventDetector,
}

impl Poller {
    pub fn new(api_key: String, poll_interval: u64, broadcaster: Addr<Broadcaster>) -> Self {
        // Configure HTTP client with better settings for reliability
        let client = reqwest::Client::builder()
            .timeout(Duration::from_secs(30))
            .connect_timeout(Duration::from_secs(10))
            .tcp_keepalive(Duration::from_secs(60))
            .pool_idle_timeout(Duration::from_secs(90))
            .user_agent("Football-Backend/1.0")
            .build()
            .expect("Failed to create HTTP client");

        Self {
            api_key,
            client,
            cache: Arc::new(DashMap::new()),
            poll_interval,
            broadcaster,
            event_detector: EventDetector::new(),
        }
    }

    pub async fn start(self) {
        tracing::info!("🔄 Polling service started (interval: {}s)", self.poll_interval);
        
        let mut ticker = interval(Duration::from_secs(self.poll_interval));

        loop {
            ticker.tick().await;
            tracing::info!("🔄 Polling API for live matches...");

            match self.fetch_live_matches().await {
                Ok(matches) => {
                    tracing::info!("📊 Fetched {} live matches", matches.len());
                    self.process_matches(matches).await;
                }
                Err(e) => {
                    tracing::error!("❌ Polling error: {}", e);
                }
            }
        }
    }

    async fn fetch_live_matches(&self) -> Result<Vec<Match>> {
        let url = format!(
            "https://apiv2.allsportsapi.com/football/?met=Livescore&APIkey={}",
            self.api_key
        );

        // Retry logic for transient network errors
        const MAX_RETRIES: u32 = 3;
        let mut last_error = None;

        for attempt in 1..=MAX_RETRIES {
            match self.try_fetch(&url).await {
                Ok(result) => return Ok(result),
                Err(e) => {
                    last_error = Some(e);
                    // Check if it's a retryable error
                    let error_str = last_error.as_ref().unwrap().to_string();
                    let is_retryable = error_str.contains("connection closed")
                        || error_str.contains("timeout")
                        || error_str.contains("connection refused")
                        || error_str.contains("network");

                    if !is_retryable || attempt == MAX_RETRIES {
                        break;
                    }

                    // Exponential backoff: 1s, 2s, 4s
                    let delay = Duration::from_secs(2_u64.pow(attempt - 1));
                    tracing::warn!(
                        "Request failed (attempt {}/{}), retrying in {:?}: {}",
                        attempt,
                        MAX_RETRIES,
                        delay,
                        error_str
                    );
                    tokio::time::sleep(delay).await;
                }
            }
        }

        Err(last_error.unwrap_or_else(|| anyhow::anyhow!("Unknown error")))
    }

    async fn try_fetch(&self, url: &str) -> Result<Vec<Match>> {
        let response = self.client
            .get(url)
            .send()
            .await?;

        // Check HTTP status
        if !response.status().is_success() {
            anyhow::bail!("API returned status: {}", response.status());
        }

        let api_response: ApiResponse = response.json().await?;

        if api_response.success != 1 {
            anyhow::bail!("API returned success=0");
        }

        Ok(api_response.result)
    }

    async fn process_matches(&self, matches: Vec<Match>) {
        for new_match in &matches {
            let match_id = new_match.event_key.clone();
            
            // Get old match from cache
            let old_match = self.cache.get(&match_id).map(|entry| entry.clone());

            // Detect changes
            let events = self.event_detector.detect_changes(old_match.as_ref(), new_match);

            // Broadcast events
            for event in events {
                tracing::info!("📢 Event: {:?}", event);
                
                self.broadcaster.do_send(BroadcastMessage {
                    event: event.clone(),
                });
            }

            // Update cache
            self.cache.insert(match_id, new_match.clone());
        }

        // Check for ended matches (no longer in live list)
        let live_ids: std::collections::HashSet<String> = 
            matches.iter().map(|m| m.event_key.clone()).collect();
        
        self.cache.retain(|match_id, cached_match| {
            if !live_ids.contains(match_id) && cached_match.event_status != "Finished" {
                tracing::info!("🏁 Match {} ended (removed from live)", match_id);
                
                // Create match ended event
                let event = crate::models::MatchEvent::MatchEnded {
                    match_id: cached_match.event_key.clone(),
                    home_team: cached_match.event_home_team.clone(),
                    home_team_key: cached_match.home_team_key.clone(),
                    away_team: cached_match.event_away_team.clone(),
                    away_team_key: cached_match.away_team_key.clone(),
                    final_score: cached_match.event_final_result.clone(),
                    halftime_score: cached_match.event_halftime_result.clone(),
                    league: cached_match.league_name.clone(),
                    league_key: cached_match.league_key.clone(),
                    country: cached_match.country_name.clone(),
                    timestamp: chrono::Utc::now(),
                };
                
                self.broadcaster.do_send(BroadcastMessage { event });
                
                false // Remove from cache
            } else {
                true // Keep in cache
            }
        });
    }
}