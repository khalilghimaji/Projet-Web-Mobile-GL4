use std::env;

#[derive(Clone)]
pub struct Config {
    pub api_key: String,
    pub bind_address: String,
    pub poll_interval_secs: u64,
}

impl Config {
    pub fn from_env() -> Self {
        Self {
            api_key: env::var("ALLSPORTS_API_KEY")
                .expect("ALLSPORTS_API_KEY must be set"),
            bind_address: env::var("BIND_ADDRESS")
                .unwrap_or_else(|_| "0.0.0.0:8080".to_string()),
            poll_interval_secs: env::var("POLL_INTERVAL_SECS")
                .unwrap_or_else(|_| "15".to_string())
                .parse()
                .expect("POLL_INTERVAL_SECS must be a number"),
        }
    }
}