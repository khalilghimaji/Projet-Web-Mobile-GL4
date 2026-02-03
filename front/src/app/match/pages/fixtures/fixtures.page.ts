import { Component, ChangeDetectionStrategy, signal, computed, inject, viewChild, ElementRef, DestroyRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { FixturesResourceFactory } from '../../services/fixtures-resource.factory';
import { FixtureCardComponent } from '../../components/fixture-card/fixture-card.component';
import { LeagueFilterChipComponent } from '../../components/league-filter-chip/league-filter-chip.component';
import { LeagueSearchComponent } from '../../components/league-search/league-search.component';
import { ParsedFixture, DateTab, FixturesByLeague, FixtureStatus, League } from '../../types/fixture.types';
import { fromEvent, of } from 'rxjs';
import { switchMap, filter, map } from 'rxjs/operators';
import { takeUntilDestroyed, toObservable } from '@angular/core/rxjs-interop';
import { FixturesApiService } from '../../services/fixtures-api.service';

@Component({
  selector: 'app-fixtures',
  standalone: true,
  imports: [
    CommonModule,
    RouterLink,
    FixtureCardComponent,
    LeagueFilterChipComponent,
    LeagueSearchComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './fixtures.page.html',
  styleUrls: ['./fixtures.page.css']
})
export class FixturesPage {
  private router = inject(Router);
  private fixturesFactory = inject(FixturesResourceFactory);
  private fixturesApi = inject(FixturesApiService);
  private destroyRef = inject(DestroyRef);

  // ViewChild references
  dateTabsContainerRef = viewChild<ElementRef>('dateTabsContainer');

  // Date & League selection state
  selectedDate = signal<Date>(new Date());
  selectedLeagueId = signal<string>('all');
  dateTabs = signal<DateTab[]>(this.generateDateTabs());

  allLeagues = signal<League[]>([]);


  private fixturesRequest = computed(() => {
    const from = this.formatDate(this.selectedDate());
    const to = this.formatDate(this.selectedDate());
    const leagueId = this.selectedLeagueId();

    console.log('Fixtures request updated:', { from, to, leagueId });

    return {
      from,
      to,
      leagueId: leagueId !== 'all' ? leagueId : undefined
    };
  });

  private fixturesStore = this.fixturesFactory.create(this.fixturesRequest);
  private leaguesStore = this.fixturesFactory.createFeaturedLeaguesResource();

  private rawFixtures = this.fixturesStore.fixtures;
  topLeagues = this.leaguesStore.leagues;
  fixturesResource = {
    value: this.fixturesStore.fixtures,
    isLoading: this.fixturesStore.resource.isLoading,
    hasError: computed(() => this.fixturesStore.resource.status() === 'error'),
    error: this.fixturesStore.resource.error
  };

  parsedFixtures = computed(() => {
    return this.rawFixtures().map(f => this.parseFixture(f));
  });

  fixturesByLeague = computed(() => {
    const fixtures = this.parsedFixtures();
    const selectedLeague = this.selectedLeagueId();

    if (selectedLeague !== 'all') {
      return fixtures.length > 0 ? [{
        league: {
          league_key: fixtures[0].league_key,
          league_name: fixtures[0].league_name,
          league_logo: fixtures[0].league_logo,
          country_name: fixtures[0].country_name
        },
        fixtures
      }] : [];
    }

    const grouped = new Map<string, FixturesByLeague>();

    fixtures.forEach(fixture => {
      if (!grouped.has(fixture.league_key)) {
        grouped.set(fixture.league_key, {
          league: {
            league_key: fixture.league_key,
            league_name: fixture.league_name,
            league_logo: fixture.league_logo,
            country_name: fixture.country_name
          },
          fixtures: []
        });
      }
      grouped.get(fixture.league_key)!.fixtures.push(fixture);
    });

    return Array.from(grouped.values());
  });

  constructor() {
    this.fixturesApi.getAllLeagues()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe(leagues => {
        this.allLeagues.set(leagues);
        console.log(`Loaded ${leagues.length} leagues for search`);
      });



    // Optimisation fromEvent pour date selection
    toObservable(this.dateTabsContainerRef)
      .pipe(
        switchMap((ref) => {
          if (!ref?.nativeElement) return of(null);
          return fromEvent<MouseEvent>(ref.nativeElement, 'click').pipe(
            takeUntilDestroyed(this.destroyRef)
          );
        }),
        filter((event): event is MouseEvent => event !== null),
        map((event) => {
          const target = event.target as HTMLElement;
          const button = target.closest('.date-tab-button') as HTMLElement;
          if (!button) return null;
          const dateStr = button.getAttribute('data-date');
          return dateStr ? new Date(dateStr) : null;
        }),
        filter((date): date is Date => date !== null)
      )
      .subscribe((date) => {
        this.onDateSelected(date);
      });
  }

  onDateSelected(date: Date): void {
    console.log('Date selected:', date.toDateString());
    this.selectedDate.set(date);
  }

  onLeagueSelected(leagueId: string): void {
    console.log('League selected:', leagueId);
    this.selectedLeagueId.set(leagueId);
  }

  onFixtureClicked(eventKey: string): void {
    console.log('Navigating to match:', eventKey);
    this.router.navigate(['/match', eventKey]);
  }




  onLeagueSearchSelected(league: League): void {
    console.log('League selected from search:', league.league_name);
    this.selectedLeagueId.set(league.league_key);
  }

  onClearFilter(): void {
    console.log('Clearing league filter - showing all leagues');
    this.selectedLeagueId.set('all');
  }

  isSelected(tab: DateTab): boolean {
    return tab.date.toDateString() === this.selectedDate().toDateString();
  }

  private generateDateTabs(): DateTab[] {
    const today = new Date();
    const tabs: DateTab[] = [];

    for (let i = -2; i <= 2; i++) {
      const date = new Date(today);
      date.setDate(today.getDate() + i);

      tabs.push({
        date,
        dayName: this.getDayName(date),
        dayNumber: date.getDate(),
        isToday: i === 0
      });
    }

    return tabs;
  }

  private getDayName(date: Date): string {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.getDay()];
  }

  private formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  private parseFixture(fixture: any): ParsedFixture {
    let parsedStatus: FixtureStatus = 'SCHEDULED';
    let minute: number | undefined;
    let homeScore: number | undefined;
    let awayScore: number | undefined;

    if (fixture.event_live === '1') {
      if (fixture.event_status === 'Half Time') {
        parsedStatus = 'HALFTIME';
      } else {
        parsedStatus = 'LIVE';
        const statusMinute = this.parseMinuteString(fixture.event_status);
        minute = statusMinute > 0 ? statusMinute : this.inferMinuteFromFixture(fixture);
      }
    } else if (fixture.event_status === 'Finished') {
      parsedStatus = 'FINISHED';
    }

    if (fixture.event_final_result && fixture.event_final_result !== '') {
      const [home, away] = fixture.event_final_result
        .split('-')
        .map((s: string) => parseInt(s.trim()));
      homeScore = home;
      awayScore = away;
    }

    return {
      ...fixture,
      parsedStatus,
      minute,
      homeScore,
      awayScore
    };
  }

  getCurrentMonthYear(): string {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const date = this.selectedDate();
    return `${months[date.getMonth()]} ${date.getFullYear()}`;
  }

  private inferMinuteFromFixture(fixture: any): number {
    const allEvents = [
      ...(fixture.goalscorers || []),
      ...(fixture.cards || []),
      ...(fixture.substitutes || []),
    ];

    if (allEvents.length === 0) {
      const statusMinute = parseInt(fixture.event_status);
      return isNaN(statusMinute) ? 1 : statusMinute;
    }

    let maxMinute = 0;
    for (const event of allEvents) {
      const timeStr = event.time || '';
      const minute = this.parseMinuteString(timeStr);
      if (minute > maxMinute) {
        maxMinute = minute;
      }
    }
    return maxMinute;
  }

  private parseMinuteString(timeStr: string): number {
    if (!timeStr) return 0;

    if (timeStr.includes('+')) {
      const [base, added] = timeStr.split('+');
      return (parseInt(base) || 0) + (parseInt(added) || 0);
    }
    return parseInt(timeStr) || 0;
  }
}
