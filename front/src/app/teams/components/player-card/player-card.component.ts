import { Component, ChangeDetectionStrategy, input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Player } from '../../models/models';

/**
 * Presentational component for displaying a single player card
 */
@Component({
  selector: 'app-player-card',
  imports: [CommonModule],
  templateUrl: './player-card.component.html',
  styleUrl: './player-card.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class PlayerCardComponent {

  player = input.required<Player>();
}
