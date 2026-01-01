# League Standings Feature Implementation Guide

## Overview
This guide explains how to implement a league standings feature that:
- Fetches league standings from AllSportsAPI
- Automatically refreshes standings when a `GOAL_SCORED` WebSocket event is received
- Displays standings in three categories: Total, Home, and Away

---

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Step 1: Update Data Models](#step-1-update-data-models)
3. [Step 2: Create Standings Service](#step-2-create-standings-service)
4. [Step 3: Integrate WebSocket Service](#step-3-integrate-websocket-service)
5. [Step 4: Create Standings Component](#step-4-create-standings-component)
6. [Step 5: Add Routing](#step-5-add-routing)
7. [Step 6: Update Navigation](#step-6-update-navigation)
8. [Testing](#testing)

---

## Prerequisites

Before starting, ensure you have:
- Angular CLI installed
- Access to AllSportsAPI with API key: `8f01fc8fbf36f8f0cd23b99599f781619766b438e180811708f8e0bb8f7f46c2`
- WebSocket service configured for real-time events
- HttpClient module configured in your app

---

## Step 1: Update Data Models

### 1.1 Add Standing Interfaces to `src/app/models/models.ts`

```typescript
export interface StandingEntry {
  standing_place: string;
  standing_place_type: string | null;
  standing_team: string;
  standing_P: string;  // Played
  standing_W: string;  // Won
  standing_D: string;  // Draw
  standing_L: string;  // Lost
  standing_F: string;  // Goals For
  standing_A: string;  // Goals Against
  standing_GD: string; // Goal Difference
  standing_PTS: string; // Points
  team_key: string;
  league_key: string;
  league_season: string;
  league_round: string;
  standing_updated?: string;
  fk_stage_key?: string;
  stage_name?: string;
}

export interface StandingsResponse {
  success: number;
  result: {
    total: StandingEntry[];
    home: StandingEntry[];
    away: StandingEntry[];
  };
}

export interface GoalScoredEvent {
  type: 'GOAL_SCORED';
  match_id: string;
  minute: string;
  scorer: string;
  team: 'home' | 'away';
  score: string;
  home_team: string;
  away_team: string;
  league_id: string;
  timestamp: string;
}
```

---

## Step 2: Create Standings Service

### 2.1 Generate the Service

```bash
ng generate service services/standings
```

### 2.2 Implement Standings Service (`src/app/services/standings.service.ts`)

```typescript
import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';
import { StandingsResponse } from '../models/models';

@Injectable({
  providedIn: 'root'
})
export class StandingsService {
  private readonly API_BASE_URL = 'https://apiv2.allsportsapi.com/football/';
  private readonly API_KEY = '8f01fc8fbf36f8f0cd23b99599f781619766b438e180811708f8e0bb8f7f46c2';
  
  // Cache for standings data
  private standingsCache = new Map<string, BehaviorSubject<StandingsResponse | null>>();
  
  constructor(private http: HttpClient) {}

  /**
   * Fetch standings for a specific league
   * @param leagueId - The league ID to fetch standings for
   * @returns Observable of StandingsResponse
   */
  getStandings(leagueId: string): Observable<StandingsResponse> {
    const params = new HttpParams()
      .set('met', 'Standings')
      .set('APIkey', this.API_KEY)
      .set('leagueId', leagueId);

    return this.http.get<StandingsResponse>(this.API_BASE_URL, { params }).pipe(
      tap(response => {
        // Update cache
        this.updateCache(leagueId, response);
      }),
      catchError(error => {
        console.error('Error fetching standings:', error);
        throw error;
      })
    );
  }

  /**
   * Get cached standings for a league
   * @param leagueId - The league ID
   * @returns BehaviorSubject of cached standings
   */
  getCachedStandings(leagueId: string): Observable<StandingsResponse | null> {
    if (!this.standingsCache.has(leagueId)) {
      this.standingsCache.set(leagueId, new BehaviorSubject<StandingsResponse | null>(null));
      // Fetch initial data
      this.getStandings(leagueId).subscribe();
    }
    return this.standingsCache.get(leagueId)!.asObservable();
  }

  /**
   * Refresh standings for a specific league
   * @param leagueId - The league ID to refresh
   */
  refreshStandings(leagueId: string): void {
    this.getStandings(leagueId).subscribe();
  }

  /**
   * Update cache with new standings data
   */
  private updateCache(leagueId: string, data: StandingsResponse): void {
    if (!this.standingsCache.has(leagueId)) {
      this.standingsCache.set(leagueId, new BehaviorSubject<StandingsResponse | null>(data));
    } else {
      this.standingsCache.get(leagueId)!.next(data);
    }
  }

  /**
   * Clear cache for a specific league or all leagues
   */
  clearCache(leagueId?: string): void {
    if (leagueId) {
      this.standingsCache.delete(leagueId);
    } else {
      this.standingsCache.clear();
    }
  }
}
```

---

## Step 3: Integrate WebSocket Service

### 3.1 Check for Existing WebSocket Service

Check if you have a WebSocket service in `src/app/services/`. If not, create one:

```bash
ng generate service services/websocket
```

### 3.2 WebSocket Service Implementation

```typescript
import { Injectable } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { GoalScoredEvent } from '../models/models';

@Injectable({
  providedIn: 'root'
})
export class WebsocketService {
  private socket: WebSocket | null = null;
  private goalScoredSubject = new Subject<GoalScoredEvent>();
  
  constructor() {}

  /**
   * Connect to WebSocket server
   */
  connect(url: string): void {
    this.socket = new WebSocket(url);

    this.socket.onmessage = (event) => {
      const data = JSON.parse(event.data);
      
      // Handle GOAL_SCORED events
      if (data.type === 'GOAL_SCORED') {
        this.goalScoredSubject.next(data as GoalScoredEvent);
      }
    };

    this.socket.onerror = (error) => {
      console.error('WebSocket error:', error);
    };

    this.socket.onclose = () => {
      console.log('WebSocket connection closed');
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
    }
  }
}
```

### 3.3 Create Standings Update Service

This service will listen to WebSocket events and trigger standings refresh:

```bash
ng generate service services/standings-updater
```

```typescript
import { Injectable, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { WebsocketService } from './websocket.service';
import { StandingsService } from './standings.service';

@Injectable({
  providedIn: 'root'
})
export class StandingsUpdaterService implements OnDestroy {
  private subscription?: Subscription;

  constructor(
    private websocketService: WebsocketService,
    private standingsService: StandingsService
  ) {}

  /**
   * Start listening for goal events and auto-refresh standings
   */
  startListening(): void {
    this.subscription = this.websocketService.onGoalScored().subscribe(event => {
      console.log('Goal scored! Refreshing standings for league:', event.league_id);
      
      // Refresh standings for the affected league
      this.standingsService.refreshStandings(event.league_id);
    });
  }

  /**
   * Stop listening for goal events
   */
  stopListening(): void {
    if (this.subscription) {
      this.subscription.unsubscribe();
    }
  }

  ngOnDestroy(): void {
    this.stopListening();
  }
}
```

---

## Step 4: Create Standings Component

### 4.1 Generate Component

```bash
ng generate component components/league-standings
```

### 4.2 Component TypeScript (`league-standings.component.ts`)

```typescript
import { Component, OnInit, OnDestroy, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import { Subscription } from 'rxjs';
import { StandingsService } from '../../services/standings.service';
import { StandingsUpdaterService } from '../../services/standings-updater.service';
import { StandingEntry, StandingsResponse } from '../../models/models';

@Component({
  selector: 'app-league-standings',
  standalone: true,
  imports: [CommonModule],
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

  constructor(
    private route: ActivatedRoute,
    private standingsService: StandingsService,
    private standingsUpdater: StandingsUpdaterService
  ) {}

  ngOnInit(): void {
    // Get league ID from route or input
    const routeLeagueId = this.route.snapshot.paramMap.get('leagueId');
    const leagueId = this.leagueId || routeLeagueId || '1'; // Default to league 1

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
}
```

### 4.3 Component HTML (`league-standings.component.html`)

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

### 4.4 Component CSS (`league-standings.component.css`)

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

## Step 5: Add Routing

### 5.1 Update `src/app/app.routes.ts`

```typescript
import { Routes } from '@angular/router';
import { LeagueStandingsComponent } from './components/league-standings/league-standings.component';

export const routes: Routes = [
  // ... existing routes
  {
    path: 'standings/:leagueId',
    component: LeagueStandingsComponent
  },
  {
    path: 'standings',
    component: LeagueStandingsComponent
  },
  // ... other routes
];
```

---

## Step 6: Update Navigation

### 6.1 Add Standings Link to Side Menu

Update your side menu component to include a link to standings:

```html
<a routerLink="/standings/1" routerLinkActive="active">
  <span class="icon">📊</span>
  <span>Standings</span>
</a>
```

---

## Step 7: Initialize WebSocket in App Component

### 7.1 Update `src/app/app.component.ts`

```typescript
import { Component, OnInit, OnDestroy } from '@angular/core';
import { WebsocketService } from './services/websocket.service';
import { environment } from '../environments/environment';

@Component({
  selector: 'app-root',
  // ...
})
export class AppComponent implements OnInit, OnDestroy {
  
  constructor(private websocketService: WebsocketService) {}

  ngOnInit(): void {
    // Connect to WebSocket server
    // Replace with your actual WebSocket URL
    const wsUrl = environment.websocketUrl || 'ws://your-websocket-server.com';
    this.websocketService.connect(wsUrl);
  }

  ngOnDestroy(): void {
    this.websocketService.disconnect();
  }
}
```

### 7.2 Update `src/environments/environment.ts`

```typescript
export const environment = {
  production: false,
  websocketUrl: 'ws://localhost:8080' // Replace with your WebSocket URL
};
```

---

## Testing

### Manual Testing Steps

1. **Test Basic Standings Display**
   ```bash
   ng serve
   ```
   Navigate to `http://localhost:4200/standings/1` to view standings for league ID 1.

2. **Test View Switching**
   - Click on "Overall", "Home", and "Away" tabs
   - Verify that standings update correctly

3. **Test WebSocket Integration**
   - Simulate a GOAL_SCORED event from your WebSocket server:
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
     "league_id": "1",
     "timestamp": "2024-01-15T20:23:00Z"
   }
   ```
   - Verify that standings refresh automatically

4. **Test Error Handling**
   - Disconnect from the internet
   - Verify error message displays correctly
   - Reconnect and verify recovery

### Unit Testing

Generate test file and add tests:

```typescript
// league-standings.component.spec.ts
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { LeagueStandingsComponent } from './league-standings.component';
import { StandingsService } from '../../services/standings.service';
import { of } from 'rxjs';

describe('LeagueStandingsComponent', () => {
  let component: LeagueStandingsComponent;
  let fixture: ComponentFixture<LeagueStandingsComponent>;
  let standingsService: jasmine.SpyObj<StandingsService>;

  beforeEach(async () => {
    const standingsServiceSpy = jasmine.createSpyObj('StandingsService', [
      'getCachedStandings'
    ]);

    await TestBed.configureTestingModule({
      imports: [LeagueStandingsComponent],
      providers: [
        { provide: StandingsService, useValue: standingsServiceSpy }
      ]
    }).compileComponents();

    standingsService = TestBed.inject(StandingsService) as jasmine.SpyObj<StandingsService>;
    fixture = TestBed.createComponent(LeagueStandingsComponent);
    component = fixture.componentInstance;
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should load standings on init', () => {
    const mockStandings = { success: 1, result: { total: [], home: [], away: [] } };
    standingsService.getCachedStandings.and.returnValue(of(mockStandings));
    
    component.ngOnInit();
    
    expect(standingsService.getCachedStandings).toHaveBeenCalled();
    expect(component.standings).toEqual(mockStandings);
  });
});
```

---

## Environment Variables

Create or update your environment files with the following:

```typescript
// environment.ts
export const environment = {
  production: false,
  websocketUrl: 'ws://localhost:8080',
  allSportsApiUrl: 'https://apiv2.allsportsapi.com/football/',
  allSportsApiKey: '8f01fc8fbf36f8f0cd23b99599f781619766b438e180811708f8e0bb8f7f46c2'
};

// environment.production.ts
export const environment = {
  production: true,
  websocketUrl: 'wss://your-production-websocket.com',
  allSportsApiUrl: 'https://apiv2.allsportsapi.com/football/',
  allSportsApiKey: '8f01fc8fbf36f8f0cd23b99599f781619766b438e180811708f8e0bb8f7f46c2'
};
```

---

## Troubleshooting

### Common Issues

1. **CORS Errors**
   - The API may require proxy configuration
   - Create `proxy.conf.json` in root:
   ```json
   {
     "/api": {
       "target": "https://apiv2.allsportsapi.com",
       "secure": true,
       "changeOrigin": true,
       "pathRewrite": {
         "^/api": "/football"
       }
     }
   }
   ```
   - Update `angular.json`:
   ```json
   "serve": {
     "options": {
       "proxyConfig": "proxy.conf.json"
     }
   }
   ```

2. **WebSocket Not Connecting**
   - Verify WebSocket URL is correct
   - Check if WebSocket server is running
   - Ensure firewall allows WebSocket connections

3. **Standings Not Updating**
   - Check browser console for errors
   - Verify league_id in GOAL_SCORED event matches current league
   - Check network tab for API calls

---

## Next Steps

1. **Add League Selector**: Create a dropdown to switch between different leagues
2. **Add Season Selector**: Allow users to view historical standings
3. **Team Details**: Link team names to detailed team pages
4. **Live Indicators**: Add visual indicators when standings update in real-time
5. **Notifications**: Toast notifications when goals are scored and standings update

---

## Additional Resources

- [AllSportsAPI Documentation](https://allsportsapi.com/documentation)
- [Angular HttpClient Guide](https://angular.io/guide/http)
- [RxJS Documentation](https://rxjs.dev/)
- [WebSocket API](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket)

---

## Summary

This implementation provides:
- ✅ Real-time league standings display
- ✅ Three view modes (Total, Home, Away)
- ✅ Automatic refresh on goal events via WebSocket
- ✅ Caching for performance
- ✅ Responsive design
- ✅ Error handling
- ✅ TypeScript type safety

The feature is modular and can be easily extended with additional functionality.
