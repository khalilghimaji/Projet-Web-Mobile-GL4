import { Injectable, signal, computed, effect, inject } from '@angular/core';
import { Router } from '@angular/router';
import { NotificationService } from './notification.service';
import {
  catchError,
  map,
  Observable,
  of,
  tap,
  throwError,
  timeout,
} from 'rxjs';
import { AuthenticationService, UserDto } from './Api';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  // Dependencies using inject()
  private readonly router = inject(Router);
  private readonly notificationService = inject(NotificationService);
  private readonly apiAuthService = inject(AuthenticationService);

  // Signals for reactive state management
  private readonly _currentUser = signal<UserDto | null>(null);
  private readonly _isRefreshing = signal(false);

  // Public readonly signals
  readonly currentUser = this._currentUser.asReadonly();
  readonly isAuthenticated = computed(() => this._currentUser() !== null);
  readonly hasOtpEnabled = computed(
    () => this._currentUser()?.isMFAEnabled ?? false,
  );
  readonly userEmail = computed(() => this._currentUser()?.email ?? '');
  readonly isRefreshing = this._isRefreshing.asReadonly();

  constructor() {
    this.loadUserState();

    // Effect to sync auth state with localStorage
    effect(() => {
      const user = this._currentUser();
      if (user) {
        this.persistUserState(user);
      }
    });

    // Load profile if authenticated
    if (this.isAuthenticated()) {
      this.getProfile().subscribe({ error: () => this.clearAuthData() });
    }
  }

  private isBrowser(): boolean {
    return typeof window !== 'undefined';
  }

  private loadUserState(): void {
    if (!this.isBrowser()) return;
    const userData = localStorage.getItem('user_data');
    if (userData) {
      try {
        this._currentUser.set(JSON.parse(userData));
      } catch (e) {
        // Invalid JSON in localStorage
      }
    }
  }

  private persistUserState(user: UserDto): void {
    if (!this.isBrowser()) return;
    localStorage.setItem('user_email', user.email || '');
    localStorage.setItem('user_data', JSON.stringify(user));
  }

  generateMfaSecret(): Observable<{ secret: string; qrCode: string }> {
    return this.apiAuthService
      .authControllerGenerateMfaSecret()
      .pipe(
        catchError((error) =>
          this.handleError('Failed to generate MFA secret', error),
        ),
      );
  }

  private handleError(message: string, error: any): Observable<never> {
    this.notificationService.showError(message);
    return throwError(() => error);
  }

  enableMfa(otpCode: string): Observable<{
    success: boolean;
    message: string;
    recoveryCodes: string[];
  }> {
    return this.apiAuthService.authControllerEnableMfa({ code: otpCode }).pipe(
      map((response) => {
        return {
          success: true,
          message: 'MFA enabled successfully',
          recoveryCodes: response.recoveryCodes,
        };
      }),
      catchError((error) => {
        this.notificationService.showError(
          error.error?.message || 'Failed to enable MFA',
        );
        return of({
          success: false,
          message: error.error?.message || 'Failed to enable MFA',
          recoveryCodes: [],
        });
      }),
    );
  }

  disableMfa(
    password: string,
  ): Observable<{ success: boolean; message: string }> {
    return this.apiAuthService.authControllerDisableMfa({ password }).pipe(
      map(() => {
        return { success: true, message: 'MFA disabled successfully' };
      }),
      catchError((error) => {
        this.notificationService.showError(
          error.error?.message || 'Failed to disable MFA',
        );
        return of({
          success: false,
          message: error.error?.message || 'Failed to disable MFA',
        });
      }),
    );
  }

  initiateLogin(
    email: string,
    password: string,
    rememberMe: boolean,
  ): Observable<{ requiresOtp: boolean; message: string; success: boolean }> {
    return this.apiAuthService
      .authControllerLogin({ email, password, rememberMe: rememberMe })
      .pipe(
        map((response) => {
          if ('isMfaRequired' in response) {
            return {
              requiresOtp: true,
              message: 'OTP required to complete login',
              success: false,
            };
          }
          this.setAuthData(response.user);
          return {
            requiresOtp: false,
            message: 'Login successful',
            success: true,
          };
        }),
        catchError((error) => {
          this.notificationService.showError(
            error.error?.message || 'Login failed',
          );
          return of({
            requiresOtp: false,
            message: error.error?.message || 'Login failed',
            success: false,
          });
        }),
      );
  }

  verifyOtp(
    code: string,
    rememberMe: boolean,
  ): Observable<{ success: boolean; message: string }> {
    return this.apiAuthService
      .authControllerVerifyMfaToken({ code, rememberMe })
      .pipe(
        map((response) => {
          if (response.user) {
            this.setAuthData(response.user);
            this.completeLogin();
          }
          return { success: true, message: 'OTP verification successful' };
        }),
        catchError((error) => {
          this.notificationService.showError(
            error.error?.message || 'Invalid OTP code',
          );
          return of({
            success: false,
            message: error.error?.message || 'Invalid OTP code',
          });
        }),
      );
  }

  register(userData: {
    fisrtname: string;
    lastname: string;
    email: string;
    password: string;
    imgUrl?: File;
  }): Observable<{ success: boolean; message: string }> {
    return this.apiAuthService
      .authControllerSignUp(
        userData.fisrtname,
        userData.lastname,
        userData.email,
        userData.password,
        userData.imgUrl,
      )
      .pipe(
        map(() => {
          const message =
            'Registration successful! Please check your email to verify your account.';
          this.notificationService.showSuccess(message);
          return { success: true, message };
        }),
        catchError((error) => {
          this.notificationService.showError(
            error.error?.message || 'Registration failed',
          );
          return of({
            success: false,
            message: error.error?.message || 'Registration failed',
          });
        }),
      );
  }

  verifyEmailToken(
    token: string,
  ): Observable<{ success: boolean; message: string }> {
    return this.apiAuthService.authControllerVerifyEmail({ token }).pipe(
      map(() => {
        this.notificationService.showSuccess('Email verified successfully');
        return { success: true, message: 'Email verified successfully' };
      }),
      catchError((error) => {
        this.notificationService.showError(
          error.error?.message || 'Invalid or expired verification token',
        );
        return of({
          success: false,
          message:
            error.error?.message || 'Invalid or expired verification token',
        });
      }),
    );
  }

  refreshToken(): Observable<any> {
    if (this._isRefreshing()) return of(null);

    this._isRefreshing.set(true);
    return this.apiAuthService.authControllerRefreshToken().pipe(
      tap(() => {
        this._isRefreshing.set(false);
      }),
      catchError((error) => {
        this._isRefreshing.set(false);
        this.clearAuthData();
        return throwError(() => error);
      }),
    );
  }

  completeLogin(): void {
    this.notificationService.showSuccess('Login successful');
    this.router.navigate(['/']);
  }

  setAuthData(userData: UserDto): void {
    if (!this.isBrowser() || !userData) return;
    this._currentUser.set(userData);
  }

  public clearAuthData(): void {
    if (this.isBrowser()) {
      ['user_data', 'user_email'].forEach((key) =>
        localStorage.removeItem(key),
      );
    }
    this._currentUser.set(null);
  }

  logout() {
    this.apiAuthService
      .authControllerLogout()
      .pipe(
        timeout(5000),
        catchError(() => of(null)),
      )
      .subscribe(() => {
        this.clearAuthData();
        this.notificationService.showSuccess(
          'You have been successfully logged out',
        );
        setTimeout(() => this.router.navigate(['/login']), 10);
      });
  }

  getProfile(): Observable<UserDto> {
    return this.apiAuthService.authControllerGetProfile().pipe(
      tap((user) => {
        if (user) this.setAuthData(user);
      }),
    );
  }

  forgotPassword(
    email: string,
  ): Observable<{ success: boolean; message: string }> {
    return this.apiAuthService.authControllerForgotPassword({ email }).pipe(
      map((response) => {
        this.notificationService.showSuccess(
          'Password reset email sent. Please check your inbox.',
        );
        return { success: true, message: response.message };
      }),
      catchError((error) => {
        this.notificationService.showError(
          error.error?.message || 'Failed to request password reset',
        );
        return of({
          success: false,
          message: error.error?.message || 'Failed to request password reset',
        });
      }),
    );
  }

  resetPassword(
    token: string,
    password: string,
  ): Observable<{ success: boolean; message: string }> {
    return this.apiAuthService
      .authControllerResetPassword({ token, password })
      .pipe(
        map((response) => {
          this.notificationService.showSuccess(
            'Password reset successful. You can now log in with your new password.',
          );
          return { success: true, message: response.message };
        }),
        catchError((error) => {
          this.notificationService.showError(
            error.error?.message || 'Failed to reset password',
          );
          return of({
            success: false,
            message: error.error?.message || 'Failed to reset password',
          });
        }),
      );
  }
}
