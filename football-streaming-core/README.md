# Football Streaming Core - Real-Time WebSocket Service

A high-performance, real-time football (soccer) data service built with Rust and Actix-Web. This backend continuously polls live match data from AllSportsAPI and broadcasts events to connected WebSocket clients in real-time.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [WebSocket API](#websocket-api)
- [Event Types](#event-types)
- [Docker Deployment](#docker-deployment)
- [Project Structure](#project-structure)
- [Development](#development)
- [Performance](#performance)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This service acts as a real-time bridge between AllSportsAPI and your applications. It:

1. **Polls** live match data from AllSportsAPI at configurable intervals
2. **Detects** changes in match state (goals, cards, substitutions, etc.)
3. **Broadcasts** events to all connected WebSocket clients instantly
4. **Manages** client connections with heartbeat monitoring and automatic cleanup

The system is designed to handle thousands of concurrent WebSocket connections efficiently using Rust's actor model and async runtime.

## 🏗️ Architecture

### System Components

```
┌─────────────────┐
│  AllSportsAPI   │
└────────┬────────┘
         │
         │ HTTP Polling (every N seconds)
         ▼
┌─────────────────┐
│     Poller      │ ◄─── Polls API & detects changes
└────────┬────────┘
         │
         │ Sends events
         ▼
┌─────────────────┐
│   Broadcaster   │ ◄─── Actor that manages clients
└────────┬────────┘
         │
         │ Broadcasts to all
         ▼
┌─────────────────┐
│ WebSocket Actor │ ◄─── One per client connection
└────────┬────────┘
         │
         │ WebSocket messages
         ▼
┌─────────────────┐
│     Clients     │
└─────────────────┘
```

### How It Works

1. **Initialization** (`main.rs`):

   - Loads configuration from environment variables
   - Starts the `Broadcaster` actor (manages all WebSocket connections)
   - Spawns the `Poller` service in a background task
   - Starts the HTTP server with WebSocket endpoint

2. **Polling Service** (`services/poller.rs`):

   - Runs in a loop, fetching live matches every N seconds (default: 15s)
   - Maintains an in-memory cache (`DashMap`) of previous match states
   - Compares new data with cached data to detect changes
   - Uses `EventDetector` to identify specific events (goals, cards, etc.)
   - Sends detected events to the `Broadcaster` actor

3. **Event Detection** (`services/event_detector.rs`):

   - Compares old vs new match data
   - Detects:
     - New matches (first time seen)
     - Goals (new entries in goalscorers array)
     - Cards (new entries in cards array - yellow/red)
     - Substitutions (new entries in substitutes array)
     - Score updates (changes in final_result)
     - Match ended (match removed from live matches)

4. **Broadcasting** (`actors/broadcaster.rs`):

   - Maintains a set of all connected WebSocket clients
   - Receives events from the Poller
   - Broadcasts each event to all registered clients
   - Handles client connect/disconnect messages

5. **WebSocket Handling** (`actors/websocket.rs`):

   - One actor instance per WebSocket connection
   - Implements heartbeat mechanism (ping/pong) to detect dead connections
   - Registers itself with Broadcaster on connect
   - Unregisters on disconnect
   - Handles client messages (subscriptions, ping)
   - Sends events as JSON text messages

6. **HTTP Server** (`handlers/websocket_handler.rs`):
   - `/ws` - WebSocket upgrade endpoint
   - `/health` - Health check endpoint (returns JSON status)

### Data Flow

```
API Response → Poller → EventDetector → MatchEvent → Broadcaster → WebSocketActor → Client
```

## ✨ Features

- ⚡ **Real-time Updates**: Instant event broadcasting via WebSocket
- 🔄 **Automatic Polling**: Configurable interval polling from AllSportsAPI
- 📊 **Event Detection**: Intelligent change detection for:
  - Match start/end
  - Goals scored
  - Cards issued (yellow/red)
  - Player substitutions
  - Score updates
- 🚀 **High Performance**: Built with Rust for memory safety and speed
- 🔌 **WebSocket Support**: Full WebSocket protocol with heartbeat monitoring
- 🐳 **Docker Ready**: Complete Docker setup for easy deployment
- 📝 **Structured Logging**: Comprehensive logging with tracing
- 🏥 **Health Checks**: Built-in health check endpoint
- 💾 **In-Memory Caching**: Efficient match state caching with DashMap

## 📦 Prerequisites

- **Rust** 1.75+ (2021 edition) - [Install Rust](https://www.rust-lang.org/tools/install)
- **AllSportsAPI Key** - Get your API key from [AllSportsAPI](https://allsportsapi.com/)
- **Docker** (optional) - For containerized deployment

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/AchrefHemissi/football-streaming-core.git
cd football-streaming-core
```

### 2. Configure Environment

Create a `.env` file in the project root:

```bash
ALLSPORTS_API_KEY=your_api_key_here
BIND_ADDRESS=0.0.0.0:8080
POLL_INTERVAL_SECS=15
RUST_LOG=info
```

**Environment Variables:**

- `ALLSPORTS_API_KEY` (required): Your AllSportsAPI key
- `BIND_ADDRESS` (optional): Server bind address (default: `0.0.0.0:8080`)
- `POLL_INTERVAL_SECS` (optional): Polling interval in seconds (default: `15`)
- `RUST_LOG` (optional): Logging level (default: `info`)

### 3. Build and Run

```bash
# Development mode
cargo run

# Release mode (optimized)
cargo build --release
./target/release/football-backend
```

The server will start and you'll see:

```
🚀 Server running on http://0.0.0.0:8080
📡 WebSocket endpoint: ws://0.0.0.0:8080/ws
```

## 🔧 Configuration

### Environment Variables

| Variable             | Required | Default        | Description                                     |
| -------------------- | -------- | -------------- | ----------------------------------------------- |
| `ALLSPORTS_API_KEY`  | Yes      | -              | AllSportsAPI authentication key                 |
| `BIND_ADDRESS`       | No       | `0.0.0.0:8080` | Server bind address and port                    |
| `POLL_INTERVAL_SECS` | No       | `15`           | Polling interval in seconds                     |
| `RUST_LOG`           | No       | `info`         | Logging level (trace, debug, info, warn, error) |

### Polling Interval

The `POLL_INTERVAL_SECS` determines how frequently the service polls AllSportsAPI:

- **Lower values** (5-10s): More real-time updates, higher API usage
- **Higher values** (30-60s): Less API usage, slightly delayed updates
- **Recommended**: 15-30 seconds for most use cases

## 📖 Usage

### WebSocket Connection

Connect to the WebSocket endpoint:

```javascript
const ws = new WebSocket("ws://localhost:8080/ws");
```

### Subscribe to Events

After connecting, send a subscription message:

```json
{
  "action": "subscribe_all"
}
```

The server will respond with:

```json
{
  "type": "SUBSCRIBED",
  "subscription": "all_matches"
}
```

### Receiving Events

Once subscribed, you'll receive real-time events as JSON messages:

```json
{
  "type": "GOAL_SCORED",
  "match_id": "12345",
  "minute": "23",
  "scorer": "Lionel Messi",
  "team": "home",
  "score": "1-0",
  "home_team": "Barcelona",
  "away_team": "Real Madrid",
  "timestamp": "2024-01-15T14:23:45Z"
}
```

### Health Check

Check service health via HTTP:

```bash
curl http://localhost:8080/health
```

Response:

```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T14:23:45.123Z"
}
```

### Test Client

A test HTML client is included (`test-client.html`). Open it in a browser to see live events:

```bash
# Simply open test-client.html in your browser
# Make sure the server is running on localhost:8080
```

## 🔌 WebSocket API

### Client Messages

#### Subscribe to All Matches

```json
{
  "action": "subscribe_all"
}
```

#### Ping

```json
{
  "action": "ping"
}
```

Server responds with:

```json
{
  "type": "PONG"
}
```

### Server Messages

All events are sent as JSON with a `type` field indicating the event type. See [Event Types](#event-types) for details.

## 📊 Event Types

### MATCH_STARTED

Triggered when a new match is detected (first time seen in live matches).

```json
{
  "type": "MATCH_STARTED",
  "match_id": "12345",
  "home_team": "Barcelona",
  "away_team": "Real Madrid",
  "league": "La Liga",
  "league_id": "302",
  "start_time": "2024-01-15 20:00",
  "timestamp": "2024-01-15T20:00:00Z"
}
```

### GOAL_SCORED

Triggered when a new goal is detected.

```json
{
  "type": "GOAL_SCORED",
  "match_id": "12345",
  "minute": "23",
  "scorer": "Lionel Messi",
  "team": "home",
  "score": "1-0",
  "home_team": "Barcelona",
  "away_team": "Real Madrid",
  "league_id": "302",
  "timestamp": "2024-01-15T20:23:00Z"
}
```

### CARD_ISSUED

Triggered when a card (yellow or red) is issued.

```json
{
  "type": "CARD_ISSUED",
  "match_id": "12345",
  "minute": "45",
  "player": "Sergio Ramos",
  "team": "away",
  "card_type": "yellow card",
  "home_team": "Barcelona",
  "away_team": "Real Madrid",
  "league_id": "302",
  "timestamp": "2024-01-15T20:45:00Z"
}
```

### SUBSTITUTION

Triggered when a player substitution occurs.

```json
{
  "type": "SUBSTITUTION",
  "match_id": "12345",
  "minute": "60",
  "player_in": "Antoine Griezmann",
  "player_out": "Ousmane Dembélé",
  "team": "home",
  "home_team": "Barcelona",
  "away_team": "Real Madrid",
  "league_id": "302",
  "timestamp": "2024-01-15T21:00:00Z"
}
```

### SCORE_UPDATE

Triggered when the match score changes.

```json
{
  "type": "SCORE_UPDATE",
  "match_id": "12345",
  "home_team": "Barcelona",
  "away_team": "Real Madrid",
  "score": "2-1",
  "status": "2nd Half",
  "league_id": "302",
  "timestamp": "2024-01-15T21:15:00Z"
}
```

### MATCH_ENDED

Triggered when a match is removed from the live matches list (typically when finished).

```json
{
  "type": "MATCH_ENDED",
  "match_id": "12345",
  "home_team": "Barcelona",
  "home_team_key": "67890",
  "away_team": "Real Madrid",
  "away_team_key": "67891",
  "final_score": "3-1",
  "halftime_score": "1-0",
  "league": "La Liga",
  "league_key": "302",
  "country": "Spain",
  "timestamp": "2024-01-15T22:00:00Z"
}
```

## 🐳 Docker Deployment

### Using Docker Compose

1. Create a `.env` file with your API key:

```bash
ALLSPORTS_API_KEY=your_api_key_here
```

2. Start the service:

```bash
docker-compose up -d
```

3. View logs:

```bash
docker-compose logs -f
```

4. Stop the service:

```bash
docker-compose down
```

### Manual Docker Build

```bash
# Build image
docker build -t football-streaming-core .

# Run container
docker run -d \
  -p 8080:8080 \
  -e ALLSPORTS_API_KEY=your_api_key_here \
  -e BIND_ADDRESS=0.0.0.0:8080 \
  -e POLL_INTERVAL_SECS=15 \
  -e RUST_LOG=info \
  --name football-streaming-core \
  football-streaming-core
```

## 📁 Project Structure

```
football-streaming-core/
├── src/
│   ├── main.rs                 # Application entry point
│   ├── config.rs               # Configuration management
│   ├── actors/
│   │   ├── mod.rs
│   │   ├── broadcaster.rs      # Broadcasts events to all clients
│   │   └── websocket.rs         # WebSocket connection handler
│   ├── handlers/
│   │   ├── mod.rs
│   │   └── websocket_handler.rs # HTTP/WebSocket route handlers
│   ├── models/
│   │   ├── mod.rs
│   │   ├── api_response.rs     # AllSportsAPI response structure
│   │   ├── events.rs            # Match event definitions
│   │   └── match_data.rs        # Match data structures
│   └── services/
│       ├── mod.rs
│       ├── poller.rs            # API polling service
│       └── event_detector.rs    # Change detection logic
├── Cargo.toml                   # Rust dependencies
├── Dockerfile                   # Docker build configuration
├── docker-compose.yml           # Docker Compose configuration
├── test-client.html             # WebSocket test client
└── README.md                    # This file
```

### Key Modules

- **`main.rs`**: Orchestrates all components, starts server
- **`config.rs`**: Loads and validates environment configuration
- **`poller.rs`**: Fetches data from API, manages cache, triggers events
- **`event_detector.rs`**: Compares match states, detects changes
- **`broadcaster.rs`**: Actor that manages client registry and broadcasting
- **`websocket.rs`**: Individual WebSocket connection actor with heartbeat
- **`websocket_handler.rs`**: HTTP route handlers for WebSocket upgrade

## 🛠️ Development

### Running in Development

```bash
# Run with debug logging
RUST_LOG=debug cargo run

# Run with trace logging (very verbose)
RUST_LOG=trace cargo run
```

### Building for Production

```bash
cargo build --release
```

The optimized binary will be in `target/release/football-backend`.

### Testing WebSocket Connection

Use the included `test-client.html`:

1. Start the server: `cargo run`
2. Open `test-client.html` in a browser
3. Click "Connect" or wait for auto-connect
4. Watch live events appear

### Code Structure

- **Actors**: Use Actix actor model for concurrent message handling
- **Services**: Background tasks for polling and processing
- **Models**: Data structures with Serde for JSON serialization
- **Handlers**: HTTP/WebSocket request handlers

## ⚡ Performance

### Capabilities

- **Concurrent Connections**: Designed to handle 100k+ WebSocket connections
- **Memory Efficiency**: Rust's zero-cost abstractions and efficient data structures
- **Low Latency**: Event broadcasting happens in microseconds
- **Resource Usage**: Minimal CPU and memory footprint

### Optimization Tips

1. **Polling Interval**: Balance between real-time updates and API rate limits
2. **Logging Level**: Use `info` or `warn` in production (avoid `trace`/`debug`)
3. **Connection Management**: Heartbeat mechanism automatically cleans up dead connections
4. **Caching**: In-memory cache prevents redundant event detection

## 🔍 Troubleshooting

### Common Issues

#### Server won't start

**Error**: `ALLSPORTS_API_KEY must be set`

- **Solution**: Ensure `.env` file exists with valid `ALLSPORTS_API_KEY`

#### No events received

- Check that matches are actually live on AllSportsAPI
- Verify API key is valid and has access
- Check server logs for polling errors
- Ensure you've sent `subscribe_all` message after connecting

#### WebSocket connection fails

- Verify server is running: `curl http://localhost:8080/health`
- Check firewall settings
- Ensure correct WebSocket URL: `ws://localhost:8080/ws` (not `http://`)

#### High API usage

- Increase `POLL_INTERVAL_SECS` to poll less frequently
- Check AllSportsAPI rate limits

### Debugging

Enable debug logging:

```bash
RUST_LOG=debug cargo run
```

Check WebSocket connection:

```bash
# Use wscat or similar tool
wscat -c ws://localhost:8080/ws
```

## 📝 License

MIT License - see LICENSE file for details

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For issues and questions:

- Check the troubleshooting section
- Review server logs
- Ensure all prerequisites are met
- Verify API key validity

---

**Built with ❤️ using Rust and Actix-Web**
