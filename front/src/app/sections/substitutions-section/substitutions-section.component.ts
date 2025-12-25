import { Component, Input, ChangeDetectionStrategy, Signal } from '@angular/core';

@Component({
  selector: 'substitutions-section',
  templateUrl: './substitutions-section.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class SubstitutionsSectionComponent {
  @Input() subsSignal!: Signal<string[]>;
}
