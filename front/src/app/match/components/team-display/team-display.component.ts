import {Component, ChangeDetectionStrategy, input, Input, Signal} from '@angular/core';
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
  templateUrl: './team-display.component.html',
  styleUrl: './team-display.component.css'
})
export class TeamDisplayComponent {
  // Signal reference passed from parent
  @Input({ required: true }) teamSignal!: Signal<Team>
}
