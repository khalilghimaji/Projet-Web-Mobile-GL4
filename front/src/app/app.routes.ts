import { Routes } from '@angular/router';
import { authRoutes } from './shared/routes/auth.routes';
import { betRoutes } from './shared/routes/bet.routes';
import { STANDINGS_ROUTE } from './shared/routes/standings.routes';

export const routes: Routes = [
  ...authRoutes,
  ...betRoutes,
  { path: 'standings', children: STANDINGS_ROUTE },
  {
    path: 'match/:id',
    loadComponent: () =>
      import('./match/pages/match-detail/match-detail.page').then(
        (m) => m.MatchDetailPage
      ),
  },
  {
    path: 'team/:id',
    loadComponent: () =>
      import('./components/team-detail-page/team-detail-page.component').then(
        (c) => c.TeamDetailPageComponent
      ),
  },

  {
    path: 'error',
    children: [
      {
        path: '',
        loadComponent: () =>
          import('./pages/error-page/error-page.component').then(
            (c) => c.ErrorPageComponent
          ),
      },
      {
        path: ':code',
        loadComponent: () =>
          import('./pages/error-page/error-page.component').then(
            (c) => c.ErrorPageComponent
          ),
      },
    ],
  },
  {
    path: '**',
    loadComponent: () =>
      import('./pages/error-page/error-page.component').then(
        (c) => c.ErrorPageComponent
      ),
    data: { errorCode: 404 },
  },
];
