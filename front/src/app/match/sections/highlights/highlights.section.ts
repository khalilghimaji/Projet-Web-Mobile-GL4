import {Component, ChangeDetectionStrategy, input, Signal, Input} from '@angular/core';
import { CommonModule } from '@angular/common';
import { VideoCardComponent, VideoHighlight } from '../../components/video-card/video-card.component';

@Component({
  selector: 'app-highlights',
  standalone: true,
  imports: [CommonModule, VideoCardComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './highlights.section.html',
  styleUrl: './highlights.section.css'
})
export class HighlightsSection {
  // Signal reference from parent
  @Input({required:true}) highlightsSignal!: Signal<VideoHighlight[]>
}
