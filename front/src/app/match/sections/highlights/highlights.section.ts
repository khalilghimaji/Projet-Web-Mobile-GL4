import {Component, ChangeDetectionStrategy, input, Signal, Input} from '@angular/core';
import { CommonModule } from '@angular/common';
import { VideoCardComponent, VideoHighlight } from '../../components/video-card/video-card.component';

@Component({
  selector: 'app-highlights',
  standalone: true,
  imports: [CommonModule, VideoCardComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <section class="py-2 pb-6">
      <!-- Header -->
      <div class="flex justify-between items-end mb-4">
        <h3 class="text-sm font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
          Highlights
        </h3>
        <a class="text-primary text-xs font-semibold cursor-pointer hover:underline">
          View All
        </a>
      </div>

      <!-- Horizontal Scrollable Video List -->
      <div class="flex overflow-x-auto gap-4 no-scrollbar pb-2">
        @for (video of highlightsSignal(); track video.id) {
          <app-video-card [videoSignal]="video" />
        }

        @if (highlightsSignal().length === 0) {
          <div class="w-full text-center py-8 text-gray-500 dark:text-gray-400 text-sm">
            No highlights available
          </div>
        }
      </div>
    </section>
  `,
  styles: [`
    :host {
      display: block;
    }

    .no-scrollbar::-webkit-scrollbar {
      display: none;
    }

    .no-scrollbar {
      -ms-overflow-style: none;
      scrollbar-width: none;
    }
  `]
})
export class HighlightsSection {
  // Signal reference from parent
  @Input({required:true}) highlightsSignal!: Signal<VideoHighlight[]>
}
