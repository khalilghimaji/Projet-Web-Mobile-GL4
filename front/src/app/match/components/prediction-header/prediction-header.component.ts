import { Component, ChangeDetectionStrategy, Input, output } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-prediction-header',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './prediction-header.component.html',
  styleUrl: './prediction-header.component.css'
})
export class PredictionHeaderComponent {
  @Input({ required: true }) totalVotes!: number;

  formatVotes(votes: number): string {
    if (votes >= 1000) {
      return `${(votes / 1000).toFixed(1)}k`;
    }
    return votes.toString();
  }
}

