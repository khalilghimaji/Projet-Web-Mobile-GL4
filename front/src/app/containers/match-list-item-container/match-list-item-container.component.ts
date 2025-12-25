import { Component, Input } from '@angular/core';
import { Signal } from '@angular/core';
import { MatchEvent } from '../../services/live-match.service';

@Component({
  selector: 'match-list-item-container',
  templateUrl: './match-list-item-container.component.html'
})
export class MatchListItemContainerComponent {
  @Input() matchId!: string;
  @Input() scoreSignal!: Signal<{ home: number; away: number }>;
}
