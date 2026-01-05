import { Component, Input, inject, computed, signal, input } from '@angular/core';
import { CommonModule, DatePipe } from '@angular/common';
import { StandingsService } from '../../services/standings.service';
import { StandingEntry } from '../../models/models';
import { LoadingComponent } from '../loading/loading.component';
import { Router } from '@angular/router';


@Component({
  selector: 'app-league-standings',
  standalone: true,
  imports: [CommonModule, LoadingComponent, DatePipe],
  templateUrl: './league-standings.component.html',
  styleUrl: './league-standings.component.css',
})
export class LeagueStandingsComponent {

  leagueId = input.required<string>();
  standingsService = inject(StandingsService);
  router = inject(Router);

  selectedView = signal<'total' | 'home' | 'away'>('total');

  standingsRes = this.standingsService.getStandingsResource(() => this.leagueId());

  currentStandings = computed(() => {
    const data = this.standingsRes.value();
    if (!data) return [] as StandingEntry[];

    return data.result[this.selectedView()];
  });

  setView(view: 'total' | 'home' | 'away') {
    this.selectedView.set(view);
  }

  backToLeagues() {
    this.router.navigate(['/standings']);
  }

  isPositive = (val: string) => parseInt(val) > 0;
  isNegative = (val: string) => parseInt(val) < 0;
}
