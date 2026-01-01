# League Standings Feature Implementation Guide

## Overview
This guide explains how to implement a league standings feature that:
- Fetches league standings from AllSportsAPI
- Automatically refreshes standings when a `GOAL_SCORED` WebSocket event is received
- Displays standings in three categories: Total, Home, and Away

**Status:** ✅ Models & Service already implemented | 🔄 Component & WebSocket integration needed

---

## Table of Contents
1. [Current Implementation Status](#current-implementation-status)
2. [Step 1: Create WebSocket Service for Live Events](#step-1-create-websocket-service-for-live-events)
3. [Step 2: Create Standings Updater Service](#step-2-create-standings-updater-service)
4. [Step 3: Create Standings Component](#step-3-create-standings-component)
5. [Step 4: Add Routing](#step-4-add-routing)
6. [Step 5: Update Navigation](#step-5-update-navigation)
7. [Testing](#testing)

---

## Current Implementation Status

### ✅ Already Implemented

#### Data Models (`src/app/models/models.ts`)
The following interfaces are already defined:
- ✅ `StandingEntry` - Individual team standing with all statistics
- ✅ `StandingsResponse` - API response structure with total/home/away standings
- ✅ `GoalScoredEvent` - WebSocket event structure for goal notifications

#### Standings Service (`src/app/services/standings.service.ts`)
The service is fully implemented with:
- ✅ `getStandings(leagueId)` - Fetch standings from API
- ✅ `getCachedStandings(leagueId)` - Get cached observable
- ✅ `refreshStandings(leagueId)` - Refresh specific league
- ✅ Caching mechanism with BehaviorSubject
- ✅ API integration with AllSportsAPI

#### Environment Configuration (`src/environments/environment.development.ts`)
Already configured:
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:3003',
  allSportsApi: {
    baseUrl: 'https://apiv2.allsportsapi.com/football',
    apiKey: '7332a37cfd2c93192d65d6bce5a60e8eaac3a148335af8c64da341727e8d5f3e'
  }
};
```

### 🔄 Still Needed

1. **WebSocket Service** - For listening to live goal events
2. **Standings Updater Service** - To connect goals to standings refresh
3. **Standings Component** - UI to display the standings
4. **Routing** - Add routes for the standings page
5. **Navigation** - Add links to side menu

---

## Step 1: Create WebSocket Service for Live Events

The project already has WebSocket infrastructure for live matches. We'll create a similar service for goal events.

### 1.1 Generate the Service

```bash
ng generate service services/goal-events --skip-tests

### 1.2 Implement Goal Events Service (`src/app/services/goal-events.service.ts`)

Following the pattern used in `live-events.service.ts`, create a dedicated service for goal events:

```typescript
import { Injectable } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { GoalScoredEvent } from '../models/models';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class GoalEventsService {
  private socket: WebSocket | null = null;
  private goalScoredSubject = new Subject<GoalScoredEvent>();
  private reconnectAttempts = 0;
  private maxReconnectAttempts = 5;
  
  constructor() {}

  /**
   * Connect to WebSocket server for goal events
   * Replace 'wss://your-websocket-server.com/goals' with your actual WebSocket URL
   */
  connect(): void {
    if (this.socket?.readyState === WebSocket.OPEN) {
      console.log('Already connected to goal events WebSocket');
      return;
    }

    // TODO: Replace with your actual WebSocket URL
    const wsUrl = 'wss://your-websocket-server.com/goals'; 
    
    this.socket = new WebSocket(wsUrl);

    this.socket.onopen = () => {
      console.log('Connected to goal events WebSocket');
      this.reconnectAttempts = 0;
    };

    this.socket.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        
        // Handle GOAL_SCORED events
        if (data.type === 'GOAL_SCORED') {
          console.log('Goal scored event received:', data);
          this.goalScoredSubject.next(data as GoalScoredEvent);
        }
      } catch (error) {
        console.error('Error parsing WebSocket message:', error);
      }
    };

    this.socket.onerror = (error) => {
      console.error('WebSocket error:', error);
    };

    this.socket.onclose = () => {
      console.log('Goal events WebSocket connection closed');
      
      // Attempt reconnection with exponential backoff
      if (this.reconnectAttempts < this.maxReconnectAttempts) {
        this.reconnectAttempts++;
        const delay = Math.min(1000 * Math.pow(2, this.reconnectAttempts), 30000);
        
        console.log(`Reconnecting in ${delay}ms... (Attempt ${this.reconnectAttempts}/${this.maxReconnectAttempts})`);
        
        setTimeout(() => this.connect(), delay);
      }
    };
  }

  /**
   * Get observable for goal scored events
   */
  onGoalScored(): Observable<GoalScoredEvent> {
    return this.goalScoredSubject.asObservable();
  }

  /**
   * Disconnect from WebSocket
   */
  disconnect(): void {
    if (this.socket) {
      this.socket.close();
      this.socket = null;
      this.reconnectAttempts = 0;
    }
  }
}
```

---

## Step 2: Create Standings Updater Service

This service connects goal events to standings refresh.

### 2.1 Generate the Service

```bash
ng generate service services/standings-updater --skip-tests
```

### 2.2 Implement Standings Updater (`src/app/services/standings-updater.service.ts`)

```typescript
import { Injectable, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { GoalEventsService } from './goal-events.service';
import { StandingsService } from './standings.service';
import { NotificationService } from './notification.service';

@Injectable({
  providedIn: 'root'
})
export class StandingsUpdaterService implements OnDestroy {
  private subscription?: Subscription;
  private activeLeagues = new Set<string>();

  constructor(
    private goalEventsService: GoalEventsService,
    private standingsService: StandingsService,
    private notificationService: NotificationService
  ) {}

  /**
   * Start listening for goal events and auto-refresh standings
   */
  startListening(): void {
    if (this.subscription) {
      return; // Already listening
    }

    // Connect to WebSocket
    this.goalEventsService.connect();

    // Subscribe to goal events
    this.subscription = this.goalEventsService.onGoalScored().subscribe(event => {
      console.log('Goal scored! Refreshing standings for league:', event.league_id);
      
      // Show notification
      this.notificationService.showInfo(
        `${event.scorer} scored for ${event.team === 'home' ? event.home_team : event.away_team}! Score: ${event.score}`,
        'Goal Scored'
      );
      
      // Refresh standings for the affected league
      this.standingsService.refreshStandings(event.league_id);
      this.activeLeagues.add(event.league_id);
    });
  }

  /**
   * Stop listening for goal events
   */
  stopListening(): void {
    if (this.subscription) {
      this.subscription.unsubscribe();
      this.subscription = undefined;
    }
    this.goalEventsService.disconnect();
  }

  /**
   * Get list of leagues that have had updates
   */
  getActiveLeagues(): string[] {
    return Array.from(this.activeLeagues);
  }

  ngOnDestroy(): void {
    this.stopListening();
  }
}
```

---

## Step 3: Create Standings Component

### 3.1 Generate Component

```bash
ng generate component components/league-standings --skip-tests
```

### 3.2 Component TypeScript (`src/app/components/league-standings/league-standings.component.ts`)

```typescript
import { Component, OnInit, OnDestroy, Input, inject } from '@angular/core';
import { CommonModule, DatePipe } from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import { Subscription } from 'rxjs';
import { StandingsService } from '../../services/standings.service';
import { StandingsUpdaterService } from '../../services/standings-updater.service';
import { StandingEntry, StandingsResponse } from '../../models/models';
import { LoadingComponent } from '../loading/loading.component';

@Component({
  selector: 'app-league-standings',
  standalone: true,
  imports: [CommonModule, LoadingComponent, DatePipe],
  templateUrl: './league-standings.component.html',
  styleUrls: ['./league-standings.component.css']
})
export class LeagueStandingsComponent implements OnInit, OnDestroy {
  @Input() leagueId?: string;
  
  standings: StandingsResponse | null = null;
  selectedView: 'total' | 'home' | 'away' = 'total';
  loading = true;
  error: string | null = null;
  
  private subscription?: Subscription;
  private route = inject(ActivatedRoute);
  private standingsService = inject(StandingsService);
  private standingsUpdater = inject(StandingsUpdaterService);

  ngOnInit(): void {
    // Get league ID from route or input
    const routeLeagueId = this.route.snapshot.paramMap.get('leagueId');
    const leagueId = this.leagueId || routeLeagueId || '207'; // Default to Serie A (207)

    // Start listening for goal events
    this.standingsUpdater.startListening();

    // Subscribe to standings updates
    this.subscription = this.standingsService.getCachedStandings(leagueId).subscribe({
      next: (data) => {
        if (data) {
          this.standings = data;
          this.loading = false;
        }
      },
      error: (err) => {
        this.error = 'Failed to load standings. Please try again later.';
        this.loading = false;
        console.error('Standings error:', err);
      }
    });
  }

  ngOnDestroy(): void {
    if (this.subscription) {
      this.subscription.unsubscribe();
    }
    this.standingsUpdater.stopListening();
  }

  /**
   * Get current standings based on selected view
   */
  get currentStandings(): StandingEntry[] {
    if (!this.standings) return [];
    
    switch (this.selectedView) {
      case 'home':
        return this.standings.result.home;
      case 'away':
        return this.standings.result.away;
      default:
        return this.standings.result.total;
    }
  }

  /**
   * Switch between total, home, and away views
   */
  setView(view: 'total' | 'home' | 'away'): void {
    this.selectedView = view;
  }

  /**
   * Get CSS class for standing place type
   */
  getPlaceTypeClass(placeType: string | null): string {
    if (!placeType) return '';
    
    if (placeType.includes('Champions League')) return 'champions-league';
    if (placeType.includes('Europa League')) return 'europa-league';
    if (placeType.includes('Relegation')) return 'relegation';
    
    return '';
  }

  /**
   * Check if goal difference is positive
   */
  isPositive(value: string): boolean {
    return parseInt(value) > 0;
  }

  /**
   * Check if goal difference is negative
   */
  isNegative(value: string): boolean {
    return parseInt(value) < 0;
  }
}
```

### 3.3 Component HTML (`src/app/components/league-standings/league-standings.component.html`)

```html
<div class="standings-container">
  <div class="standings-header">
    <h2>League Standings</h2>
    
    <!-- View Toggle -->
    <div class="view-toggle">
      <button 
        [class.active]="selectedView === 'total'"
        (click)="setView('total')">
        Overall
      </button>
      <button 
        [class.active]="selectedView === 'home'"
        (click)="setView('home')">
        Home
      </button>
      <button 
        [class.active]="selectedView === 'away'"
        (click)="setView('away')">
        Away
      </button>
    </div>
  </div>

  <!-- Loading State -->
  <div *ngIf="loading" class="loading-state">
    <app-loading></app-loading>
  </div>

  <!-- Error State -->
  <div *ngIf="error" class="error-state">
    <p>{{ error }}</p>
  </div>

  <!-- Standings Table -->
  <div *ngIf="!loading && !error && standings" class="standings-table">
    <table>
      <thead>
        <tr>
          <th class="position">#</th>
          <th class="team">Team</th>
          <th>P</th>
          <th>W</th>
          <th>D</th>
          <th>L</th>
          <th>GF</th>
          <th>GA</th>
          <th>GD</th>
          <th class="points">Pts</th>
        </tr>
      </thead>
      <tbody>
        <tr *ngFor="let standing of currentStandings" 
            [class]="getPlaceTypeClass(standing.standing_place_type)">
          <td class="position">{{ standing.standing_place }}</td>
          <td class="team">
            <span class="team-name">{{ standing.standing_team }}</span>
            <span *ngIf="standing.standing_place_type" 
                  class="place-type-badge">
              {{ standing.standing_place_type }}
            </span>
          </td>
          <td>{{ standing.standing_P }}</td>
          <td>{{ standing.standing_W }}</td>
          <td>{{ standing.standing_D }}</td>
          <td>{{ standing.standing_L }}</td>
          <td>{{ standing.standing_F }}</td>
          <td>{{ standing.standing_A }}</td>
          <td [class.positive]="isPositive(standing.standing_GD)" 
              [class.negative]="isNegative(standing.standing_GD)">
            {{ standing.standing_GD }}
          </td>
          <td class="points">{{ standing.standing_PTS }}</td>
        </tr>
      </tbody>
    </table>

    <!-- Last Updated -->
    <div *ngIf="currentStandings[0]?.standing_updated" class="last-updated">
      Last updated: {{ currentStandings[0].standing_updated | date:'short' }}
    </div>
  </div>
</div>
```

```html
<div class="standings-container">
  <div class="standings-header">
    <h2>League Standings</h2>
    
    <!-- View Toggle -->
    <div class="view-toggle">
      <button 
        [class.active]="selectedView === 'total'"
        (click)="setView('total')">
        Overall
      </button>
      <button 
        [class.active]="selectedView === 'home'"
        (click)="setView('home')">
        Home
      </button>
      <button 
        [class.active]="selectedView === 'away'"
        (click)="setView('away')">
        Away
      </button>
    </div>
  </div>

  <!-- Loading State -->
  <div *ngIf="loading" class="loading-state">
    <app-loading></app-loading>
  </div>

  <!-- Error State -->
  <div *ngIf="error" class="error-state">
    <p>{{ error }}</p>
  </div>

  <!-- Standings Table -->
  <div *ngIf="!loading && !error && standings" class="standings-table">
    <table>
      <thead>
        <tr>
          <th class="position">#</th>
          <th class="team">Team</th>
          <th>P</th>
          <th>W</th>
          <th>D</th>
          <th>L</th>
          <th>GF</th>
          <th>GA</th>
          <th>GD</th>
          <th class="points">Pts</th>
        </tr>
      </thead>
      <tbody>
        <tr *ngFor="let standing of currentStandings" 
            [class]="getPlaceTypeClass(standing.standing_place_type)">
          <td class="position">{{ standing.standing_place }}</td>
          <td class="team">
            <span class="team-name">{{ standing.standing_team }}</span>
            <span *ngIf="standing.standing_place_type" 
                  class="place-type-badge">
              {{ standing.standing_place_type }}
            </span>
          </td>
          <td>{{ standing.standing_P }}</td>
          <td>{{ standing.standing_W }}</td>
          <td>{{ standing.standing_D }}</td>
          <td>{{ standing.standing_L }}</td>
          <td>{{ standing.standing_F }}</td>
          <td>{{ standing.standing_A }}</td>
          <td [class.positive]="standing.standing_GD > '0'" 
              [class.negative]="standing.standing_GD < '0'">
            {{ standing.standing_GD }}
          </td>
          <td class="points">{{ standing.standing_PTS }}</td>
        </tr>
      </tbody>
    </table>

    <!-- Last Updated -->
    <div *ngIf="currentStandings[0]?.standing_updated" class="last-updated">
      Last updated: {{ currentStandings[0].standing_updated | date:'short' }}
    </div>
  </div>
</div>
```

### 3.4 Component CSS (`src/app/components/league-standings/league-standings.component.css`)

```css
.standings-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.standings-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 15px;
}

.standings-header h2 {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
}

/* View Toggle */
.view-toggle {
  display: flex;
  gap: 5px;
  background: #f0f0f0;
  border-radius: 8px;
  padding: 4px;
}

.view-toggle button {
  padding: 8px 16px;
  border: none;
  background: transparent;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.3s ease;
}

.view-toggle button.active {
  background: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.view-toggle button:hover:not(.active) {
  background: rgba(255, 255, 255, 0.5);
}

/* Loading and Error States */
.loading-state,
.error-state {
  text-align: center;
  padding: 40px;
}

.error-state {
  color: #d32f2f;
}

/* Standings Table */
.standings-table {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

table {
  width: 100%;
  border-collapse: collapse;
}

thead {
  background: #f5f5f5;
}

thead th {
  padding: 12px 8px;
  text-align: left;
  font-weight: 600;
  font-size: 14px;
  color: #666;
  text-transform: uppercase;
}

tbody tr {
  border-bottom: 1px solid #f0f0f0;
  transition: background-color 0.2s ease;
}

tbody tr:hover {
  background-color: #f9f9f9;
}

tbody td {
  padding: 12px 8px;
  font-size: 14px;
}

/* Column Specific Styles */
.position {
  width: 50px;
  text-align: center;
  font-weight: 600;
}

.team {
  min-width: 200px;
}

.team-name {
  font-weight: 500;
}

.points {
  font-weight: 700;
  color: #1976d2;
}

/* Place Type Indicators */
.champions-league {
  border-left: 4px solid #0066cc;
}

.europa-league {
  border-left: 4px solid #ff9800;
}

.relegation {
  border-left: 4px solid #d32f2f;
}

.place-type-badge {
  display: block;
  font-size: 11px;
  color: #666;
  margin-top: 2px;
}

/* Goal Difference Colors */
.positive {
  color: #4caf50;
  font-weight: 600;
}

.negative {
  color: #d32f2f;
  font-weight: 600;
}

/* Last Updated */
.last-updated {
  padding: 12px;
  text-align: center;
  font-size: 12px;
  color: #999;
  background: #f9f9f9;
}

/* Responsive Design */
@media (max-width: 768px) {
  .standings-header {
    flex-direction: column;
    align-items: flex-start;
  }

  table {
    font-size: 12px;
  }

  thead th,
  tbody td {
    padding: 8px 4px;
  }

  .team {
    min-width: 150px;
  }

  .place-type-badge {
    display: none;
  }
}
```

---

## Step 4: Add Routing

Update `src/app/app.routes.ts` to include the standings route:

```typescript
{
  path: 'standings/:leagueId',
  loadComponent: () =>
    import('./components/league-standings/league-standings.component').then(
      (c) => c.LeagueStandingsComponent
    ),
},
{
  path: 'standings',
  loadComponent: () =>
    import('./components/league-standings/league-standings.component').then(
      (c) => c.LeagueStandingsComponent
    ),
},
```

**Full example placement** (add before the wildcard `**` route):

```typescript
{
  path: 'team/:id',
  loadComponent: () =>
    import('./components/team-detail-page/team-detail-page.component').then(
      (c) => c.TeamDetailPageComponent
    ),
},
{
  path: 'standings/:leagueId',
  canActivate: [tokenValidationGuard], // Optional: if you want to protect this route
  loadComponent: () =>
    import('./components/league-standings/league-standings.component').then(
      (c) => c.LeagueStandingsComponent
    ),
},
{
  path: 'standings',
  canActivate: [tokenValidationGuard], // Optional
  loadComponent: () =>
    import('./components/league-standings/league-standings.component').then(
      (c) => c.LeagueStandingsComponent
    ),
},
// Wildcard route for 404 - this should be the last route
{
  path: '**',
  loadComponent: () =>
    import('./components/error-page/error-page.component').then(
      (c) => c.ErrorPageComponent
    ),
  data: { errorCode: 404 },
},
```

---

## Step 5: Update Navigation

Add a standings link to your side menu component.

### 5.1 Update Side Menu HTML

Find your side menu component (likely `src/app/components/side-menu/`) and add:

```html
<a routerLink="/standings/207" routerLinkActive="active" class="menu-item">
  <span class="icon">📊</span>
  <span class="label">Standings</span>
</a>
```

**Common League IDs:**
- Premier League: `152`
- La Liga: `302`
- Serie A: `207`
- Bundesliga: `175`
- Ligue 1: `168`

---

## Step 6: Initialize Goal Events in App Component

Update your main app component to start listening for goal events.

### 6.1 Update `src/app/app.component.ts`

```typescript
import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { StandingsUpdaterService } from './services/standings-updater.service';

@Component({
  selector: 'app-root',
  // ... existing config
})
export class AppComponent implements OnInit, OnDestroy {
  private standingsUpdater = inject(StandingsUpdaterService);

  ngOnInit(): void {
    // Start listening for goal events globally
    this.standingsUpdater.startListening();
  }

  ngOnDestroy(): void {
    this.standingsUpdater.stopListening();
  }
}
```

**Note:** This will start listening for goal events globally. If you only want to listen when on the standings page, skip this step and the component will handle it.

---

## Testing

### Manual Testing Steps

1. **Start the Development Server**
   ```bash
   cd front
   npm start
   ```
   Or:
   ```bash
   ng serve
   ```

2. **Test Basic Standings Display**
   - Navigate to `http://localhost:4200/standings/207`
   - Verify standings load correctly
   - Check that all columns display properly

3. **Test View Switching**
   - Click on "Overall", "Home", and "Away" tabs
   - Verify that standings update correctly for each view
   - Check that the active tab is highlighted

4. **Test WebSocket Integration** (requires WebSocket server)
   - Update `goal-events.service.ts` with your actual WebSocket URL
   - Trigger a GOAL_SCORED event from your server:
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
     "league_id": "207",
     "timestamp": "2024-01-15T20:23:00Z"
   }
   ```
   - Verify notification appears
   - Verify standings refresh automatically

5. **Test Error Handling**
   - Use an invalid league ID (e.g., `/standings/99999`)
   - Verify error message displays correctly

6. **Test Responsive Design**
   - Resize browser window
   - Check mobile view
   - Verify table is scrollable on small screens

### Browser Console Testing

Open browser DevTools and run:

```javascript
// Check if service is loaded
const standingsService = document.querySelector('app-league-standings')?.__ngContext__?.[8]?.standingsService;
console.log('Service:', standingsService);

// Check cache
console.log('Cache:', standingsService?.standingsCache);
```

---

## Configuration

### WebSocket URL Configuration

Update `src/app/services/goal-events.service.ts`:

```typescript
// Replace this line:
const wsUrl = 'wss://your-websocket-server.com/goals';

// With your actual WebSocket URL, for example:
const wsUrl = `${environment.apiUrl.replace('http', 'ws')}/live/goals`;
```

### API Key Configuration

The API key is already configured in `environment.development.ts`. If you need to change it:

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:3003',
  allSportsApi: {
    baseUrl: 'https://apiv2.allsportsapi.com/football',
    apiKey: 'YOUR_NEW_API_KEY_HERE'  // Update this
  }
};
```

Then update `standings.service.ts` to use the environment variable:

```typescript
import { environment } from '../../environments/environment';

// Replace:
private readonly API_KEY = '8f01fc8fbf36f8f0cd23b99599f781619766b438e180811708f8e0bb8f7f46c2';

// With:
private readonly API_KEY = environment.allSportsApi.apiKey;
```

---

## Troubleshooting

### Common Issues

#### 1. CORS Errors with AllSportsAPI

If you encounter CORS errors when calling the API:

**Solution A: Use Angular Proxy (Recommended for Development)**

Create `proxy.conf.json` in the `front/` directory:

```json
{
  "/api/allsports": {
    "target": "https://apiv2.allsportsapi.com",
    "secure": true,
    "changeOrigin": true,
    "pathRewrite": {
      "^/api/allsports": "/football"
    }
  }
}
```

Update `angular.json`:

```json
"serve": {
  "builder": "@angular-devkit/build-angular:dev-server",
  "options": {
    "proxyConfig": "proxy.conf.json"
  }
}
```

Update `standings.service.ts`:

```typescript
// Change:
private readonly API_BASE_URL = 'https://apiv2.allsportsapi.com/football/';

// To:
private readonly API_BASE_URL = '/api/allsports/';
```

**Solution B: Backend Proxy (Recommended for Production)**

Route API calls through your backend at `http://localhost:3003`:

```typescript
// In standings.service.ts, change:
private readonly API_BASE_URL = `${environment.apiUrl}/api/standings`;

// Then create an endpoint in your backend that proxies to AllSportsAPI
```

#### 2. WebSocket Not Connecting

**Check WebSocket URL:**
```typescript
// Make sure the URL is correct in goal-events.service.ts
const wsUrl = 'wss://your-actual-websocket-url.com/goals';
```

**Test WebSocket in Browser Console:**
```javascript
const ws = new WebSocket('wss://your-websocket-url.com');
ws.onopen = () => console.log('Connected');
ws.onerror = (e) => console.error('Error:', e);
```

**Common Issues:**
- Wrong protocol (use `wss://` for HTTPS, `ws://` for HTTP)
- Firewall blocking connections
- WebSocket server not running
- CORS issues (WebSockets don't use CORS, but check server configuration)

#### 3. Standings Not Updating After Goals

**Debug Steps:**

1. Check if WebSocket is connected:
   ```typescript
   // Add in goal-events.service.ts
   this.socket.onopen = () => {
     console.log('✅ WebSocket connected successfully');
   };
   ```

2. Check if events are received:
   ```typescript
   this.socket.onmessage = (event) => {
     console.log('📨 Received:', event.data);
     // ... rest of code
   };
   ```

3. Check if standings service is called:
   ```typescript
   // Add in standings-updater.service.ts
   refreshStandings(leagueId: string): void {
     console.log('🔄 Refreshing standings for league:', leagueId);
     this.standingsService.refreshStandings(leagueId);
   }
   ```

#### 4. TypeScript Errors

If you get "Cannot find module" errors:

```bash
# Clear node_modules and reinstall
rm -rf node_modules
npm install

# Or with pnpm (which you're using)
pnpm install
```

#### 5. Component Not Loading

**Check routing:**
- Ensure route is defined before wildcard (`**`) route
- Check that component is imported correctly
- Verify `loadComponent` syntax for standalone components

**Check browser console for errors:**
```
F12 → Console tab
```

---

## Performance Optimization

### 1. Lazy Load Standings Component

Already implemented via `loadComponent()` in routes.

### 2. Cache Management

Clear old cache periodically:

```typescript
// In standings.service.ts
private cacheTimeout = 5 * 60 * 1000; // 5 minutes

getStandings(leagueId: string): Observable<StandingsResponse> {
  // Add timestamp to cache
  const cached = this.standingsCache.get(leagueId);
  if (cached && Date.now() - cached.timestamp < this.cacheTimeout) {
    return cached.data;
  }
  
  // Fetch new data...
}
```

### 3. Optimize WebSocket Reconnection

Already implemented with exponential backoff in `goal-events.service.ts`.

### 4. Use Virtual Scrolling for Large Tables

If standings tables become very large:

```bash
npm install @angular/cdk
```

```typescript
import { ScrollingModule } from '@angular/cdk/scrolling';

// In component:
imports: [CommonModule, ScrollingModule]
```

```html
<cdk-virtual-scroll-viewport itemSize="50" class="standings-viewport">
  <tr *cdkVirtualFor="let standing of currentStandings">
    <!-- table content -->
  </tr>
</cdk-virtual-scroll-viewport>
```

---

## Next Steps & Enhancements

### 1. League Selector Dropdown

Add a dropdown to switch between leagues:

```typescript
leagues = [
  { id: '152', name: 'Premier League' },
  { id: '302', name: 'La Liga' },
  { id: '207', name: 'Serie A' },
  { id: '175', name: 'Bundesliga' },
  { id: '168', name: 'Ligue 1' }
];

selectLeague(leagueId: string): void {
  this.router.navigate(['/standings', leagueId]);
}
```

### 2. Season Selector

Allow viewing historical standings:

```typescript
getStandingsForSeason(leagueId: string, season: string): Observable<StandingsResponse> {
  const params = new HttpParams()
    .set('met', 'Standings')
    .set('APIkey', this.API_KEY)
    .set('leagueId', leagueId)
    .set('season', season); // e.g., '2022/2023'
  
  return this.http.get<StandingsResponse>(this.API_BASE_URL, { params });
}
```

### 3. Team Links

Make team names clickable:

```html
<a [routerLink]="['/team', standing.team_key]" class="team-link">
  {{ standing.standing_team }}
</a>
```

### 4. Live Update Indicator

Add visual feedback when standings update:

```typescript
standingsUpdated = false;

refreshStandings(leagueId: string): void {
  this.standingsUpdated = true;
  this.standingsService.refreshStandings(leagueId);
  setTimeout(() => this.standingsUpdated = false, 3000);
}
```

```html
<div *ngIf="standingsUpdated" class="update-badge">
  ✨ Updated
</div>
```

### 5. Filter by Position Type

Add filters for Champions League, Europa League, Relegation zones:

```typescript
filterByType(type: string): StandingEntry[] {
  return this.currentStandings.filter(
    s => s.standing_place_type?.includes(type)
  );
}
```

### 6. Export to CSV/PDF

Add export functionality:

```typescript
exportToCSV(): void {
  const csv = this.currentStandings.map(s => 
    `${s.standing_place},${s.standing_team},${s.standing_PTS}`
  ).join('\n');
  
  const blob = new Blob([csv], { type: 'text/csv' });
  const url = window.URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'standings.csv';
  a.click();
}
```

### 7. Compare Teams

Side-by-side comparison:

```typescript
compareTeams(team1Key: string, team2Key: string): void {
  const team1 = this.currentStandings.find(s => s.team_key === team1Key);
  const team2 = this.currentStandings.find(s => s.team_key === team2Key);
  // Show comparison modal
}
```

### 8. Mobile App Integration

If building a mobile version with Ionic:

```typescript
import { App } from '@capacitor/app';
import { PushNotifications } from '@capacitor/push-notifications';

// Send push notification on goal
onGoalScored(event: GoalScoredEvent): void {
  PushNotifications.createChannel({
    id: 'goals',
    name: 'Goal Notifications',
    importance: 5
  });
}
```

---

## API Reference

### AllSportsAPI Endpoints Used

#### Get Standings
```
GET https://apiv2.allsportsapi.com/football/
?met=Standings
&APIkey=YOUR_API_KEY
&leagueId=LEAGUE_ID
```

**Response Structure:**
```json
{
  "success": 1,
  "result": {
    "total": [StandingEntry[]],
    "home": [StandingEntry[]],
    "away": [StandingEntry[]]
  }
}
```

### WebSocket Events

#### GOAL_SCORED Event
```json
{
  "type": "GOAL_SCORED",
  "match_id": "string",
  "minute": "string",
  "scorer": "string",
  "team": "home" | "away",
  "score": "string",
  "home_team": "string",
  "away_team": "string",
  "league_id": "string",
  "timestamp": "ISO 8601 string"
}
```

---

## Additional Resources

- **AllSportsAPI Documentation:** https://allsportsapi.com/documentation
- **Angular Official Docs:** https://angular.dev
- **RxJS Documentation:** https://rxjs.dev
- **WebSocket API:** https://developer.mozilla.org/en-US/docs/Web/API/WebSocket
- **Angular Material (for advanced UI):** https://material.angular.io
- **PrimeNG (UI Library):** https://primeng.org (already used in your project)

---

## Project Structure After Implementation

```
front/src/app/
├── components/
│   ├── league-standings/
│   │   ├── league-standings.component.ts
│   │   ├── league-standings.component.html
│   │   └── league-standings.component.css
│   └── ... (other components)
├── services/
│   ├── standings.service.ts ✅ (already exists)
│   ├── goal-events.service.ts 🆕
│   └── standings-updater.service.ts 🆕
├── models/
│   └── models.ts ✅ (already has StandingEntry, StandingsResponse, GoalScoredEvent)
└── app.routes.ts (updated)
```

---

## Summary

This implementation provides a complete league standings feature with:

✅ **Real-time Updates** - Automatic refresh on goal events via WebSocket  
✅ **Three View Modes** - Total, Home, and Away statistics  
✅ **Caching System** - Efficient data management with BehaviorSubject  
✅ **Error Handling** - Graceful degradation and user feedback  
✅ **Responsive Design** - Mobile-friendly table layout  
✅ **Type Safety** - Full TypeScript interfaces  
✅ **Modular Architecture** - Easy to extend and maintain  
✅ **Lazy Loading** - Performance-optimized routing  
✅ **Notification Integration** - Uses existing PrimeNG toast system  

The feature integrates seamlessly with your existing Angular application structure and follows the patterns already established in your codebase.
