import {Component, ChangeDetectionStrategy, input, Input, Signal} from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormIndicatorComponent, FormResult } from '../../components/form-indicator/form-indicator.component';

export interface HeadToHead {
  homeTeamLogo: string;
  awayTeamLogo: string;
  recentForm: FormResult[];
}

@Component({
  selector: 'app-head-to-head',
  standalone: true,
  imports: [CommonModule, FormIndicatorComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <section class="py-2">
      <h3 class="text-sm font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-4">
        Head to Head
      </h3>

      <div class="bg-white dark:bg-card-dark rounded-xl p-4 border border-gray-100 dark:border-white/5">
        <div class="flex items-center justify-between mb-4">
          <!-- Home Team Logo -->
          <div class="flex flex-col items-center w-16">
            <img
              [src]="h2hSignal().homeTeamLogo"
              alt="Home Team"
              class="w-8 h-8 object-contain mb-1"
            />
          </div>

          <!-- Form Results -->
          <div class="flex-1 flex justify-center">
            <app-form-indicator [formSignal]="h2hSignal().recentForm" />
          </div>

          <!-- Away Team Logo -->
          <div class="flex flex-col items-center w-16">
            <img
              [src]="h2hSignal().awayTeamLogo"
              alt="Away Team"
              class="w-8 h-8 object-contain mb-1"
            />
          </div>
        </div>

        <div class="text-center text-xs text-gray-500">
          Last 5 Matches
        </div>
      </div>
    </section>
  `,
  styles: [`
    :host {
      display: block;
    }
  `]
})
export class HeadToHeadSection {
  // Signal reference from parent
  @Input({required: true}) h2hSignal!: Signal<HeadToHead>
}
