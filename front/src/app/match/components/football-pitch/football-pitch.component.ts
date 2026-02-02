import { Component, ChangeDetectionStrategy, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PlayerPositionComponent } from '../player-position/player-position.component';
import { PlayerPosition } from '../../types/lineup.types';

export interface FootballPitchData {
  homePlayers: PlayerPosition[];
  awayPlayers: PlayerPosition[];
}

@Component({
  selector: 'app-football-pitch',
  standalone: true,
  imports: [CommonModule, PlayerPositionComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './football-pitch.component.html',
  styleUrl: './football-pitch.component.css'
})
export class FootballPitchComponent {
  @Input({ required: true }) data!: FootballPitchData;
}

