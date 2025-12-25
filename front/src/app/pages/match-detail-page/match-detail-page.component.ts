import { Component, OnInit, signal } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { LiveMatchService, MatchSignals } from '../../services/live-match.service';
import { FinishedMatchService } from '../../services/finished-match.service';

@Component({
  selector: 'match-detail-page',
  templateUrl: './match-detail-page.component.html'
})
export class MatchDetailPageComponent implements OnInit {
  matchId!: string;
  signals!: MatchSignals;

  constructor(
    private route: ActivatedRoute,
    private liveService: LiveMatchService,
    private finishedService: FinishedMatchService
  ) {}

  ngOnInit() {
    this.matchId = this.route.snapshot.paramMap.get('id')!;

    this.signals = {
      score: signal({ home: 0, away: 0 }),
      cards: signal([]),
      substitutions: signal([])
    };

    // Assume we can determine status; here we just check live
    const isLive = true;

    if (isLive) {
      this.liveService.connect(this.matchId, this.signals);
    } else {
      this.finishedService.load(this.matchId, this.signals);
    }
  }
}
