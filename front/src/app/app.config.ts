import {
  ApplicationConfig,
  provideAppInitializer,
  inject,
  provideZonelessChangeDetection,
} from '@angular/core';
import {
  provideRouter,
  withComponentInputBinding,
  withPreloading,
} from '@angular/router';
import { routes } from './app.routes';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
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
import { ApiKeyInterceptor } from './shared/interceptors/apikey.interceptor';
import { catchError, EMPTY } from 'rxjs';
import { AuthService } from './auth/services/auth.service';
import { CustomPreloadStrategy } from './shared/custom-preload.strategy';

export const appConfig: ApplicationConfig = {
  providers: [
    provideAnimationsAsync(),
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
    {
      provide: HTTP_INTERCEPTORS,
      useClass: ApiKeyInterceptor,
      multi: true,
    },
    // Use provideAppInitializer for auth initialization
    provideAppInitializer(() => {
      const authService = inject(AuthService);
      return authService.getProfile().pipe(
        catchError(() => {
          return EMPTY;
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

    provideRouter(
      routes,
      withComponentInputBinding(),
      withPreloading(CustomPreloadStrategy)
    ),
  ],
};
