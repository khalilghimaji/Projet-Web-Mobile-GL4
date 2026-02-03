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
  templateUrl: './team-stats.section.html',
  styleUrl: './team-stats.section.css'
})
export class TeamStatsSection {
  // Signal reference from parent
  @Input({required: true}) statsSignal!: Signal<TeamStats>
}
