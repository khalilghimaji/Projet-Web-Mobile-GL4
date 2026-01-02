use serde::{Deserialize, Deserializer, Serialize};

// Helper function to deserialize numbers or strings as strings
fn deserialize_number_or_string<'de, D>(deserializer: D) -> Result<String, D::Error>
where
    D: Deserializer<'de>,
{
    use serde::de::Visitor;
    use std::fmt;

    struct NumberOrStringVisitor;

    impl<'de> Visitor<'de> for NumberOrStringVisitor {
        type Value = String;

        fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
            formatter.write_str("a number or a string")
        }

        fn visit_i64<E>(self, v: i64) -> Result<Self::Value, E>
        where
            E: serde::de::Error,
        {
            Ok(v.to_string())
        }

        fn visit_u64<E>(self, v: u64) -> Result<Self::Value, E>
        where
            E: serde::de::Error,
        {
            Ok(v.to_string())
        }

        fn visit_str<E>(self, v: &str) -> Result<Self::Value, E>
        where
            E: serde::de::Error,
        {
            Ok(v.to_string())
        }
    }

    deserializer.deserialize_any(NumberOrStringVisitor)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Match {
    #[serde(deserialize_with = "deserialize_number_or_string")]
    pub event_key: String,
    pub event_date: String,
    pub event_time: String,
    pub event_home_team: String,
    #[serde(deserialize_with = "deserialize_number_or_string")]
    pub home_team_key: String,
    pub event_away_team: String,
    #[serde(deserialize_with = "deserialize_number_or_string")]
    pub away_team_key: String,
    pub event_halftime_result: String,
    pub event_final_result: String,
    pub event_status: String,
    pub country_name: String,
    pub league_name: String,
    #[serde(deserialize_with = "deserialize_number_or_string")]
    pub league_key: String,
    pub league_round: String,
    pub event_live: String,
    #[serde(default)]
    pub goalscorers: Vec<GoalScorer>,
    #[serde(default)]
    pub cards: Vec<Card>,
    #[serde(default)]
    pub substitutes: Vec<Substitution>,
    #[serde(default)]
    pub statistics: Vec<Statistic>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GoalScorer {
    pub time: String,
    pub home_scorer: String,
    pub score: String,
    pub away_scorer: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Card {
    pub time: String,
    pub home_fault: String,
    pub card: String,
    pub away_fault: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Substitution {
    pub time: String,
    #[serde(default, deserialize_with = "deserialize_substitution_detail_opt")]
    pub home_scorer: SubstitutionDetail,
    pub score: String,
    #[serde(default, deserialize_with = "deserialize_substitution_detail_opt")]
    pub away_scorer: SubstitutionDetail,
}

// Helper to deserialize SubstitutionDetail, handling objects, arrays, and null
fn deserialize_substitution_detail_opt<'de, D>(deserializer: D) -> Result<SubstitutionDetail, D::Error>
where
    D: Deserializer<'de>,
{
    use serde::de::{self, Visitor};
    use std::fmt;

    struct SubstitutionDetailVisitor;

    impl<'de> Visitor<'de> for SubstitutionDetailVisitor {
        type Value = SubstitutionDetail;

        fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
            formatter.write_str("a SubstitutionDetail object, array, or null")
        }

        fn visit_map<M>(self, mut map: M) -> Result<Self::Value, M::Error>
        where
            M: de::MapAccess<'de>,
        {
            let mut player_in = String::new();
            let mut player_out = String::new();

            while let Some(key) = map.next_key::<String>()? {
                match key.as_str() {
                    "in" => {
                        if let Ok(val) = map.next_value::<String>() {
                            player_in = val;
                        }
                    }
                    "out" => {
                        if let Ok(val) = map.next_value::<String>() {
                            player_out = val;
                        }
                    }
                    _ => {
                        let _: de::IgnoredAny = map.next_value()?;
                    }
                }
            }

            Ok(SubstitutionDetail {
                player_in,
                player_out,
            })
        }

        fn visit_seq<A>(self, mut seq: A) -> Result<Self::Value, A::Error>
        where
            A: de::SeqAccess<'de>,
        {
            // If it's an array, just ignore it and return default
            // The API sometimes returns empty arrays [] for substitutions
            while let Some(_) = seq.next_element::<de::IgnoredAny>()? {}
            Ok(SubstitutionDetail::default())
        }

        fn visit_unit<E>(self) -> Result<Self::Value, E>
        where
            E: de::Error,
        {
            Ok(SubstitutionDetail::default())
        }

        fn visit_none<E>(self) -> Result<Self::Value, E>
        where
            E: de::Error,
        {
            Ok(SubstitutionDetail::default())
        }
    }

    deserializer.deserialize_any(SubstitutionDetailVisitor)
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct SubstitutionDetail {
    #[serde(rename = "in", default)]
    pub player_in: String,
    #[serde(rename = "out", default)]
    pub player_out: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Statistic {
    #[serde(rename = "type")]
    pub stat_type: String,
    pub home: String,
    pub away: String,
}