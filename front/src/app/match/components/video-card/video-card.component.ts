import { Component, ChangeDetectionStrategy, input } from '@angular/core';
import { CommonModule } from '@angular/common';

export interface VideoHighlight {
  id: string;
  title: string;
  thumbnail: string;
  duration: string; // e.g., "02:14"
  url: string;
}

@Component({
  selector: 'app-video-card',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './video-card.component.html',
  styleUrl: './video-card.component.css'
})
export class VideoCardComponent {
  // Signal reference passed from parent
  videoSignal = input.required<VideoHighlight>();
}
