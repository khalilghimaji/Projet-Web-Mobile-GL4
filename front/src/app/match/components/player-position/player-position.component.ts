import { Component, ChangeDetectionStrategy, input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PlayerPosition } from '../../types/lineup.types';

@Component({
  selector: 'app-player-position',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './player-position.component.html',
  styleUrl: './player-position.component.css'
})
export class PlayerPositionComponent {
  // Signal reference passed from parent
  playerSignal = input.required<PlayerPosition>();
}
