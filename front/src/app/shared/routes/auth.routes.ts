import { Routes } from '@angular/router';
import { tokenValidationGuard } from '../guards/token-validation.guard';

export const authRoutes: Routes = [
  {
    path: 'signup',
    loadComponent: () =>
      import('../../pages/signup-page/signup-page.component').then(
        (c) => c.SignupPageComponent
      ),
  },
  {
    path: 'login',
    loadComponent: () =>
      import('../../pages/login-page/login-page.component').then(
        (c) => c.LoginPageComponent
      ),
  },
  {
    path: 'verify-email',
    loadComponent: () =>
      import(
        '../../pages/email-verification/email-verification.component'
      ).then((c) => c.EmailVerificationComponent),
  },
  {
    path: 'forget-password',
    loadComponent: () =>
      import('../../pages/forget-password/forget-password.component').then(
        (c) => c.ForgetPasswordComponent
      ),
  },
  {
    path: 'forget-password/reset',
    loadComponent: () =>
      import('../../pages/forget-password/forget-password.component').then(
        (c) => c.ForgetPasswordComponent
      ),
    data: { resetMode: true },
  },
  {
    path: 'mfa-setup',
    canActivate: [tokenValidationGuard],
    loadComponent: () =>
      import('../../pages/mfa-setup/mfa-setup.component').then(
        (c) => c.MfaSetupComponent
      ),
  },
  {
    path: 'auth/callback',
    children: [
      {
        path: '',
        loadComponent: () =>
          import('../../pages/auth-callback/auth-callback.component').then(
            (c) => c.AuthCallbackComponent
          ),
      },
      {
        path: ':provider',
        loadComponent: () =>
          import('../../pages/auth-callback/auth-callback.component').then(
            (c) => c.AuthCallbackComponent
          ),
      },
    ],
  },
];
