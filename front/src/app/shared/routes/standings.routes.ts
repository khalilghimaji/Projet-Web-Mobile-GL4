import { Routes } from '@angular/router';

export const STANDINGS_ROUTE: Routes = [
  {
    path: ':leagueId',
    loadComponent: () =>
      import(
        '../../standings/pages/league-standings/league-standings.component'
      ).then((c) => c.LeagueStandingsComponent),
  },
  {
    path: '',
    loadComponent: () =>
      import('../../standings/pages/leagues-list/leagues-list.component').then(
        (c) => c.LeaguesListComponent
      ),
  },
];
