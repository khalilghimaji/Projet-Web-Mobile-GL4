import { Component, ChangeDetectionStrategy, Input, output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Vote, VoteOption } from '../../sections/prediction-widget/prediction-widget.section';

@Component({
  selector: 'app-user-vote-display',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './user-vote-display.component.html',
  styleUrl: './user-vote-display.component.css'
})
export class UserVoteDisplayComponent {
  @Input({ required: true }) vote!: Vote;
  @Input() canChange: boolean = false;

  changeClicked = output<void>();

  formatOption(option: VoteOption): string {
    switch (option) {
      case 'HOME': return 'Home Win';
      case 'DRAW': return 'Draw';
      case 'AWAY': return 'Away Win';
    }
  }
}

