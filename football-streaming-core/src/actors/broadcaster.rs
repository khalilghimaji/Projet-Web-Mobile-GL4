use actix::prelude::*;
use std::collections::HashSet;

use crate::models::MatchEvent;

#[derive(Message)]
#[rtype(result = "()")]
pub struct BroadcastMessage {
    pub event: MatchEvent,
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct Connect {
    pub addr: Recipient<BroadcastMessage>,
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct Disconnect {
    pub addr: Recipient<BroadcastMessage>,
}

pub struct Broadcaster {
    clients: HashSet<Recipient<BroadcastMessage>>,
}

impl Broadcaster {
    pub fn new() -> Self {
        Self {
            clients: HashSet::new(),
        }
    }
}

impl Actor for Broadcaster {
    type Context = Context<Self>;

    fn started(&mut self, _: &mut Self::Context) {
        tracing::info!("📡 Broadcaster actor started");
    }
}

impl Handler<Connect> for Broadcaster {
    type Result = ();

    fn handle(&mut self, msg: Connect, _: &mut Context<Self>) {
        self.clients.insert(msg.addr);
        tracing::info!("✅ Client connected (total: {})", self.clients.len());
    }
}

impl Handler<Disconnect> for Broadcaster {
    type Result = ();

    fn handle(&mut self, msg: Disconnect, _: &mut Context<Self>) {
        self.clients.remove(&msg.addr);
        tracing::info!("❌ Client disconnected (total: {})", self.clients.len());
    }
}

impl Handler<BroadcastMessage> for Broadcaster {
    type Result = ();

    fn handle(&mut self, msg: BroadcastMessage, _: &mut Context<Self>) {
        // Broadcast to all connected clients
        let client_count = self.clients.len();
        tracing::debug!("Broadcasting event to {} clients", client_count);
        
        self.clients.iter().for_each(|client| {
            client.do_send(BroadcastMessage {
                event: msg.event.clone(),
            });
        });
    }
}