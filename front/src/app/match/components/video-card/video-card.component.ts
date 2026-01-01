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
  template: `
    <div class="flex-shrink-0 w-60 relative group cursor-pointer">
      <!-- Thumbnail -->
      <div class="w-full aspect-video bg-gray-800 rounded-lg overflow-hidden relative">
        <div
          class="absolute inset-0 bg-cover bg-center opacity-70 group-hover:opacity-100 transition-opacity"
          [style.background-image]="'url(' + videoSignal().thumbnail + ')'"
        ></div>

        <!-- Play Button Overlay -->
        <div class="absolute inset-0 bg-black/30 flex items-center justify-center">
          <div class="size-10 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center border border-white/40">
            <span class="material-symbols-outlined text-white filled">play_arrow</span>
          </div>
        </div>

        <!-- Duration Badge -->
        <span class="absolute bottom-2 right-2 bg-black/80 text-white text-[10px] px-1.5 py-0.5 rounded">
          {{ videoSignal().duration }}
        </span>
      </div>

      <!-- Title -->
      <p class="mt-2 text-sm font-medium leading-tight line-clamp-2">
        {{ videoSignal().title }}
      </p>
    </div>
  `,
  styles: [`
    :host {
      display: contents;
    }

    .material-symbols-outlined.filled {
      font-variation-settings: 'FILL' 1;
    }

    .line-clamp-2 {
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
  `]
})
export class VideoCardComponent {
  // Signal reference passed from parent
  videoSignal = input.required<VideoHighlight>();
}
