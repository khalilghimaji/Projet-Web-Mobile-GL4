import {Component, ChangeDetectionStrategy, input, Signal, Input} from '@angular/core';
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
  templateUrl: './status-badge.component.html',
  styleUrl: './status-badge.component.css'
})
export class StatusBadgeComponent {
  // Signal reference passed from parent
  @Input({ required: true }) statusSignal!: Signal<MatchStatus>
}
