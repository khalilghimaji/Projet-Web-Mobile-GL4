import { Routes } from '@angular/router';
import { tokenValidationGuard } from './shared/guards/token-validation.guard';

export const routes: Routes = [
  {
    path: 'login',
    loadComponent: () =>
      import('./components/login-page/login-page.component').then(
        (c) => c.LoginPageComponent
      ),
  },
  {
    path: 'match/:matchId',
    loadComponent: () =>
      import('./match/pages/match-detail/match-detail.page')
        .then(m => m.MatchDetailPage),
  },
  {
    path: 'signup',
    loadComponent: () =>
      import('./components/signup-page/signup-page.component').then(
        (c) => c.SignupPageComponent
      ),
  },
  {
    path: 'verify-email',
    loadComponent: () =>
      import(
        './components/email-verification/email-verification.component'
      ).then((c) => c.EmailVerificationComponent),
  },
  {
    path: 'forget-password',
    loadComponent: () =>
      import('./components/forget-password/forget-password.component').then(
        (c) => c.ForgetPasswordComponent
      ),
  },
  {
    path: 'forget-password/reset',
    loadComponent: () =>
      import('./components/forget-password/forget-password.component').then(
        (c) => c.ForgetPasswordComponent
      ),
    data: { resetMode: true },
  },
  {
    path: 'mfa-setup',
    canActivate: [tokenValidationGuard],
    loadComponent: () =>
      import('./components/mfa-setup/mfa-setup.component').then(
        (c) => c.MfaSetupComponent
      ),
  },
  {
    path: 'auth/callback',
    loadComponent: () =>
      import('./components/auth-callback/auth-callback.component').then(
        (c) => c.AuthCallbackComponent
      ),
  },
  {
    path: 'auth/callback/:provider',
    loadComponent: () =>
      import('./components/auth-callback/auth-callback.component').then(
        (c) => c.AuthCallbackComponent
      ),
  },
  {
    path: 'notifications',
    canActivate: [tokenValidationGuard],
    loadComponent: () =>
      import('./components/NotificationPage/notifications-page.component').then(
        (c) => c.NotificationsPageComponent
      ),
  },
  {
    path: 'diamond-store',
    canActivate: [tokenValidationGuard],
    loadComponent: () =>
      import('./components/diamond-store/diamond-store.component').then(
        (c) => c.DiamondStoreComponent
      ),
  },
  {
    path: 'error',
    loadComponent: () =>
      import('./components/error-page/error-page.component').then(
        (c) => c.ErrorPageComponent
      ),
  },
  {
    path: 'error/:code',
    loadComponent: () =>
      import('./components/error-page/error-page.component').then(
        (c) => c.ErrorPageComponent
      ),
  },
  // Wildcard route for 404 - this should be the last route
  {
    path: '**',
    loadComponent: () =>
      import('./components/error-page/error-page.component').then(
        (c) => c.ErrorPageComponent
      ),
    data: { errorCode: 404 },
  },
];
