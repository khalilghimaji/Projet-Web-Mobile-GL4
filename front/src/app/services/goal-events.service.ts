import { Injectable, inject } from '@angular/core';
import { filter } from 'rxjs';
import { LiveEventsService } from '../match/services/live-events.service';
import { StandingsService } from './standings.service';
import { NotificationService } from './notification.service';

@Injectable({ providedIn: 'root' })
export class StandingsUpdaterService {
    private liveEvents = inject(LiveEventsService);
    private standings = inject(StandingsService);
    private notification = inject(NotificationService);
    private subscription?: any;

    startListening(): void {
        if (this.subscription) return;

        // Subscribe to existing events$ and filter for goals
        this.subscription = this.liveEvents.events$.pipe(
            filter(event => event.type === 'GOAL_SCORED' as any)
        ).subscribe(event => {
            console.log('⚽ Goal event:', event);

            // Show notification
            this.notification.showInfo(
                `${event.player} scored!`,
                'Goal!'
            );

            // Refresh standings if league_id is available
            if ((event as any).league_id) {
                this.standings.refreshStandings((event as any).league_id);
            }
        });
    }

    stopListening(): void {
        this.subscription?.unsubscribe();
    }
}