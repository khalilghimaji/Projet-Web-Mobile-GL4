import { Component, ChangeDetectionStrategy, input, computed } from '@angular/core';
import { CommonModule } from '@angular/common';

export interface StatItem {
  label: string;
  homeValue: number;
  awayValue: number;
  isPercentage?: boolean;
}

@Component({
  selector: 'app-stat-bar',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="space-y-2">
      <!-- Values and Label -->
      <div class="flex justify-between text-sm font-bold">
        <span>{{ displayValue().home }}</span>
        <span class="text-gray-500 font-medium">{{ statSignal().label }}</span>
        <span>{{ displayValue().away }}</span>
      </div>

      <!-- Visual Bar -->
      <div class="flex h-2 w-full rounded-full overflow-hidden bg-gray-200 dark:bg-white/10">
        <div
          class="bg-primary h-full transition-all duration-300"
          [style.width.%]="percentage().home"
        ></div>
        <div
          class="bg-gray-400 dark:bg-gray-600 h-full transition-all duration-300"
          [style.width.%]="percentage().away"
        ></div>
      </div>
    </div>
  `,
  styles: [`
    :host {
      display: block;
    }
  `]
})
export class StatBarComponent {
  // Signal reference passed from parent
  statSignal = input.required<StatItem>();

  // Computed percentage for visual bar
  percentage = computed(() => {
    const stat = this.statSignal();
    const total = stat.homeValue + stat.awayValue;

    if (total === 0) {
      return { home: 50, away: 50 };
    }

    const homePercent = (stat.homeValue / total) * 100;
    const awayPercent = (stat.awayValue / total) * 100;

    return {
      home: Math.round(homePercent),
      away: Math.round(awayPercent)
    };
  });

  // Computed display value (with % suffix if needed)
  displayValue = computed(() => {
    const stat = this.statSignal();
    const suffix = stat.isPercentage ? '%' : '';

    return {
      home: `${stat.homeValue}${suffix}`,
      away: `${stat.awayValue}${suffix}`
    };
  });
}
