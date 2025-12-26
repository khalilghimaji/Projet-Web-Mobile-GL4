import { Component, ChangeDetectionStrategy, input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Player } from '../../models/models';
import { PlayerCardComponent } from '../player-card/player-card.component';
import { LucideAngularModule, Users } from 'lucide-angular';


@Component({
  selector: 'app-squad-section',
  imports: [CommonModule, PlayerCardComponent, LucideAngularModule],
  templateUrl: './squad-section.component.html',
  styleUrl: './squad-section.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SquadSectionComponent {
  players = input.required<Player[]>();

  
  getPlayersByPosition(players: Player[], position: string): Player[] {
    return players.filter(p => p.player_type === position);
  }
  
  readonly Users = Users;
}
