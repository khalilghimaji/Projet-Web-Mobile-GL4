import { Component, ChangeDetectionStrategy, Input, output } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-predict-button',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './predict-button.component.html',
  styleUrl: './predict-button.component.css'
})
export class PredictButtonComponent {
  @Input() enabled: boolean = true;

  clicked = output<void>();
}

