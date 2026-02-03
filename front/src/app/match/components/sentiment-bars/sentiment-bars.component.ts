import { Component, ChangeDetectionStrategy, Input } from '@angular/core';
import { CommonModule } from '@angular/common';

export interface SentimentData {
  homePercentage: number;
  drawPercentage: number;
  awayPercentage: number;
}

@Component({
  selector: 'app-sentiment-bars',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './sentiment-bars.component.html',
  styleUrl: './sentiment-bars.component.css'
})
export class SentimentBarsComponent {
  @Input({ required: true }) data!: SentimentData;
}

