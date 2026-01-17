import {Component, ChangeDetectionStrategy, input, Input, Signal} from '@angular/core';
import { CommonModule } from '@angular/common';

export interface Score {
  home: number;
  away: number;
  venue: string;
}

@Component({
  selector: 'app-score-display',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="flex flex-col items-center w-1/3">
      <h1 class="text-4xl sm:text-5xl font-bold tracking-tighter mb-1">
        {{ scoreSignal().home }} - {{ scoreSignal().away }}
      </h1>
      <div class="bg-card-dark/50 px-2 py-0.5 rounded text-[10px] text-gray-400 border border-white/5">
        {{ scoreSignal().venue }}
      </div>
    </div>
  `,
  styles: [`
    :host {
      display: contents;
    }
  `]
})
export class ScoreDisplayComponent {
  // Signal reference passed from parent
  @Input({ required: true }) scoreSignal!: Signal<Score>
}
