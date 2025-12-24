import {
  ApplicationConfig,
  provideAppInitializer,
  inject,
} from '@angular/core';
import { provideRouter } from '@angular/router';
import { routes } from './app.routes';
import { provideClientHydration } from '@angular/platform-browser';
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
import { AuthInitializationService } from './services/auth-initialization.service';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideClientHydration(),
    provideAnimations(),
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
    // Use provideAppInitializer for auth initialization
    provideAppInitializer(() => {
      const authInitService = inject(AuthInitializationService);
      authInitService.initializeAuth();
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
