# KickStream : Football Prediction & Streaming Platform 🏆⚽

A full-stack real-time football (soccer) prediction and streaming application built with modern web technologies. This project combines Angular 20 frontend, NestJS backend API, and a high-performance Rust WebSocket service for real-time match updates.

[![Angular](https://img.shields.io/badge/Angular-20.3.15-red?logo=angular)](https://angular.io/)
[![NestJS](https://img.shields.io/badge/NestJS-11.0.1-e0234e?logo=nestjs)](https://nestjs.com/)
[![Rust](https://img.shields.io/badge/Rust-2021-orange?logo=rust)](https://www.rust-lang.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.9-blue?logo=typescript)](https://www.typescriptlang.org/)

## 📋 Table of Contents

- [Overview](#overview)
- [Project Architecture](#project-architecture)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Frontend (Angular)](#frontend-angular)
- [Backend (NestJS)](#backend-nestjs)
- [Real-Time Service (Rust)](#real-time-service-rust)
- [Development](#development)
- [Deployment](#deployment)
- [License](#license)

## 🎯 Overview

This platform allows users to:
- **Browse and Track** live football matches from multiple leagues
- **Predict Match Outcomes** and compete with other users
- **Receive Real-Time Updates** for goals, cards, substitutions, and other match events
- **View Detailed Statistics** including team standings, player info, and historical data
- **Earn Rankings and Rewards** through a gamified prediction system with diamond currency

The application integrates with **AllSportsAPI** for comprehensive football data and uses WebSocket technology for millisecond-latency live updates.

## 🏗️ Project Architecture

This is a **microservices-based architecture** with three main components:

```
┌─────────────────────────────────────────────────────────────┐
│                     Frontend (Angular 20)                    │
│  • Web UI with Material Design & PrimeNG                   │
│  • Match browsing, predictions, user rankings              │
│  • Real-time event updates via WebSocket                   │
└────────────┬────────────────────────────┬────────────────────┘
             │                            │
             │ REST                       │ WebSocket
             │                            │
┌────────────▼──────────────┐  ┌─────────▼────────────────────┐
│   Backend (NestJS)        │  │  Streaming Core (Rust)       │
│  • REST API               │  │  • Real-time event service   │
│  • User auth & profiles   │  │  • Polls AllSportsAPI        │
│  • Predictions & rankings │  │  • Broadcasts match events   │
│  • MySQL database         │  │  • 100k+ connections         │
│  • Redis caching          │  │  • Ultra-low latency         │
└───────────────────────────┘  └──────────────────────────────┘
```

### Component Responsibilities

| Component | Technology | Purpose | Port |
|-----------|-----------|---------|------|
| **Frontend** | Angular 20 | User interface & interaction | 4200 |
| **Backend** | NestJS 11 | Business logic, API, database | 3003 |
| **Core Service** | Rust/Actix | Real-time match event streaming | 8080 |

## ✨ Features

### User Features
- ✅ **User Authentication** - Email/password, OAuth (Google, GitHub), MFA support
- ✅ **Match Predictions** - Predict match outcomes and earn points
- ✅ **Rankings & Leaderboards** - Compete with other users
- ✅ **Diamond Store** - In-app currency for premium features
- ✅ **Notifications** - Real-time alerts for match events and predictions
- ✅ **Team & Player Stats** - Detailed statistics and historical data

### Technical Features
- ⚡ **Real-Time Updates** - WebSocket-based live match events
- 🔄 **Automatic Token Refresh** - Seamless authentication experience
- 📱 **Responsive Design** - Mobile-first approach with Tailwind CSS
- 🌙 **Dark Mode Support** - PrimeNG theme system
- 🚀 **Server-Side Rendering** - Angular SSR for better SEO
- 🎨 **Modern UI** - PrimeNG + Angular Material components
- 🔒 **Security** - JWT tokens, CSRF protection, input validation

## 🛠️ Technology Stack

### Frontend (Angular)
- **Framework**: Angular 20.3.15 with standalone components
- **UI Libraries**: 
  - PrimeNG 20.4.0 (components)
  - Angular Material 20.0.0 (additional components)
  - Tailwind CSS 4.1.18 (styling)
  - Lucide Angular 0.562.0 (icons)
- **State Management**: RxJS 7.8 with Angular Signals
- **HTTP Client**: Angular HTTP with interceptors
- **Build Tool**: Angular CLI 20.3.13
- **Testing**: Jasmine + Karma

### Backend (NestJS)
- **Framework**: NestJS 11.0.1 (Node.js)
- **API**: REST
- **Database**: MySQL with TypeORM 0.3.22
- **Authentication**: 
  - JWT (jsonwebtoken 9.0.2)
  - Passport with strategies (Local, JWT, Google, GitHub)
  - Two-Factor Authentication (otplib 12.0.1)
- **Real-Time**: Socket.io 4.8.1
- **Caching**: Redis (ioredis 5.6.1)
- **Email**: Nodemailer 6.10.1 with Handlebars templates
- **Security**: Helmet, bcrypt, CSRF protection
- **Testing**: Jest

### Real-Time Service (Rust)
- **Framework**: Actix-Web 4.4
- **Runtime**: Tokio (async)
- **WebSocket**: actix-web-actors 4.2
- **HTTP Client**: reqwest 0.11 with rustls-tls
- **Serialization**: Serde 1.0
- **Concurrency**: DashMap 5.5 (lock-free cache)
- **Logging**: tracing 0.1

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

### Required
- **Node.js** 18+ and npm
- **Rust** 1.75+ (for the core service)
- **MySQL** 5.7+ or 8.0+
- **Redis** (for caching)

### Optional but Recommended
- **Docker** and Docker Compose (for containerized deployment)
- **Git** (for version control)

### API Keys
- **AllSportsAPI Key** - Get your free API key from [AllSportsAPI](https://allsportsapi.com/)
- **OAuth Credentials** - Google and GitHub OAuth apps (optional)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/khalilghimaji/Projet-Web-Mobile-GL4.git
cd Projet-Web-Mobile-GL4
```

### 2. Start the Real-Time Service (Rust)

```bash
cd football-streaming-core

# Create .env file
echo "ALLSPORTS_API_KEY=your_api_key_here" > .env
echo "BIND_ADDRESS=0.0.0.0:8080" >> .env
echo "POLL_INTERVAL_SECS=15" >> .env

# Run the service
cargo run
```

### 3. Start the Backend (NestJS)

```bash
cd ../back

# Install dependencies
npm install

# Configure .env file with database credentials
# (See Backend section for details)

# Run migrations and start
npm run start:dev
```

### 4. Start the Frontend (Angular)

```bash
cd ../front

# Install dependencies
npm install

# Start development server
npm start
```

### 5. Access the Application

- **Frontend**: http://localhost:4200
- **Backend API**: http://localhost:3003
- **WebSocket Service**: ws://localhost:8080/ws
- **Health Check**: http://localhost:8080/health

## 🎨 Frontend (Angular)

The frontend is a modern Angular 20 application with standalone components, zoneless change detection, and server-side rendering support.

### Project Structure

```
front/
├── src/
│   ├── app/
│   │   ├── components/          # Reusable UI components
│   │   │   ├── auth/           # Authentication components
│   │   │   ├── matches/        # Match-related components
│   │   │   ├── standings/      # League standings
│   │   │   ├── teams/          # Team details
│   │   │   └── shared/         # Shared components
│   │   ├── services/           # Angular services
│   │   │   ├── Api/            # Auto-generated API services
│   │   │   ├── auth.service.ts
│   │   │   ├── live-events.service.ts
│   │   │   └── ...
│   │   ├── guards/             # Route guards
│   │   ├── interceptors/       # HTTP interceptors
│   │   ├── models/             # TypeScript interfaces
│   │   └── app.routes.ts       # Route configuration
│   ├── environments/           # Environment configs
│   └── styles.css              # Global styles
├── angular.json                # Angular CLI configuration
├── tailwind.config.js          # Tailwind CSS config
└── package.json
```

### Key Features

#### 1. Authentication System
- **Login/Signup** with email verification
- **Multi-Factor Authentication (MFA)** with QR code setup
- **OAuth Integration** (Google, GitHub)
- **Password Recovery** with email tokens
- **Automatic Token Refresh** via interceptors

#### 2. Match Management
- **Fixtures Page** - Browse upcoming and past matches
- **Match Details** - Comprehensive match information including:
  - Live scores and match status
  - Team lineups and formations
  - Player statistics
  - Match timeline with events
  - Sentiment voting
  - Score predictions
- **Real-Time Updates** - WebSocket integration for live events

#### 3. User Engagement
- **Rankings Page** - User leaderboard based on prediction accuracy
- **Diamond Store** - Purchase in-app currency
- **Notifications** - Real-time alerts for matches and predictions
- **User Profile** - Stats, history, and achievements

#### 4. Team & League Information
- **Team Details** - Squad information, recent matches, statistics
- **Standings** - League tables and rankings
- **Player Cards** - Individual player information

### Setup Instructions

#### Install Dependencies

```bash
cd front
npm install
```

#### Configure Environment

Update `src/environments/environment.ts`:

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:3003',
  websocketUrl: 'ws://localhost:8080/ws',
  allSportsApiKey: 'your_allsports_api_key'
};
```

#### Generate API Services

If the backend API changes, regenerate the API services:

```bash
npm run api-gen
```

This uses OpenAPI Generator to create TypeScript services from the backend's Swagger documentation.

#### Available Scripts

```bash
# Development server (http://localhost:4200)
npm start

# Production build
npm run build

# Run unit tests
npm test

# Server-side rendering build
npm run build:ssr

# Serve SSR application
npm run serve:ssr:front

# Generate API services from backend
npm run api-gen
```

### Angular Architecture Highlights

#### Standalone Components
All components use Angular's standalone API for better tree-shaking and modularity:

```typescript
@Component({
  selector: 'app-match-detail',
  standalone: true,
  imports: [CommonModule, RouterModule, PrimeNGModules],
  templateUrl: './match-detail.component.html'
})
export class MatchDetailComponent { }
```

#### Route Guards & Lazy Loading

Routes are protected with guards and lazy-loaded for optimal performance:

```typescript
{
  path: 'rankings',
  canActivate: [tokenValidationGuard],
  loadComponent: () => import('./components/rankings/ranking-page.component')
}
```

#### HTTP Interceptors

Three interceptors handle different aspects of HTTP communication:

1. **CredentialsInterceptor** - Manages credentials
2. **AuthInterceptor** - Handles 401 errors and token refresh
3. **ApiKeyInterceptor** - Injects API keys for external services

#### State Management

The application uses RxJS and Angular Signals for reactive state:

```typescript
// Service with signals
export class AuthService {
  currentUser = signal<User | null>(null);
  isAuthenticated = computed(() => !!this.currentUser());
}
```

### UI Components

#### PrimeNG Components Used
- Button, InputText, Password, Dropdown, Calendar
- Table, DataView, Card, Panel
- Toast, Dialog, ConfirmDialog
- TabView, Accordion, Stepper
- ProgressBar, ProgressSpinner
- Badge, Tag, Chip

#### Material Components Used
- MatIcon
- MatButton
- MatDialog

#### Tailwind CSS
Custom utility classes are used throughout for responsive design:

```html
<div class="flex flex-col md:flex-row gap-4 p-4">
  <div class="w-full md:w-1/2">...</div>
</div>
```

### Real-Time Features

#### WebSocket Connection

```typescript
// live-events.service.ts
connectToLiveEvents() {
  this.ws = new WebSocket('ws://localhost:8080/ws');
  
  this.ws.onopen = () => {
    this.ws.send(JSON.stringify({ action: 'subscribe_all' }));
  };
  
  this.ws.onmessage = (event) => {
    const data = JSON.parse(event.data);
    this.handleMatchEvent(data);
  };
}
```

## 🔧 Backend (NestJS)

A robust NestJS backend providing REST APIs with comprehensive authentication and real-time capabilities.

### Project Structure

```
back/
├── src/
│   ├── auth/               # Authentication module
│   │   ├── guards/
│   │   ├── strategies/
│   │   └── decorators/
│   ├── users/              # User management
│   ├── matches/            # Match data & predictions
│   ├── notifications/      # Notification system
│   ├── teams/              # Team information
│   ├── standings/          # League standings
│   ├── websockets/         # Socket.io gateway
│   └── main.ts             # Application entry
├── test/                   # E2E tests
└── package.json
```

### Key Features

#### 1. Dual API (REST)
- **REST API** - Traditional endpoints with Swagger documentation
- **API Documentation** - Available at `/api` (Swagger)

#### 2. Authentication & Authorization
- **JWT-based authentication** with refresh tokens
- **Local Strategy** - Email/password login
- **OAuth Strategies** - Google and GitHub
- **Two-Factor Authentication** - TOTP with QR codes
- **Email Verification** - Secure email confirmation
- **Password Reset** - Token-based recovery

#### 3. Database & ORM
- **TypeORM** for database management
- **MySQL** as primary database
- **Migrations** for schema versioning
- **Entities** with decorators

#### 4. Real-Time Communication
- **Socket.io** for WebSocket connections
- **Event Broadcasting** for live updates
- **Room-based** communication for match-specific events

#### 5. Background Jobs
- **Scheduled Tasks** with @nestjs/schedule
- **Match Data Synchronization**
- **Notification Delivery**

#### 6. Caching
- **Redis** for session storage
- **Cache Manager** for API responses
- **TTL-based** expiration

### Setup Instructions

#### Install Dependencies

```bash
cd back
npm install
```

#### Configure Environment

Create a `.env` file in the `back` directory:

```env
# Database
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=your_password
DB_DATABASE=football_app

# JWT
JWT_SECRET=your_jwt_secret_key_change_in_production
JWT_REFRESH_SECRET=your_jwt_refresh_secret
JWT_EXPIRATION=15m
JWT_REFRESH_EXPIRATION=7d

# AllSports API
ALLSPORTS_API_KEY=your_allsports_api_key

# OAuth
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret

# Email (SMTP)
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USER=your_email@gmail.com
MAIL_PASSWORD=your_app_password
MAIL_FROM=noreply@footballapp.com

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# App
PORT=3003
NODE_ENV=development
FRONTEND_URL=http://localhost:4200
```

#### Database Setup

```bash
# Create MySQL database
mysql -u root -p
CREATE DATABASE football_app;
EXIT;

# Run migrations (if available)
npm run migration:run
```

#### Available Scripts

```bash
# Development mode with hot-reload
npm run start:dev

# Production build
npm run build

# Production mode
npm run start:prod

# Run tests
npm run test

# E2E tests
npm run test:e2e

# Lint code
npm run lint

# Format code
npm run format
```

### API Endpoints

#### Authentication
- `POST /auth/register` - User registration
- `POST /auth/login` - User login
- `POST /auth/refresh` - Refresh access token
- `POST /auth/logout` - User logout
- `POST /auth/verify-email` - Verify email
- `POST /auth/forgot-password` - Request password reset
- `POST /auth/reset-password` - Reset password
- `GET /auth/google` - Google OAuth
- `GET /auth/github` - GitHub OAuth

#### Users
- `GET /users/profile` - Get current user profile
- `PATCH /users/profile` - Update profile
- `GET /users/stats` - Get user statistics

#### Matches
- `GET /matches` - List matches
- `GET /matches/:id` - Get match details
- `POST /matches/:id/predict` - Submit prediction

#### Standings
- `GET /standings/:leagueId` - Get league standings

#### Teams
- `GET /teams/:id` - Get team details

#### Notifications
- `GET /notifications` - List user notifications
- `PATCH /notifications/:id/read` - Mark as read

## ⚡ Real-Time Service (Rust)

A high-performance WebSocket service built with Rust for ultra-low latency match event streaming.

### Why Rust?

The real-time service is written in Rust for several critical reasons:
- **Performance** - Handle 100k+ concurrent WebSocket connections
- **Memory Safety** - Zero-cost abstractions without garbage collection
- **Concurrency** - Fearless concurrency with the actor model
- **Reliability** - Compile-time guarantees prevent runtime errors

### How It Works

1. **Polling** - Continuously polls AllSportsAPI every 15 seconds
2. **Change Detection** - Compares new data with cached state
3. **Event Generation** - Creates typed events for each change
4. **Broadcasting** - Sends events to all connected WebSocket clients

### Event Types

The service detects and broadcasts the following events:

- `MATCH_STARTED` - New live match detected
- `GOAL_SCORED` - Goal scored with scorer details
- `CARD_ISSUED` - Yellow or red card
- `SUBSTITUTION` - Player substitution
- `SCORE_UPDATE` - Score change
- `MATCH_ENDED` - Match finished

### Setup Instructions

Detailed setup instructions are available in [football-streaming-core/README.md](football-streaming-core/README.md).

#### Quick Start

```bash
cd football-streaming-core

# Install Rust if not already installed
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Configure environment
echo "ALLSPORTS_API_KEY=your_api_key" > .env

# Run the service
cargo run

# Or build and run in release mode (faster)
cargo build --release
./target/release/football-backend
```

### Docker Deployment

```bash
# Using Docker Compose
docker-compose up -d

# Or manually
docker build -t football-core .
docker run -p 8080:8080 -e ALLSPORTS_API_KEY=your_key football-core
```

### WebSocket API Usage

```javascript
// Connect to WebSocket
const ws = new WebSocket('ws://localhost:8080/ws');

// Subscribe to events
ws.onopen = () => {
  ws.send(JSON.stringify({ action: 'subscribe_all' }));
};

// Receive events
ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Event:', data);
  
  // Handle different event types
  switch(data.type) {
    case 'GOAL_SCORED':
      console.log(`Goal! ${data.scorer} scored for ${data.team}`);
      break;
    case 'CARD_ISSUED':
      console.log(`${data.card_type} card issued to ${data.player}`);
      break;
    // ... handle other events
  }
};
```

### Performance Characteristics

- **Latency** - Sub-millisecond event broadcasting
- **Throughput** - 100k+ concurrent connections
- **Memory** - ~20MB baseline, efficient memory usage
- **CPU** - Minimal CPU overhead with async I/O
- **Reliability** - Automatic reconnection and error recovery

## 💻 Development

### Development Workflow

1. **Start all services** in separate terminals:
   ```bash
   # Terminal 1: Rust WebSocket service
   cd football-streaming-core && cargo run
   
   # Terminal 2: NestJS backend
   cd back && npm run start:dev
   
   # Terminal 3: Angular frontend
   cd front && npm start
   ```

2. **Make changes** to your code
3. **Test changes** - All services support hot-reload
4. **Commit changes** using conventional commits

### Code Style

- **Frontend** - Follow Angular style guide
- **Backend** - Use Prettier and ESLint
- **Rust** - Use `cargo fmt` and `cargo clippy`

### Testing

```bash
# Frontend tests
cd front && npm test

# Backend tests
cd back && npm run test

# E2E tests
cd back && npm run test:e2e

# Rust tests
cd football-streaming-core && cargo test
```

### Database Migrations

```bash
cd back

# Generate migration
npm run migration:generate -- -n MigrationName

# Run migrations
npm run migration:run

# Revert migration
npm run migration:revert
```

## 🚀 Deployment

### Production Build

```bash
# Build frontend
cd front
npm run build
# Output: dist/front/browser

# Build backend
cd ../back
npm run build
# Output: dist/

# Build Rust service
cd ../football-streaming-core
cargo build --release
# Output: target/release/football-backend
```

### Docker Deployment

Each component includes Docker support:

```bash
# Build all images
docker-compose build

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Environment Variables for Production

Ensure you set these environment variables in production:

- Set `NODE_ENV=production`
- Use strong `JWT_SECRET` values
- Configure proper database credentials
- Set up SSL/TLS certificates
- Configure CORS appropriately
- Set up proper logging and monitoring

### Recommended Infrastructure

- **Frontend** - Nginx or CDN (Cloudflare, AWS CloudFront)
- **Backend** - PM2, Docker, or Kubernetes
- **Database** - MySQL 8.0 with replication
- **Cache** - Redis cluster
- **WebSocket** - Load balancer with sticky sessions
- **Monitoring** - Prometheus + Grafana

## 📝 License

This project is part of an academic project (GL4 - Software Engineering).

## 🤝 Contributing

This is an academic project. For issues or questions, please contact the project maintainers.

## 📞 Support

For support and questions:
- Check the documentation in each component's README
- Review the code comments and type definitions
- Check the API documentation at `/api` (Swagger)

---

**Built with** ❤️ **by GL4 Students**

**Last Updated:** February 2026
