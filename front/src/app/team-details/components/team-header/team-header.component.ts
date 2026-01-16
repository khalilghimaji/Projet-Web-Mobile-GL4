import { Component, ChangeDetectionStrategy, input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Team } from '../../../models/models';

@Component({
  selector: 'app-team-header',
  imports: [CommonModule],
  templateUrl: './team-header.component.html',
  styleUrl: './team-header.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class TeamHeaderComponent {
  team = input.required<Team>();
}
