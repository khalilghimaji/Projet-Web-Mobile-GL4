import {
  ApplicationConfig,
  provideAppInitializer,
  inject,
  provideZonelessChangeDetection,
} from '@angular/core';
import { provideRouter } from '@angular/router';
import { routes } from './app.routes';
import { provideAnimations } from '@angular/platform-browser/animations';
import { MessageService } from 'primeng/api';
import { providePrimeNG } from 'primeng/config';
import { MyPreset } from './shared/mytheme';
import {
  HTTP_INTERCEPTORS,
  provideHttpClient,
  withInterceptorsFromDi,
} from '@angular/common/http';
import { CredentialsInterceptor } from './shared/interceptors/credentials.interceptor';
import { AuthInterceptor } from './shared/interceptors/auth.interceptor';
import { catchError, map, of } from 'rxjs';
import { AuthService } from './services/auth.service';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideAnimations(),
    provideZonelessChangeDetection(),
    MessageService,

    // Provide HttpClient with class-based interceptor support
    provideHttpClient(withInterceptorsFromDi()),

    // Register HTTP interceptors
    {
      provide: HTTP_INTERCEPTORS,
      useClass: CredentialsInterceptor,
      multi: true,
    },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true,
    },
    provideAppInitializer(() => {
      const authService = inject(AuthService);
      return authService.getProfile().pipe(
        map((user) => {
          return true;
        }),
        catchError((error) => {
          console.log('error', error);
          return of(false);
        })
      );
    }),

    providePrimeNG({
      theme: {
        preset: MyPreset,
        options: {
          darkModeSelector: '.dark-theme',
        },
      },
    }),
  ],
};
