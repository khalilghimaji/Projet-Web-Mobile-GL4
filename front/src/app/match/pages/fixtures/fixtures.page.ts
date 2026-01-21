import { Component, ChangeDetectionStrategy, signal, computed, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { FixturesResourceFactory } from '../../services/fixtures-resource.factory';
import { FixtureCardComponent } from '../../components/fixture-card/fixture-card.component';
import { LeagueFilterChipComponent } from '../../components/league-filter-chip/league-filter-chip.component';
import { ParsedFixture, DateTab, FixturesByLeague, FixtureStatus } from '../../types/fixture.types';

@Component({
  selector: 'app-fixtures',
  standalone: true,
  imports: [
    CommonModule,
    RouterLink,
    FixtureCardComponent,
    LeagueFilterChipComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './fixtures.page.html',
  styleUrls: ['./fixtures.page.css']
})
export class FixturesPage {
  private router = inject(Router);
  private fixturesFactory = inject(FixturesResourceFactory);

  selectedDate = signal<Date>(new Date());
  selectedLeagueId = signal<string>('all');
  dateTabs = signal<DateTab[]>(this.generateDateTabs());

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
      parsedStatus = 'LIVE';
      minute = parseInt(fixture.event_status);
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
}
