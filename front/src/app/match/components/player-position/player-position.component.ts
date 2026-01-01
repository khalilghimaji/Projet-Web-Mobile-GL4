import { Component, ChangeDetectionStrategy, input } from '@angular/core';
import { CommonModule } from '@angular/common';

export interface PlayerPosition {
  number: number;
  name: string;
  position: { x: string; y: string }; // e.g., { x: '50%', y: '20%' }
  team: 'home' | 'away';
  isGoalkeeper?: boolean;
}

@Component({
  selector: 'app-player-position',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div
      class="absolute flex flex-col items-center"
      [style.left]="playerSignal().position.x"
      [style.top]="playerSignal().position.y"
      [style.bottom]="playerSignal().position.y.includes('bottom') ? playerSignal().position.y : 'auto'"
      [style.transform]="'translate(-50%, -50%)'"
    >
      <div
        class="size-8 rounded-full border-2 border-white shadow-sm flex items-center justify-center text-[10px] font-bold"
        [class.bg-yellow-400]="playerSignal().isGoalkeeper"
        [class.text-black]="playerSignal().isGoalkeeper"
        [class.bg-sky-200]="playerSignal().team === 'home' && !playerSignal().isGoalkeeper"
        [class.text-black]="playerSignal().team === 'home' && !playerSignal().isGoalkeeper"
        [class.bg-red-600]="playerSignal().team === 'away' && !playerSignal().isGoalkeeper"
        [class.text-white]="playerSignal().team === 'away' && !playerSignal().isGoalkeeper"
      >
        {{ playerSignal().number }}
      </div>
      <span class="text-[9px] text-white font-medium mt-0.5 shadow-black drop-shadow-md">
        {{ playerSignal().name }}
      </span>
    </div>
  `,
  styles: [`
    :host {
      display: contents;
    }
  `]
})
export class PlayerPositionComponent {
  // Signal reference passed from parent
  playerSignal = input.required<PlayerPosition>();
}
