import { Component, OnInit, OnDestroy, Input, inject } from '@angular/core';
import { CommonModule, DatePipe } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { StandingsService } from '../../services/standings.service';
import { StandingsUpdaterService } from '../../services/goal-events.service';
import { LeaguesService } from '../../services/leagues.service';
import { StandingEntry, StandingsResponse, League } from '../../models/models';
import { LoadingComponent } from '../loading/loading.component';

@Component({
  selector: 'app-league-standings',
  standalone: true,
  imports: [CommonModule, LoadingComponent, DatePipe],
  templateUrl: './league-standings.component.html',
  styleUrl: './league-standings.component.css',
})
export class LeagueStandingsComponent implements OnInit, OnDestroy {
  @Input() leagueId?: string;

  // League selection view
  leagues: League[] = [];
  showLeagueSelection = true;

  // Standings view
  standings: StandingsResponse | null = null;
  selectedView: 'total' | 'home' | 'away' = 'total';
  selectedLeague: League | null = null;

  loading = true;
  error: string | null = null;

  private subscription?: Subscription;
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private standingsService = inject(StandingsService);
  private standingsUpdater = inject(StandingsUpdaterService);
  private leaguesService = inject(LeaguesService);

  ngOnInit(): void {
    // Get league ID from route or input
    const routeLeagueId = this.route.snapshot.paramMap.get('leagueId');
    const leagueId = this.leagueId || routeLeagueId;

    if (leagueId) {
      // Show standings for specific league
      this.showLeagueSelection = false;
      this.loadStandings(leagueId);
    } else {
      // Show league selection
      this.showLeagueSelection = true;
      this.loadLeagues();
    }
  }

  ngOnDestroy(): void {
    if (this.subscription) {
      this.subscription.unsubscribe();
    }
    this.standingsUpdater.stopListening();
  }

  /**
   * Load featured leagues for selection
   */
  private loadLeagues(): void {
    this.loading = true;
    this.leaguesService.getFeaturedLeagues().subscribe({
      next: (leagues) => {
        this.leagues = leagues;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Failed to load leagues. Please try again later.';
        this.loading = false;
        console.error('Leagues error:', err);
      }
    });
  }

  /**
   * Load standings for a specific league
   */
  private loadStandings(leagueId: string): void {
    this.loading = true;

    // Start listening for goal events
    this.standingsUpdater.startListening();

    // Subscribe to standings updates
    this.subscription = this.standingsService.getCachedStandings(leagueId).subscribe({
      next: (data) => {
        if (data) {
          this.standings = data;
          this.loading = false;
        }
      },
      error: (err) => {
        this.error = 'Failed to load standings. Please try again later.';
        this.loading = false;
        console.error('Standings error:', err);
      }
    });
  }

  /**
   * Navigate to league standings
   */
  selectLeague(league: League): void {
    this.selectedLeague = league;
    this.router.navigate(['/standings', league.league_key]);
  }

  /**
   * Go back to league selection
   */
  backToLeagues(): void {
    this.router.navigate(['/standings']);
  }

  /**
   * Get current standings based on selected view
   */
  get currentStandings(): StandingEntry[] {
    if (!this.standings) return [];

    switch (this.selectedView) {
      case 'home':
        return this.standings.result.home;
      case 'away':
        return this.standings.result.away;
      default:
        return this.standings.result.total;
    }
  }

  /**
   * Switch between total, home, and away views
   */
  setView(view: 'total' | 'home' | 'away'): void {
    this.selectedView = view;
  }

  /**
   * Get CSS class for standing place type
   */
  getPlaceTypeClass(placeType: string | null): string {
    if (!placeType) return '';

    if (placeType.includes('Champions League')) return 'champions-league';
    if (placeType.includes('Europa League')) return 'europa-league';
    if (placeType.includes('Relegation')) return 'relegation';

    return '';
  }

  /**
   * Check if goal difference is positive
   */
  isPositive(value: string): boolean {
    return parseInt(value) > 0;
  }

  /**
   * Check if goal difference is negative
   */
  isNegative(value: string): boolean {
    return parseInt(value) < 0;
  }
}
