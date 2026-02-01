import {Component, ChangeDetectionStrategy, input, Input, Signal, effect} from '@angular/core';
import { CommonModule } from '@angular/common';
import { TimelineEventComponent, MatchEvent } from '../../components/timeline-event/timeline-event.component';

@Component({
  selector: 'app-match-timeline',
  standalone: true,
  imports: [CommonModule, TimelineEventComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './match-timeline.section.html',
  styleUrl: './match-timeline.section.css'
})
export class MatchTimelineSection {
  // Signal reference from parent - array of events
  @Input({required:true}) eventsSignal!: Signal<MatchEvent[]>;
  private readonly _log = effect(()=>console.log('Timeline events updated:', this.eventsSignal()));
}
