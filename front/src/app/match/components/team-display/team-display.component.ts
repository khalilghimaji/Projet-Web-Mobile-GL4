import { Component, ChangeDetectionStrategy, input } from '@angular/core';
import { CommonModule } from '@angular/common';

export interface Team {
  id: string;
  name: string;
  shortName: string;
  logo: string;
}

@Component({
  selector: 'app-team-display',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="flex flex-col items-center gap-3 w-1/3">
      <div class="w-16 h-16 sm:w-20 sm:h-20 bg-white rounded-full p-3 shadow-lg flex items-center justify-center">
        <img
          [src]="teamSignal().logo"
          [alt]="teamSignal().name + ' Logo'"
          class="w-full h-full object-contain"
        />
      </div>
      <h3 class="text-center font-bold text-sm sm:text-base leading-tight">
        {{ teamSignal().shortName }}
      </h3>
    </div>
  `,
  styles: [`
    :host {
      display: contents;
    }
  `]
})
export class TeamDisplayComponent {
  // Signal reference passed from parent
  teamSignal = input.required<Team>();
}
