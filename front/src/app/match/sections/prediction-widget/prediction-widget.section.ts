import { Component, ChangeDetectionStrategy, input, output } from '@angular/core';
import { CommonModule } from '@angular/common';

export type VoteOption = 'HOME' | 'DRAW' | 'AWAY';

export interface PredictionData {
  totalVotes: number;
  homePercentage: number;
  drawPercentage: number;
  awayPercentage: number;
  userVote?: VoteOption;
}

@Component({
  selector: 'app-prediction-widget',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="px-4 py-6">
      <div class="bg-white dark:bg-card-dark rounded-xl p-4 shadow-sm border border-gray-100 dark:border-white/5">
        <!-- Header -->
        <div class="flex justify-between items-center mb-3">
          <h3 class="text-sm font-semibold text-slate-700 dark:text-gray-200">
            Who will win?
          </h3>
          <span class="text-xs text-primary font-medium">
            {{ formatVotes(predictionSignal().totalVotes) }} Votes
          </span>
        </div>

        <!-- Vote Buttons -->
        <div class="flex gap-2 mb-2">
          <button
            class="flex-1 py-2.5 rounded-lg text-sm font-bold transition-all active:scale-95"
            [class.bg-primary/20]="predictionSignal().userVote === 'HOME'"
            [class.hover:bg-primary/30]="predictionSignal().userVote === 'HOME'"
            [class.dark:bg-primary/20]="predictionSignal().userVote === 'HOME'"
            [class.dark:hover:bg-primary/30]="predictionSignal().userVote === 'HOME'"
            [class.text-primary]="predictionSignal().userVote === 'HOME'"
            [class.border]="predictionSignal().userVote === 'HOME'"
            [class.border-primary/50]="predictionSignal().userVote === 'HOME'"
            [class.bg-gray-100]="predictionSignal().userVote !== 'HOME'"
            [class.dark:bg-white/5]="predictionSignal().userVote !== 'HOME'"
            [class.hover:bg-gray-200]="predictionSignal().userVote !== 'HOME'"
            [class.dark:hover:bg-white/10]="predictionSignal().userVote !== 'HOME'"
            [class.text-gray-600]="predictionSignal().userVote !== 'HOME'"
            [class.dark:text-gray-400]="predictionSignal().userVote !== 'HOME'"
            (click)="onVote('HOME')"
          >
            Home
          </button>

          <button
            class="flex-1 py-2.5 rounded-lg text-sm transition-all active:scale-95"
            [class.bg-primary/20]="predictionSignal().userVote === 'DRAW'"
            [class.hover:bg-primary/30]="predictionSignal().userVote === 'DRAW'"
            [class.text-primary]="predictionSignal().userVote === 'DRAW'"
            [class.font-bold]="predictionSignal().userVote === 'DRAW'"
            [class.border]="predictionSignal().userVote === 'DRAW'"
            [class.border-primary/50]="predictionSignal().userVote === 'DRAW'"
            [class.bg-gray-100]="predictionSignal().userVote !== 'DRAW'"
            [class.dark:bg-white/5]="predictionSignal().userVote !== 'DRAW'"
            [class.hover:bg-gray-200]="predictionSignal().userVote !== 'DRAW'"
            [class.dark:hover:bg-white/10]="predictionSignal().userVote !== 'DRAW'"
            [class.text-gray-600]="predictionSignal().userVote !== 'DRAW'"
            [class.dark:text-gray-400]="predictionSignal().userVote !== 'DRAW'"
            [class.font-medium]="predictionSignal().userVote !== 'DRAW'"
            (click)="onVote('DRAW')"
          >
            Draw
          </button>

          <button
            class="flex-1 py-2.5 rounded-lg text-sm transition-all active:scale-95"
            [class.bg-primary/20]="predictionSignal().userVote === 'AWAY'"
            [class.hover:bg-primary/30]="predictionSignal().userVote === 'AWAY'"
            [class.text-primary]="predictionSignal().userVote === 'AWAY'"
            [class.font-bold]="predictionSignal().userVote === 'AWAY'"
            [class.border]="predictionSignal().userVote === 'AWAY'"
            [class.border-primary/50]="predictionSignal().userVote === 'AWAY'"
            [class.bg-gray-100]="predictionSignal().userVote !== 'AWAY'"
            [class.dark:bg-white/5]="predictionSignal().userVote !== 'AWAY'"
            [class.hover:bg-gray-200]="predictionSignal().userVote !== 'AWAY'"
            [class.dark:hover:bg-white/10]="predictionSignal().userVote !== 'AWAY'"
            [class.text-gray-600]="predictionSignal().userVote !== 'AWAY'"
            [class.dark:text-gray-400]="predictionSignal().userVote !== 'AWAY'"
            [class.font-medium]="predictionSignal().userVote !== 'AWAY'"
            (click)="onVote('AWAY')"
          >
            Away
          </button>
        </div>

        <!-- Sentiment Bars -->
        <div class="flex h-1.5 w-full rounded-full overflow-hidden gap-0.5 mt-2">
          <div
            class="bg-primary h-full transition-all duration-300"
            [style.width.%]="predictionSignal().homePercentage"
          ></div>
          <div
            class="bg-gray-300 dark:bg-gray-600 h-full transition-all duration-300"
            [style.width.%]="predictionSignal().drawPercentage"
          ></div>
          <div
            class="bg-gray-400 dark:bg-gray-500 h-full transition-all duration-300"
            [style.width.%]="predictionSignal().awayPercentage"
          ></div>
        </div>

        <!-- Percentages -->
        <div class="flex justify-between text-[10px] text-gray-500 mt-1 font-medium">
          <span>{{ predictionSignal().homePercentage }}%</span>
          <span>{{ predictionSignal().drawPercentage }}%</span>
          <span>{{ predictionSignal().awayPercentage }}%</span>
        </div>
      </div>
    </div>
  `,
  styles: [`
    :host {
      display: block;
    }
  `]
})
export class PredictionWidgetSection {
  // Signal reference from parent
  predictionSignal = input.required<PredictionData>();

  // Output event for vote action
  voteSelected = output<VoteOption>();

  onVote(option: VoteOption): void {
    this.voteSelected.emit(option);
  }

  formatVotes(votes: number): string {
    if (votes >= 1000) {
      return `${(votes / 1000).toFixed(1)}k`;
    }
    return votes.toString();
  }
}
