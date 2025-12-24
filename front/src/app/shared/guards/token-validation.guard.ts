import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { Observable, of } from 'rxjs';
import { catchError, map, take } from 'rxjs/operators';


/**
 * Guard to validate authentication tokens before allowing route access.
 * Uses local state check first, then validates with backend if needed.
 * Token refresh is handled automatically by AuthInterceptor on 401 errors.
 */
export const tokenValidationGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  // Quick check: if user is authenticated locally, allow access
  // The interceptor will handle token refresh if needed on subsequent API calls
  if (authService.isAuthenticated()) {
    return of(true);
  }

  // User is not authenticated locally, verify with backend
  return authService.getProfile().pipe(
    take(1),
    map(() => true),
    catchError(() => {
      // Profile request failed - redirect to login
      // The interceptor will have already attempted token refresh on 401
      router.navigate(['/login'], {
        queryParams: { redirectUrl: state.url },
      });
      return of(false);
    })
  );
};
