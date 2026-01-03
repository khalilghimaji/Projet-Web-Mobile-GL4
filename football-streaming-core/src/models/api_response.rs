use serde::{Deserialize, Serialize};
use super::match_data::Match;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ApiResponse {
    pub success: i32,
    #[serde(default)]
    pub result: Vec<Match>,
}