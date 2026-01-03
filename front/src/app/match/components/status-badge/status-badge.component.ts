import { Component, ChangeDetectionStrategy, input } from '@angular/core';
import { CommonModule } from '@angular/common';

export interface MatchStatus {
  isLive: boolean;
  minute?: number;
  status: 'LIVE' | 'FT' | 'HT' | 'SCHEDULED';
  competition: string;
}

@Component({
  selector: 'app-status-badge',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="flex items-center gap-2 bg-primary/10 px-3 py-1 rounded-full">
      @if (statusSignal().isLive) {
        <span class="relative flex h-2 w-2">
          <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary opacity-75"></span>
          <span class="relative inline-flex rounded-full h-2 w-2 bg-primary"></span>
        </span>
      }

      <p class="text-primary text-xs font-bold uppercase tracking-wider">
        {{ statusSignal().status }}
        @if (statusSignal().minute) {
          {{ statusSignal().minute }}'
        }
      </p>

      <span class="text-gray-400 dark:text-gray-500 text-xs">|</span>

      <p class="text-gray-500 dark:text-gray-400 text-xs font-medium">
        {{ statusSignal().competition }}
      </p>
    </div>
  `,
  styles: [`
    :host {
      display: contents;
    }
  `]
})
export class StatusBadgeComponent {
  // Signal reference passed from parent
  statusSignal = input.required<MatchStatus>();
}
