import {Component, ChangeDetectionStrategy, input, Input, Signal} from '@angular/core';
import { CommonModule } from '@angular/common';

export interface Score {
  home: number;
  away: number;
  venue: string;
}

@Component({
  selector: 'app-score-display',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './score-display.component.html',
  styleUrl: './score-display.component.css'
})
export class ScoreDisplayComponent {
  // Signal reference passed from parent
  @Input({ required: true }) scoreSignal!: Signal<Score>
}
