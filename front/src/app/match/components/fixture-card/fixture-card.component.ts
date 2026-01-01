import { Component, ChangeDetectionStrategy, input, computed, output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ParsedFixture, FixtureStatus } from '../../types/fixture.types';

@Component({
  selector: 'app-fixture-card',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './fixture-card.component.html',
  styleUrls: ['./fixture-card.component.css']
})
export class FixtureCardComponent {
  fixtureSignal = input.required<ParsedFixture>();
  cardClicked = output<string>();

  parsedFixture = computed(() => this.fixtureSignal());
}

