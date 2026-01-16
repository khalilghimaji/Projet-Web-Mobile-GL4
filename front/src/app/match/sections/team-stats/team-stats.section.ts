import {Component, ChangeDetectionStrategy, input, Signal, Input} from '@angular/core';
import { CommonModule } from '@angular/common';
import { StatBarComponent, StatItem } from '../../components/stat-bar/stat-bar.component';

export interface TeamStats {
  stats: StatItem[];
}

@Component({
  selector: 'app-team-stats',
  standalone: true,
  imports: [CommonModule, StatBarComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <section class="py-2">
      <h3 class="text-sm font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-4">
        Team Stats
      </h3>

      <div class="space-y-6 gap-4 flex flex-col">
        @for (stat of statsSignal().stats; track stat.label) {
          <app-stat-bar [statSignal]="stat" />
        }

        @if (statsSignal().stats.length === 0) {
          <div class="text-center py-8 text-gray-500 dark:text-gray-400 text-sm">
            No statistics available
          </div>
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
export class TeamStatsSection {
  // Signal reference from parent
  @Input({required: true}) statsSignal!: Signal<TeamStats>
}
