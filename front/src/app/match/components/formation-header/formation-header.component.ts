import { Component, ChangeDetectionStrategy, Input } from '@angular/core';
import { CommonModule } from '@angular/common';

export interface FormationData {
  homeFormation: string;
  awayFormation: string;
}

@Component({
  selector: 'app-formation-header',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './formation-header.component.html',
  styleUrl: './formation-header.component.css'
})
export class FormationHeaderComponent {
  @Input({ required: true }) data!: FormationData;
}

