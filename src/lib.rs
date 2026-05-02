use crate::bindings::exports::tofuya::plugin::core_state::Guest;
use crate::bindings::tofuya::provider_gitlab::gitlab_terraform_api::{
    ConnectionConfig, get_state_names,
};
use serde::{Deserialize, Serialize};
use url::Url;

#[allow(warnings)]
mod bindings;

struct Component;

#[derive(Serialize, Deserialize, Default)]
struct Config {
    gitlab_project: String,
}

impl Guest for Component {
    fn get_states() -> Result<Vec<String>, String> {
        let url = std::env::var("STATE_HOST")
            .map_err(|_| "STATE_HOST not provided")?
            .parse::<Url>()
            .map_err(|_| "Failed to parse URL")?
            .join("/api/graphql")
            .map_err(|_| "failed to join URL")?;

        let config_json = std::env::var("TOFUYA_PLUGIN_CONFIG").ok();
        let config = if let Some(config_json) = config_json {
            serde_json::from_str(config_json.as_str()).map_err(|_| "Failed to parse config")?
        } else {
            Config::default()
        };

        let access_token = std::env::var("GITLAB_ACCESS_TOKEN").ok();

        let connection_config = ConnectionConfig {
            api_url: url.to_string(),
            auth_token: access_token,
        };

        let states = get_state_names(&connection_config, config.gitlab_project.as_str())
            .map_err(|e| format!("failed to get states from gitlab provider: {}", e))?;

        Ok(states)
    }
}

bindings::export!(Component with_types_in bindings);
