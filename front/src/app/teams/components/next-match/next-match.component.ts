import { Component, ChangeDetectionStrategy, input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Fixture } from '../../models/models';
import { LucideAngularModule, CalendarClock } from 'lucide-angular';


@Component({
  selector: 'app-next-match',
  imports: [CommonModule, LucideAngularModule],
  templateUrl: './next-match.component.html',
  styleUrl: './next-match.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class NextMatchComponent {

    match = input.required<Fixture>();

    readonly CalendarClock = CalendarClock;
}
