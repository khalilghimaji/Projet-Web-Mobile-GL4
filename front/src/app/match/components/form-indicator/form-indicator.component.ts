import { Component, ChangeDetectionStrategy, input } from '@angular/core';
import { CommonModule } from '@angular/common';

export type FormResult = 'W' | 'D' | 'L';

@Component({
  selector: 'app-form-indicator',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './form-indicator.component.html',
  styleUrl: './form-indicator.component.css'
})
export class FormIndicatorComponent {
  // Signal reference passed from parent
  formSignal = input.required<FormResult[]>();
}
