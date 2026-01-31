import {Component, ChangeDetectionStrategy, Input, Signal} from '@angular/core';
import { CommonModule } from '@angular/common';
import { PlayerPositionComponent } from '../../components/player-position/player-position.component';
import { PlayerPosition } from '../../types/lineup.types';

export interface Lineups {
  homeFormation: string;
  awayFormation: string;
  homePlayers: PlayerPosition[];
  awayPlayers: PlayerPosition[];
}

@Component({
  selector: 'app-lineups-pitch',
  standalone: true,
  imports: [CommonModule, PlayerPositionComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './lineups-pitch.section.html',
  styleUrl: './lineups-pitch.section.css'
})
export class LineupsPitchSection {
  @Input({ required: true }) lineupsSignal!: Signal<Lineups>;
}
