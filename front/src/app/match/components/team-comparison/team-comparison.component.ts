import { Component, ChangeDetectionStrategy, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormIndicatorComponent, FormResult } from '../form-indicator/form-indicator.component';

export interface TeamComparisonData {
  homeTeamLogo: string;
  awayTeamLogo: string;
  recentForm: FormResult[];
}

@Component({
  selector: 'app-team-comparison',
  standalone: true,
  imports: [CommonModule, FormIndicatorComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './team-comparison.component.html',
  styleUrl: './team-comparison.component.css'
})
export class TeamComparisonComponent {
  @Input({ required: true }) data!: TeamComparisonData;
  protected readonly Math = Math;
}

