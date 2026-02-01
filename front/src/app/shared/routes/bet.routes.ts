import { Routes } from '@angular/router';
import { tokenValidationGuard } from '../guards/token-validation.guard';

export const betRoutes: Routes = [
  {
    path: 'notifications',
    canActivate: [tokenValidationGuard],
    data: { preload: true },
    loadComponent: () =>
      import('../../notifications/pages/NotificationPage/notifications-page.component').then(
        (c) => c.NotificationsPageComponent
      ),
  },
  {
    path: 'diamond-store',
    canActivate: [tokenValidationGuard],
    loadComponent: () =>
      import('../../rankings/pages/diamond-store/diamond-store.component').then(
        (c) => c.DiamondStoreComponent
      ),
  },
  {
    path: 'rankings',
    canActivate: [tokenValidationGuard],
    data: { preload: true },
    loadComponent: () =>
      import('../../rankings/pages/ranking-page/ranking-page.component').then(
        (c) => c.RankingPageComponent
      ),
  },
];
