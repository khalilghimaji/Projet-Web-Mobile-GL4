import { Component, ChangeDetectionStrategy, input } from '@angular/core';
import { CommonModule } from '@angular/common';

export type FormResult = 'W' | 'D' | 'L';

@Component({
  selector: 'app-form-indicator',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="flex gap-2">
      @for (result of formSignal(); track $index) {
        <div
          class="size-8 rounded flex items-center justify-center font-bold text-white text-xs"
          [class.bg-green-500]="result === 'W'"
          [class.bg-gray-400]="result === 'D'"
          [class.bg-red-500]="result === 'L'"
        >
          {{ result }}
        </div>
      }
    </div>
  `,
  styles: [`
    :host {
      display: contents;
    }
  `]
})
export class FormIndicatorComponent {
  // Signal reference passed from parent
  formSignal = input.required<FormResult[]>();
}
