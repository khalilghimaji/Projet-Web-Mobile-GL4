use actix::Actor;
use actix_web::{web, App, HttpServer, middleware};
use tracing_subscriber;

mod config;
mod models;
mod services;
mod actors;
mod handlers;

use actors::broadcaster::Broadcaster;
use services::poller::Poller;
use services::mock_poller::MockPoller;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // Initialize logging
    let filter = tracing_subscriber::EnvFilter::try_from_default_env()
        .unwrap_or_else(|_| tracing_subscriber::EnvFilter::new("info"));
    
    tracing_subscriber::fmt()
        .with_env_filter(filter)
        .init();

    // Load configuration
    dotenv::dotenv().ok();
    let config = config::Config::from_env();
    
    tracing::info!("Starting Football Backend Service");
    tracing::info!("Bind address: {}", config.bind_address);
    
    // Start broadcaster actor
    let broadcaster = Broadcaster::new().start();
    let broadcaster_clone = broadcaster.clone();
    
    // Start polling service (real or mock)
    let use_mock = config.mock_mode || config.api_key.is_none();
    if use_mock {
        if config.api_key.is_none() && !config.mock_mode {
            tracing::warn!(
                "ALLSPORTS_API_KEY not set. Falling back to MOCK_MODE to keep websocket usable."
            );
        }

        let mock = MockPoller::new(config.poll_interval_secs, broadcaster.clone());
        tokio::spawn(async move {
            mock.start().await;
        });
    } else {
        let poller = Poller::new(
            config.api_key.clone().expect("api_key missing but mock mode disabled"),
            config.poll_interval_secs,
            broadcaster.clone(),
        );

        tokio::spawn(async move {
            poller.start().await;
        });
    }
    
    // Start HTTP server with WebSocket
    tracing::info!("🚀 Server running on http://{}", config.bind_address);
    tracing::info!("📡 WebSocket endpoint: ws://{}/ws", config.bind_address);
    
    HttpServer::new(move || {
        App::new()
            .wrap(middleware::Logger::default())
            .app_data(web::Data::new(broadcaster_clone.clone()))
            .route("/ws", web::get().to(handlers::websocket_handler::ws_index))
            .route("/health", web::get().to(handlers::websocket_handler::health_check))
    })
    .bind(&config.bind_address)?
    .run()
    .await
}