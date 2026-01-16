import {Component, ChangeDetectionStrategy, input, Input, Signal, effect} from '@angular/core';
import { CommonModule } from '@angular/common';
import { TimelineEventComponent, MatchEvent } from '../../components/timeline-event/timeline-event.component';

@Component({
  selector: 'app-match-timeline',
  standalone: true,
  imports: [CommonModule, TimelineEventComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <section>
      <h3 class="text-sm font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-4">
        Match Events
      </h3>

      <div class="space-y-4 relative">
        <!-- Vertical Center Line -->
        <div class="absolute left-1/2 top-0 bottom-0 w-px bg-gray-200 dark:bg-white/10 -translate-x-1/2"></div>

        <div class="gap-4 flex flex-col">
        <!-- Events -->
        @for (event of eventsSignal(); track event.id) {
          <app-timeline-event [eventSignal]="event" />
        }
      </div>

        @if (eventsSignal().length === 0) {
          <div class="text-center py-8 text-gray-500 dark:text-gray-400 text-sm">
            No events yet
          </div>
        }
      </div>
    </section>
  `,
  styles: [`
    :host {
      display: block;
    }
  `]
})
export class MatchTimelineSection {
  // Signal reference from parent - array of events
  @Input({required:true}) eventsSignal!: Signal<MatchEvent[]>;
  private readonly _log = effect(()=>console.log('Timeline events updated:', this.eventsSignal()));
}
