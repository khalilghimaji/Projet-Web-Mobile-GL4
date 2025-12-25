import { Component, Input, ChangeDetectionStrategy, Signal } from '@angular/core';

@Component({
  selector: 'score-section',
  templateUrl: './score-section.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ScoreSectionComponent {
  @Input() scoreSignal!: Signal<{ home: number; away: number }>;
}
