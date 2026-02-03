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
  templateUrl: './stat-bar.component.html',
  styleUrl: './stat-bar.component.css'
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
