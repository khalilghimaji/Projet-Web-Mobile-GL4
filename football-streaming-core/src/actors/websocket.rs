use actix::prelude::*;
use actix_web_actors::ws;
use std::time::{Duration, Instant};

use crate::actors::broadcaster::{Broadcaster, BroadcastMessage, Connect, Disconnect};
use crate::models::{ClientMessage};

const HEARTBEAT_INTERVAL: Duration = Duration::from_secs(5);
const CLIENT_TIMEOUT: Duration = Duration::from_secs(10);

pub struct WebSocketActor {
    hb: Instant,
    broadcaster: Addr<Broadcaster>,
}

impl WebSocketActor {
    pub fn new(broadcaster: Addr<Broadcaster>) -> Self {
        Self {
            hb: Instant::now(),
            broadcaster,
        }
    }

    fn hb(&self, ctx: &mut ws::WebsocketContext<Self>) {
        ctx.run_interval(HEARTBEAT_INTERVAL, |act, ctx| {
            if Instant::now().duration_since(act.hb) > CLIENT_TIMEOUT {
                tracing::warn!("WebSocket client heartbeat timeout, disconnecting");
                ctx.stop();
                return;
            }

            ctx.ping(b"");
        });
    }
}

impl Actor for WebSocketActor {
    type Context = ws::WebsocketContext<Self>;

    fn started(&mut self, ctx: &mut Self::Context) {
        self.hb(ctx);

        let addr = ctx.address();
        self.broadcaster
            .send(Connect {
                addr: addr.recipient(),
            })
            .into_actor(self)
            .then(|res, _, ctx| {
                match res {
                    Ok(_) => tracing::info!("WebSocket actor registered with broadcaster"),
                    Err(_) => ctx.stop(),
                }
                fut::ready(())
            })
            .wait(ctx);

        tracing::info!("WebSocket connection established");
    }

    fn stopped(&mut self, ctx: &mut Self::Context) {
        self.broadcaster.do_send(Disconnect {
            addr: ctx.address().recipient(),
        });
        tracing::info!("WebSocket connection closed");
    }
}

impl Handler<BroadcastMessage> for WebSocketActor {
    type Result = ();

    fn handle(&mut self, msg: BroadcastMessage, ctx: &mut Self::Context) {
        // Send event to client
        match serde_json::to_string(&msg.event) {
            Ok(json) => {
                tracing::debug!("Sending WebSocket message: {}", json);
                ctx.text(json);
            }
            Err(e) => {
                tracing::error!("Failed to serialize event to JSON: {}", e);
            }
        }
    }
}

impl StreamHandler<Result<ws::Message, ws::ProtocolError>> for WebSocketActor {
    fn handle(&mut self, msg: Result<ws::Message, ws::ProtocolError>, ctx: &mut Self::Context) {
        match msg {
            Ok(ws::Message::Ping(msg)) => {
                self.hb = Instant::now();
                ctx.pong(&msg);
            }
            Ok(ws::Message::Pong(_)) => {
                self.hb = Instant::now();
            }
            Ok(ws::Message::Text(text)) => {
                // Handle client messages (subscription, etc.)
                if let Ok(client_msg) = serde_json::from_str::<ClientMessage>(&text) {
                    match client_msg.action.as_str() {
                        "subscribe_all" => {
                            tracing::info!("Client subscribed to all matches");
                            ctx.text(r#"{"type":"SUBSCRIBED","subscription":"all_matches"}"#);
                        }
                        "ping" => {
                            ctx.text(r#"{"type":"PONG"}"#);
                        }
                        _ => {
                            tracing::warn!("Unknown action: {}", client_msg.action);
                        }
                    }
                }
            }
            Ok(ws::Message::Binary(_)) => {
                tracing::warn!("Binary message not supported");
            }
            Ok(ws::Message::Close(reason)) => {
                ctx.close(reason);
                ctx.stop();
            }
            Err(e) => {
                tracing::error!("WebSocket error: {}", e);
                ctx.stop();
            }
            _ => {}
        }
    }
}