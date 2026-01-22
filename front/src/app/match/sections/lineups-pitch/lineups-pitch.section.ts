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
  template: `
    <section>
      <!-- Header with Formations -->
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-sm font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
          Lineups
        </h3>
        <div class="flex gap-2">
          <span class="text-xs px-2 py-1 bg-white dark:bg-white/10 rounded text-slate-900 dark:text-white font-medium">
            {{ lineupsSignal().homeFormation }}
          </span>
          <span class="text-xs px-2 py-1 bg-white dark:bg-white/10 rounded text-slate-900 dark:text-white font-medium">
            {{ lineupsSignal().awayFormation }}
          </span>
        </div>
      </div>

      <!-- Pitch Visualization -->
      <div class="w-full max-w-4xl mx-auto aspect-[2/3] bg-[#2a4e3a] rounded-lg border-2 border-white/10 relative overflow-hidden"
           style="background-image: url('https://www.transparenttextures.com/patterns/grass.png'); height: 500px; max-height: 500px;">

        <!-- Pitch Markings -->
        <div class="absolute inset-4 border-2 border-white/20 rounded-sm"></div>
        <div class="absolute top-1/2 left-4 right-4 h-px bg-white/20"></div>
        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-16 h-16 border border-white/20 rounded-full"></div>
        <div class="absolute top-4 left-1/2 -translate-x-1/2 w-24 h-12 border border-t-0 border-white/20 rounded-b-lg"></div>
        <div class="absolute bottom-4 left-1/2 -translate-x-1/2 w-24 h-12 border border-b-0 border-white/20 rounded-t-lg"></div>

        <!-- Home Team Players -->
        @for (player of lineupsSignal().homePlayers; track player.id) {
          <app-player-position [playerSignal]="player" />
        }

        <!-- Away Team Players -->
        @for (player of lineupsSignal().awayPlayers; track player.id) {
          <app-player-position [playerSignal]="player" />
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
export class LineupsPitchSection {
  @Input({ required: true }) lineupsSignal!: Signal<Lineups>;
}
