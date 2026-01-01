# Reusing Existing WebSocket Services for League Standings

## Overview

Great news! Your project already has excellent WebSocket infrastructure in `src/app/match/services/`:
- ✅ `live-events.service.ts` - Smart WebSocket with RxJS, auto-connection management
- ✅ `live-match.service.ts` - Match-specific WebSocket handler

We can **reuse this pattern** instead of creating everything from scratch!

---

## Existing WebSocket Architecture

### LiveEventsService Pattern

Your `live-events.service.ts` already implements:
- ✅ **Lazy connection** - Only connects when someone subscribes
- ✅ **Auto-disconnect** - Closes after 300ms of no subscribers
- ✅ **Shared observable** - Multiple subscribers share one connection
- ✅ **RxJS webSocket** - Better than native WebSocket API

```typescript
// Current structure (simplified)
export class LiveEventsService {
  private socket$ = defer(() => webSocket<MatchEvent>('wss://example.com/live'));
  
  readonly events$ = new Observable<MatchEvent>(observer => {
    // Smart subscriber counting and auto-close logic
  }).pipe(share());
}
```

---

## Recommended Approach: Extend the Pattern

### Option 1: Create GoalEventsService Using Same Pattern (Recommended)

Create `src/app/services/goal-events.service.ts`:

```typescript
import { Injectable } from '@angular/core';
import { defer, Observable, share, filter, map } from 'rxjs';
import { webSocket, WebSocketSubject } from 'rxjs/webSocket';
import { GoalScoredEvent } from '../models/models';

@Injectable({ providedIn: 'root' })
export class GoalEventsService {
  private readonly closeDelayMs = 300;
  
  // Lazy WebSocket connection
  private socket$ = defer(() => {
    console.log('⚽ Goal Events WS CONNECT');
    // TODO: Replace with your actual WebSocket URL
    return webSocket<GoalScoredEvent | any>('wss://your-websocket-server.com/live');
  });

  private subscribers = 0;
  private closeTimer: any = null;

  /**
   * Observable stream of goal scored events
   * Auto-connects when subscribed, auto-disconnects when no subscribers
   */
  readonly goalEvents$: Observable<GoalScoredEvent> = new Observable<GoalScoredEvent>(observer => {
    this.subscribers++;

    if (this.closeTimer) {
      clearTimeout(this.closeTimer);
      this.closeTimer = null;
    }

    const sub = this.socket$.pipe(
      filter((event: any) => event.type === 'GOAL_SCORED'),
      map(event => event as GoalScoredEvent)
    ).subscribe(observer);

    return () => {
      this.subscribers--;

      if (this.subscribers === 0) {
        this.closeTimer = setTimeout(() => {
          console.log('⚽ Goal Events WS DISCONNECT');
          sub.unsubscribe();
        }, this.closeDelayMs);
      } else {
        sub.unsubscribe();
      }
    };
  }).pipe(share());
}
```

**Benefits:**
- ✅ Reuses proven pattern from `live-events.service.ts`
- ✅ Smart connection management (no memory leaks)
- ✅ Automatic cleanup
- ✅ Multiple components can subscribe independently

---

## Integration with Standings

### Update StandingsUpdaterService

```typescript
import { Injectable, OnDestroy, inject } from '@angular/core';
import { Subscription } from 'rxjs';
import { GoalEventsService } from './goal-events.service';
import { StandingsService } from './standings.service';
import { NotificationService } from './notification.service';

@Injectable({ providedIn: 'root' })
export class StandingsUpdaterService implements OnDestroy {
  private subscription?: Subscription;
  
  private goalEvents = inject(GoalEventsService);
  private standings = inject(StandingsService);
  private notification = inject(NotificationService);

  /**
   * Start listening - WebSocket connects automatically
   */
  startListening(): void {
    if (this.subscription) return;

    this.subscription = this.goalEvents.goalEvents$.subscribe(event => {
      console.log('⚽ Goal scored! Refreshing standings:', event);
      
      // Show notification
      this.notification.showInfo(
        `${event.scorer} scored! ${event.score}`,
        'Goal!'
      );
      
      // Refresh standings
      this.standings.refreshStandings(event.league_id);
    });
  }

  /**
   * Stop listening - WebSocket disconnects automatically
   */
  stopListening(): void {
    this.subscription?.unsubscribe();
    this.subscription = undefined;
  }

  ngOnDestroy(): void {
    this.stopListening();
  }
}
```

---

## Option 2: Extend Existing MatchEvent Type

If your WebSocket server sends all events through one connection, you can extend the existing `MatchEvent` interface:

### Update `src/app/match/types/timeline.types.ts`:

```typescript
export type EventType = 
  | 'GOAL' 
  | 'YELLOW_CARD' 
  | 'RED_CARD' 
  | 'SUBSTITUTION' 
  | 'PENALTY' 
  | 'VAR' 
  | 'INJURY'
  | 'GOAL_SCORED'; // Add for league-wide goals

export interface MatchEvent {
  id: string;
  minute: number;
  type: EventType;
  team: TeamSide;
  player: string;
  detail?: string;
  timestamp?: Date;
  
  // Extended fields for GOAL_SCORED events
  match_id?: string;
  scorer?: string;
  score?: string;
  home_team?: string;
  away_team?: string;
  league_id?: string;
}
```

### Then use LiveEventsService directly:

```typescript
import { Injectable, inject } from '@angular/core';
import { filter } from 'rxjs';
import { LiveEventsService } from '../match/services/live-events.service';
import { StandingsService } from './standings.service';

@Injectable({ providedIn: 'root' })
export class StandingsUpdaterService {
  private liveEvents = inject(LiveEventsService);
  private standings = inject(StandingsService);

  startListening(): void {
    this.liveEvents.events$.pipe(
      filter(event => event.type === 'GOAL_SCORED' && event.league_id)
    ).subscribe(event => {
      console.log('⚽ Goal from live events:', event);
      this.standings.refreshStandings(event.league_id!);
    });
  }
}
```

---

## WebSocket URL Configuration

Your WebSocket URL should be configured based on your backend. Options:

### 1. Same domain (recommended):
```typescript
// If your backend is at http://localhost:3003
const wsUrl = 'ws://localhost:3003/live';

// For production (HTTPS)
const wsUrl = 'wss://your-domain.com/live';
```

### 2. Environment-based:
```typescript
// environment.development.ts
export const environment = {
  production: false,
  apiUrl: 'http://localhost:3003',
  wsUrl: 'ws://localhost:3003/live',  // Add this
  allSportsApi: { ... }
};

// In service:
import { environment } from '../../environments/environment';
return webSocket<GoalScoredEvent>(environment.wsUrl);
```

---

## Testing the WebSocket Connection

### 1. Test in Browser Console:

```javascript
// Test WebSocket connection
const ws = new WebSocket('ws://localhost:3003/live');
ws.onopen = () => console.log('✅ Connected');
ws.onmessage = (e) => console.log('📨 Message:', JSON.parse(e.data));
ws.onerror = (e) => console.error('❌ Error:', e);

// Send test goal event (if your server supports it)
ws.send(JSON.stringify({
  type: 'GOAL_SCORED',
  match_id: '12345',
  minute: '23',
  scorer: 'Test Player',
  team: 'home',
  score: '1-0',
  home_team: 'Team A',
  away_team: 'Team B',
  league_id: '207',
  timestamp: new Date().toISOString()
}));
```

### 2. Monitor in DevTools:

1. Open DevTools (F12)
2. Go to Network tab
3. Filter by "WS" (WebSockets)
4. Click on the WebSocket connection
5. View "Messages" tab to see real-time data

---

## Benefits of Reusing Existing Pattern

✅ **Proven architecture** - Already works in your match system  
✅ **No memory leaks** - Auto-disconnect logic  
✅ **RxJS best practices** - Deferred, shared observables  
✅ **Consistent codebase** - Same pattern everywhere  
✅ **Less code** - Reuse instead of duplicate  
✅ **Easier maintenance** - One pattern to understand  

---

## Summary

Instead of creating new WebSocket services from scratch:

1. ✅ **Reuse the pattern** from `live-events.service.ts`
2. ✅ **Create `GoalEventsService`** with the same architecture
3. ✅ **Use RxJS `webSocket`** instead of native WebSocket
4. ✅ **Filter events by type** (`GOAL_SCORED`)
5. ✅ **Let RxJS handle** connection management

This approach is cleaner, more maintainable, and follows your existing codebase patterns!
