use std::env;

#[derive(Clone)]
pub struct Config {
    pub api_key: Option<String>,
    pub bind_address: String,
    pub poll_interval_secs: u64,
    pub mock_mode: bool,
}

impl Config {
    pub fn from_env() -> Self {
        let api_key = env::var("ALLSPORTS_API_KEY").ok().filter(|v| !v.trim().is_empty());
        let mock_mode = match env::var("MOCK_MODE") {
            Ok(v) => matches!(v.trim().to_ascii_lowercase().as_str(), "1" | "true" | "yes" | "on"),
            Err(_) => false,
        };

        Self {
            api_key,
            bind_address: env::var("BIND_ADDRESS")
                .unwrap_or_else(|_| "0.0.0.0:8080".to_string()),
            poll_interval_secs: env::var("POLL_INTERVAL_SECS")
                .unwrap_or_else(|_| "15".to_string())
                .parse()
                .expect("POLL_INTERVAL_SECS must be a number"),
            mock_mode,
        }
    }
}