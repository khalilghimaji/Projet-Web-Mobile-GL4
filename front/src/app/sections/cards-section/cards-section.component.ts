import { Component, Input, ChangeDetectionStrategy, Signal } from '@angular/core';

@Component({
  selector: 'cards-section',
  templateUrl: './cards-section.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class CardsSectionComponent {
  @Input() cardsSignal!: Signal<string[]>;
}
