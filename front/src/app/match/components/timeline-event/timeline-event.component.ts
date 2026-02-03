import {Component, ChangeDetectionStrategy, input, effect} from '@angular/core';
import { CommonModule } from '@angular/common';

export type EventType = 'GOAL' | 'YELLOW_CARD' | 'RED_CARD' | 'SUBSTITUTION' | 'GOAL_SCORED';

export interface MatchEvent {
  id: string;
  minute: number;
  type: EventType;
  team: 'home' | 'away';
  player: string;
  detail?: string; // assist, reason, substitution info
}

@Component({
  selector: 'app-timeline-event',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './timeline-event.component.html',
  styleUrl: './timeline-event.component.css'
})
export class TimelineEventComponent {
  // Signal reference passed from parent
  eventSignal = input.required<MatchEvent>();
  private readonly _log = effect(() => console.log(this.eventSignal()));

  getPlayerText(): string {
    const event = this.eventSignal();
    if (event.type === 'SUBSTITUTION') {
      return `IN: ${event.player}`;
    }
    return event.player;
  }
}
