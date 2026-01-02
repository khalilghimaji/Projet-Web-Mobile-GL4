use actix::Addr;
use actix_web::{web, HttpRequest, HttpResponse, Error};
use actix_web_actors::ws;

use crate::actors::broadcaster::Broadcaster;
use crate::actors::websocket::WebSocketActor;

pub async fn ws_index(
    req: HttpRequest,
    stream: web::Payload,
    broadcaster: web::Data<Addr<Broadcaster>>,
) -> Result<HttpResponse, Error> {
    let broadcaster = broadcaster.get_ref().clone();
    ws::start(WebSocketActor::new(broadcaster), &req, stream)
}

pub async fn health_check() -> HttpResponse {
    HttpResponse::Ok().json(serde_json::json!({
        "status": "healthy",
        "timestamp": chrono::Utc::now().to_rfc3339(),
    }))
}