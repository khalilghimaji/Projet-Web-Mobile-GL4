# Football Streaming Core - Real-Time WebSocket Service

A high-performance, real-time football (soccer) data service built with Rust and Actix-Web. This backend continuously polls live match data from AllSportsAPI and broadcasts events to connected WebSocket clients in real-time.

**Version:** 1.0.0 | **Edition:** Rust 2021

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

   - Compares old vs new match data structure
   - Detects:
     - New matches (first time seen in live data)
     - Goals (new entries in goalscorers array)
     - Cards (new entries in cards array - yellow/red cards)
     - Substitutions (new entries in substitutes array)
     - Score updates (changes in match score)
     - Match ended (match removed from live matches list)
   - Creates `MatchEvent` enums with detailed information
   - All events include timestamps for chronological ordering

4. **Broadcasting** (`actors/broadcaster.rs`):

   - Maintains a set of all connected WebSocket clients
   - Receives events from the Poller
   - Broadcasts each event to all registered clients
   - Handles client connect/disconnect messages

5. **WebSocket Handling** (`actors/websocket.rs`):

   - One actor instance per WebSocket connection
   - Implements heartbeat mechanism (ping/pong every 5s, timeout after 10s)
   - Automatically registers itself with Broadcaster on connect
   - Unregisters from Broadcaster on disconnect
   - Handles client messages:
     - `subscribe_all` - Subscribe to all match events
     - `ping` - Manual ping request
   - Sends events as JSON text messages to clients
   - Automatic cleanup of dead connections via heartbeat monitoring

6. **HTTP Server** (`handlers/websocket_handler.rs`):
   - `/ws` - WebSocket upgrade endpoint (GET request)
   - `/health` - Health check endpoint (returns JSON with status and timestamp)
   - Middleware for request logging
   - CORS support via actix-cors

### Data Flow

```
API Response → Poller → EventDetector → MatchEvent → Broadcaster → WebSocketActor → Client
```

## ✨ Features

- ⚡ **Real-time Updates**: Instant event broadcasting via WebSocket protocol
- 🔄 **Automatic Polling**: Configurable interval polling with retry logic and exponential backoff
- 📊 **Comprehensive Event Detection**: Intelligent change detection for:
  - Match start/end events
  - Goals scored with scorer details
  - Cards issued (yellow/red) with player information
  - Player substitutions
  - Score updates throughout the match
- 🚀 **High Performance**: Built with Rust for memory safety, zero-cost abstractions, and blazing speed
- 🔌 **WebSocket Support**: Full WebSocket protocol with automatic heartbeat monitoring (5s interval, 10s timeout)
- 🐳 **Docker Ready**: Production-ready Docker setup with multi-stage builds
- 📝 **Structured Logging**: Comprehensive tracing with configurable log levels
- 🏥 **Health Checks**: Built-in `/health` endpoint for monitoring and load balancers
- 💾 **Efficient Caching**: Lock-free in-memory caching with DashMap for concurrent access
- 🔒 **TLS Support**: HTTPS-ready with rustls-tls for secure API communication
- ♻️ **Automatic Retry**: Smart retry logic for transient network errors with exponential backoff
- 🧹 **Connection Management**: Automatic cleanup of stale/dead WebSocket connections

## 📦 Prerequisites

- **Rust** 1.75+ (2021 edition) - [Install Rust](https://www.rust-lang.org/tools/install)
- **AllSportsAPI Key** - Get your API key from [AllSportsAPI](https://allsportsapi.com/)
- **Docker** (optional) - For containerized deployment

### Key Dependencies

This project uses the following major dependencies:

- **actix-web** 4.4 - Web framework
- **actix-web-actors** 4.2 - WebSocket support
- **actix** 0.13 - Actor system
- **tokio** 1.35 - Async runtime
- **reqwest** 0.11 - HTTP client with rustls-tls
- **serde** 1.0 - Serialization/deserialization
- **chrono** 0.4 - Date/time handling
- **dashmap** 5.5 - Concurrent hash map
- **tracing** 0.1 - Structured logging

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/football-streaming-core.git
cd football-streaming-core
```

### 2. Configure Environment

Create a `.env` file in the project root:

```env
ALLSPORTS_API_KEY=your_api_key_here
BIND_ADDRESS=0.0.0.0:8080
POLL_INTERVAL_SECS=15
RUST_LOG=info
```

**Environment Variables:**

- `ALLSPORTS_API_KEY` (required): Your AllSportsAPI authentication key
- `BIND_ADDRESS` (optional): Server bind address and port (default: `0.0.0.0:8080`)
- `POLL_INTERVAL_SECS` (optional): API polling interval in seconds (default: `15`)
- `RUST_LOG` (optional): Logging level - `trace`, `debug`, `info`, `warn`, `error` (default: `info`)

### 3. Build and Run

```bash
# Development mode with hot-reload logging
cargo run

# Release mode (optimized for production)
cargo build --release
./target/release/football-backend
```

The server will start and display:

```
INFO  Starting Football Backend Service
INFO  Bind address: 0.0.0.0:8080
INFO  🚀 Server running on http://0.0.0.0:8080
INFO  📡 WebSocket endpoint: ws://0.0.0.0:8080/ws
INFO  📡 Broadcaster actor started
INFO  🔄 Polling service started (interval: 15s)
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

The `POLL_INTERVAL_SECS` determines how frequently the service polls AllSportsAPI. Consider the following:

- **Lower values** (5-10s): More real-time updates, higher API usage, may hit rate limits
- **Higher values** (30-60s): Reduced API usage, slightly delayed updates, more API-friendly
- **Recommended**: 15-20 seconds for optimal balance between responsiveness and API efficiency

**Note**: The polling service includes automatic retry logic with exponential backoff (1s, 2s, 4s) for transient network errors.

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
  "league_id": "302",
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
  --name football-backend \
  football-streaming-core

# View logs
docker logs -f football-backend

# Stop container
docker stop football-backend
docker rm football-backend
```

**Docker Image Details:**
- Base: `rust:1.75` (builder), `debian:bookworm-slim` (runtime)
- Multi-stage build for minimal image size
- Includes CA certificates for HTTPS requests
- Exposes port 8080

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

- **`main.rs`**: Application entry point - orchestrates all components, starts HTTP server and actor system
- **`config.rs`**: Environment configuration management with validation
- **`poller.rs`**: API polling service with retry logic, HTTP client management, and cache handling
- **`event_detector.rs`**: Match state comparison and event detection logic
- **`broadcaster.rs`**: Central actor that manages client registry and event broadcasting
- **`websocket.rs`**: Individual WebSocket connection actor with heartbeat and message handling
- **`websocket_handler.rs`**: HTTP route handlers for WebSocket upgrade and health checks
- **`events.rs`**: Event type definitions with Serde serialization
- **`match_data.rs`**: Match data structures for API responses
- **`api_response.rs`**: AllSportsAPI response models

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

- **Actors**: Actix actor model for concurrent message handling with supervision
- **Services**: Background async tasks for polling and event processing
- **Models**: Strongly-typed data structures with Serde for JSON serialization/deserialization
- **Handlers**: HTTP/WebSocket request handlers integrated with Actix-Web
- **Configuration**: Environment-based configuration with sensible defaults

### Monitoring and Debugging

```bash
# Enable detailed logging
RUST_LOG=debug cargo run

# Enable trace-level logging (very verbose, includes message contents)
RUST_LOG=trace cargo run

# Filter logs by module
RUST_LOG=football_backend::services::poller=debug cargo run

# Production logging (info level)
RUST_LOG=info cargo run
```

## ⚡ Performance

### Capabilities

- **Concurrent Connections**: Designed to handle 100k+ WebSocket connections efficiently
- **Memory Efficiency**: Rust's zero-cost abstractions and lock-free data structures (DashMap)
- **Low Latency**: Event broadcasting happens in microseconds using Actix actor system
- **Resource Usage**: Minimal CPU and memory footprint (~20MB baseline)
- **Actor Model**: Leverages Actix's efficient actor system for concurrent message passing
- **Async I/O**: Tokio-based async runtime for non-blocking network operations

### Optimization Features

1. **HTTP Client Pool**: Persistent connections with configurable keep-alive (60s TCP, 90s pool idle)
2. **Efficient Caching**: Lock-free concurrent hash map (DashMap) for match state
3. **Heartbeat Monitoring**: Automatic cleanup of dead connections (5s ping, 10s timeout)
4. **Structured Logging**: Configurable log levels to reduce overhead in production
5. **Retry Logic**: Exponential backoff for failed API requests to prevent cascading failures
6. **Connection Timeouts**: 30s request timeout, 10s connect timeout for reliability

## 🔍 Troubleshooting

### Common Issues

#### Server won't start

**Error**: `ALLSPORTS_API_KEY must be set`

- **Solution**: Ensure `.env` file exists with valid `ALLSPORTS_API_KEY`

#### No events received

**Possible causes:**
- Matches might not be live on AllSportsAPI at the moment
- API key may be invalid or expired
- Polling service may be experiencing errors
- Client not subscribed to events

**Solutions:**
1. Check server logs for polling errors: `docker logs -f football-backend`
2. Verify API key validity at AllSportsAPI dashboard
3. Ensure you've sent `{"action": "subscribe_all"}` after connecting
4. Check that live matches exist: Visit AllSportsAPI or check response in logs
5. Increase logging level: `RUST_LOG=debug` to see detailed polling information

#### WebSocket connection fails

**Possible causes:**
- Server not running or crashed
- Firewall blocking connections
- Incorrect WebSocket URL format
- Network connectivity issues

**Solutions:**
1. Verify server is running: `curl http://localhost:8080/health`
2. Check firewall settings (allow port 8080)
3. Ensure correct WebSocket URL: `ws://localhost:8080/ws` (not `http://` or `wss://`)
4. Check server logs for startup errors
5. Verify no other service is using port 8080: `netstat -ano | findstr :8080` (Windows)

#### API Connection Issues

**Symptoms:** Errors like "connection closed", "timeout", or "connection refused"

**Solutions:**
- The service has built-in retry logic with exponential backoff
- Check your internet connection
- Verify AllSportsAPI is accessible: `curl https://apiv2.allsportsapi.com/`
- Check for proxy or firewall restrictions
- Review server logs for detailed error messages

#### High API usage

**Symptoms:** Hitting rate limits or excessive API calls

**Solutions:**
1. Increase `POLL_INTERVAL_SECS` to poll less frequently (e.g., 30-60 seconds)
2. Check AllSportsAPI rate limits in your account dashboard
3. Monitor the number of API calls in logs
4. Consider implementing caching strategies for your use case

### Advanced Debugging

#### Enable Debug Logging

```bash
RUST_LOG=debug cargo run
```

#### Check WebSocket Connection

Using `wscat` (install: `npm install -g wscat`):

```bash
# Connect to WebSocket
wscat -c ws://localhost:8080/ws

# Send subscription
> {"action": "subscribe_all"}

# You should receive:
< {"type":"SUBSCRIBED","subscription":"all_matches"}
```

#### Monitor Health Endpoint

```bash
# Check health status
curl http://localhost:8080/health

# Expected response:
{"status":"healthy","timestamp":"2026-01-14T12:00:00.000Z"}
```

#### View Docker Logs

```bash
# Real-time logs
docker-compose logs -f

# Last 100 lines
docker-compose logs --tail=100

# Specific service logs
docker logs football-backend
```

## 📝 License

MIT License - see LICENSE file for details

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Guidelines

1. Follow Rust best practices and idioms
2. Maintain existing code style
3. Add tests for new features
4. Update documentation for API changes
5. Ensure all tests pass before submitting PR

## 📞 Support

For issues and questions:

- Open an issue on GitHub
- Check the [Troubleshooting](#troubleshooting) section
- Review server logs with debug logging enabled
- Ensure all prerequisites are met
- Verify API key validity and AllSportsAPI service status

## 🔗 Related Links

- [AllSportsAPI Documentation](https://allsportsapi.com/documentation)
- [Actix-Web Documentation](https://actix.rs/docs/)
- [Rust Programming Language](https://www.rust-lang.org/)
- [WebSocket Protocol RFC 6455](https://tools.ietf.org/html/rfc6455)

---

**Built with ❤️ using Rust and Actix-Web**

**Last Updated:** January 2026 | **Version:** 1.0.0
