import { Component, ChangeDetectionStrategy, inject} from '@angular/core';
import { CommonModule } from '@angular/common';
import { TeamService } from '../../services/team.service';
import { ActivatedRoute, Router } from '@angular/router';
import { toSignal } from '@angular/core/rxjs-interop';
import { map } from 'rxjs/operators';
import { TeamHeaderComponent } from '../team-header/team-header.component';
import { NextMatchComponent } from '../next-match/next-match.component';
import { RecentMatchesComponent } from '../recent-matches/recent-matches.component';
import { SquadSectionComponent } from '../squad-section/squad-section.component';

@Component({
  selector: 'app-team-detail-page',
  imports: [
    CommonModule,
    TeamHeaderComponent,
    NextMatchComponent,
    RecentMatchesComponent,
    SquadSectionComponent
  ],
  templateUrl: './team-detail-page.component.html',
  styleUrl: './team-detail-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class TeamDetailPageComponent {

  private readonly teamService = inject(TeamService);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  
  teamId = toSignal(
    this.route.params.pipe(map(params => Number(params['id']))),
    { requireSync: true }
    
  );

  teamResource = this.teamService.getTeamResource(this.teamId);
  matchesResource = this.teamService.getRecentMatchesResource(this.teamId);
  nextMatchResource = this.teamService.getNextMatchResource(this.teamId);

  /**
   * Navigate to next team (increment team ID)
   */
  incrementTeamId(): void {
    const currentId = this.teamId();
    const nextId = currentId + 1;
    this.router.navigate(['/team', nextId]);
  }

  /**
   * Navigate to previous team (decrement team ID)
   */
  decrementTeamId(): void {
    const currentId = this.teamId();
    const prevId = currentId - 1;
    if (prevId > 0) {
      this.router.navigate(['/team', prevId]);
    }
  }
}
