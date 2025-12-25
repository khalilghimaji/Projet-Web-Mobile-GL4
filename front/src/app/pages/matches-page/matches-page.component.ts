import { Component, OnInit, signal } from '@angular/core';
import { LiveMatchService, MatchSignals } from '../../services/live-match.service';
import { FinishedMatchService } from '../../services/finished-match.service';

interface MatchSummary { id: string; status: 'live' | 'finished'; }

@Component({
  selector: 'matches-page',
  templateUrl: './matches-page.component.html'
})
export class MatchesPageComponent implements OnInit {
  matches: { id: string; signals: MatchSignals }[] = [];

  constructor(
    private liveService: LiveMatchService,
    private finishedService: FinishedMatchService
  ) {}

  ngOnInit() {
    const matchList: MatchSummary[] = [
      { id: '101', status: 'live' },
      { id: '102', status: 'finished' }
    ];

    for (const m of matchList) {
      const signals: MatchSignals = {
        score: signal({ home: 0, away: 0 }),
        cards: signal([]),
        substitutions: signal([])
      };
      this.matches.push({ id: m.id, signals });

      if (m.status === 'live') {
        this.liveService.connect(m.id, signals);
      } else {
        this.finishedService.load(m.id, signals);
      }
    }
  }
}
