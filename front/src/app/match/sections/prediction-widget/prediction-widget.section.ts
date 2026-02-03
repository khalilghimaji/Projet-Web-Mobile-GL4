import {Component, ChangeDetectionStrategy, output, Signal, Input, WritableSignal} from '@angular/core';
import { CommonModule } from '@angular/common';

export type VoteOption = 'HOME' | 'DRAW' | 'AWAY';

export interface Vote {
  option: VoteOption;
  home_score:number;
  away_score:number;
  diamonds:number;
}

export interface PredictionData {
  totalVotes: number;
  homePercentage: number;
  drawPercentage: number;
  awayPercentage: number;
  userVote?: Vote;
  voteEnabled?: boolean;
}

@Component({
  selector: 'app-prediction-widget',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './prediction-widget.section.html',
  styleUrl: './prediction-widget.section.css'
})
export class PredictionWidgetSection {
  @Input({ required: true }) predictionSignal!: Signal<PredictionData>;
  @Input({ required: true }) popupOpened!: WritableSignal<boolean>;

  voteSelected = output<VoteOption>();

  onOpenPopup(): void {
    this.popupOpened.set(true);
  }

  formatVotes(votes: number): string {
    if (votes >= 1000) {
      return `${(votes / 1000).toFixed(1)}k`;
    }
    return votes.toString();
  }

  formatOption(option: VoteOption): string {
    switch (option) {
      case 'HOME':
        return 'Home Win';
      case 'DRAW':
        return 'Draw';
      case 'AWAY':
        return 'Away Win';
    }
  }
}
