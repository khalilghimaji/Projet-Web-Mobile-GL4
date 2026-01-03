import { Component, ChangeDetectionStrategy, input } from '@angular/core';
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
  template: `
    <div class="flex items-center justify-between w-full">
      <!-- Home Side -->
      <div class="w-[45%] flex flex-col items-end text-right pr-4">
        @if (eventSignal().team === 'home') {
          <span class="font-bold text-sm" [class.text-primary]="eventSignal().type === 'SUBSTITUTION'">
            {{ getPlayerText() }}
          </span>
          @if (eventSignal().detail) {
            <span class="text-xs text-gray-500">{{ eventSignal().detail }}</span>
          }
        }
      </div>

      <!-- Center Time Badge with Icon -->
      <div class="w-[10%] flex justify-center relative z-10">
        <div class="size-8 rounded-full bg-background-light dark:bg-background-dark border border-gray-200 dark:border-white/10 flex items-center justify-center text-xs font-bold">
          {{ eventSignal().minute }}'
        </div>

        @switch (eventSignal().type) {
          @case ('GOAL') {
            <span class="absolute -top-1 -right-1 material-symbols-outlined text-base text-primary filled">
              sports_soccer
            </span>
          }
          @case ('YELLOW_CARD') {
            <div class="absolute -top-1 -right-1 h-3 w-2 bg-yellow-400 rounded-[1px]"></div>
          }
          @case ('RED_CARD') {
            <div class="absolute -top-1 -right-1 h-3 w-2 bg-red-500 rounded-[1px]"></div>
          }
          @case ('SUBSTITUTION') {
            <span class="absolute -top-1 -right-1 material-symbols-outlined text-base text-gray-400">
              sync_alt
            </span>
          }
        }
      </div>

      <!-- Away Side -->
      <div class="w-[45%] flex flex-col items-start pl-4">
        @if (eventSignal().team === 'away') {
          <span class="font-bold text-sm" [class.text-primary]="eventSignal().type === 'SUBSTITUTION'">
            {{ getPlayerText() }}
          </span>
          @if (eventSignal().detail) {
            <span class="text-xs text-gray-500">{{ eventSignal().detail }}</span>
          }
        }
      </div>
    </div>
  `,
  styles: [`
    :host {
      display: contents;
    }

    .material-symbols-outlined.filled {
      font-variation-settings: 'FILL' 1;
    }
  `]
})
export class TimelineEventComponent {
  // Signal reference passed from parent
  eventSignal = input.required<MatchEvent>();

  getPlayerText(): string {
    const event = this.eventSignal();
    if (event.type === 'SUBSTITUTION') {
      return `IN: ${event.player}`;
    }
    return event.player;
  }
}
