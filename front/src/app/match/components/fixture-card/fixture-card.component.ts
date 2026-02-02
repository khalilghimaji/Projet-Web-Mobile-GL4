import { Component, ChangeDetectionStrategy, input, output, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ParsedFixture } from '../../types/fixture.types';
import { MatchTimerComponent } from '../match-timer/match-timer.component';

@Component({
  selector: 'app-fixture-card',
  standalone: true,
  imports: [CommonModule, MatchTimerComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './fixture-card.component.html',
  styleUrls: ['./fixture-card.component.css']
})
export class FixtureCardComponent {

  fixture = input.required<ParsedFixture>();

  timerStatus = computed(() => {
    const f = this.fixture();
    return {
      status: this.mapStatus(f.parsedStatus),
      minute: f.minute ?? 0,
      isLive: f.parsedStatus === 'LIVE'
    };
  });

  cardClicked = output<string>();

  private mapStatus(parsedStatus: string): 'SCHEDULED' | 'LIVE' | 'HT' | 'FT' {
    switch (parsedStatus) {
      case 'LIVE': return 'LIVE';
      case 'FINISHED': return 'FT';
      case 'HALFTIME': return 'HT';
      default: return 'SCHEDULED';
    }
  }
}

