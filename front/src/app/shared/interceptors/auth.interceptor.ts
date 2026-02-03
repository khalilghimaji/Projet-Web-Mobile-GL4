import { Injectable, Injector } from '@angular/core';
import {
  HttpErrorResponse,
  HttpEvent,
  HttpHandler,
  HttpInterceptor,
  HttpRequest,
} from '@angular/common/http';
import { BehaviorSubject, Observable, throwError } from 'rxjs';
import { catchError, filter, switchMap, take, finalize } from 'rxjs/operators';
import { AuthService } from '../../auth/services/auth.service';
import { environment } from '../../../environments/environment';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  private isRefreshing = false;
  private refreshTokenSubject = new BehaviorSubject<boolean>(false);

  constructor(private injector: Injector) {}

  private get authService(): AuthService {
    return this.injector.get(AuthService);
  }

  intercept(
    request: HttpRequest<unknown>,
    next: HttpHandler
  ): Observable<HttpEvent<unknown>> {
    // Skip non-API requests and auth endpoints
    if (
      !request.url.startsWith(environment.apiUrl) ||
      this.isAuthEndpoint(request.url)
    ) {
      return next.handle(request);
    }

    return next.handle(request).pipe(
      catchError((error) => {
        if (error instanceof HttpErrorResponse && error.status === 401) {
          return this.handle401Error(request, next);
        }
        return throwError(() => error);
      })
    );
  }

  private isAuthEndpoint(url: string): boolean {
    const authEndpoints = [
      '/auth/login',
      '/auth/signup',
      '/auth/refresh',
      '/auth/verify-email',
      '/auth/mfa/verify',
    ];
    return authEndpoints.some((endpoint) => url.includes(endpoint));
  }

  private handle401Error(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    if (!this.isRefreshing) {
      this.isRefreshing = true;
      this.refreshTokenSubject.next(false);

      return this.authService.refreshToken().pipe(
        switchMap(() => {
          this.refreshTokenSubject.next(true);
          return next.handle(request);
        }),
        catchError((err) => {
          this.authService.clearAuthData();
          return throwError(() => err);
        }),
        finalize(() => {
          this.isRefreshing = false;
        })
      );
    }

    // Wait for token refresh to complete
    return this.refreshTokenSubject.pipe(
      filter((refreshed) => refreshed === true),
      take(1),
      switchMap(() => next.handle(request))
    );
  }
}
