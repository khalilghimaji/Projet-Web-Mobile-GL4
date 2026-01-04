import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { League } from '../../models/models';
import { LeaguesService } from '../../services/leagues.service';
import { LoadingComponent } from "../loading/loading.component";

@Component({
  selector: 'app-leagues-list',
  imports: [LoadingComponent],
  templateUrl: './leagues-list.component.html',
  styleUrl: './leagues-list.component.css',
})
export class LeaguesListComponent {

  private router = inject(Router);
  private leaguesService = inject(LeaguesService);

  /**
   * Load featured leagues for selection
   */
  leaguesRes = this.leaguesService.leaguesResource;


  /**
   * Navigate to league standings
   */
  selectLeague(league: League): void {
    this.router.navigate(['/standings', league.league_key]);
  }

}
