import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { NotificationService } from './notification.service';
import {
  BehaviorSubject,
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
  // Track authentication state
  private authState = new BehaviorSubject<boolean>(false);
  public authState$ = this.authState.asObservable();
  private currentUser = new BehaviorSubject<UserDto | null>(null);
  public currentUser$ = this.currentUser.asObservable();

  // Token refresh
  private isRefreshing = false;

  constructor(
    private router: Router,
    private notificationService: NotificationService,
    private apiAuthService: AuthenticationService
  ) {
    this.loadUserState();
    if (this.isAuthenticated()) {
      this.authState.next(true);
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
        this.currentUser.next(JSON.parse(userData));
      } catch (e) {}
    }
  }

  // Check if a user has MFA enabled
  hasOtpEnabled(): boolean {
    return this.currentUser.value?.isMFAEnabled || false;
  }

  generateMfaSecret(): Observable<{ secret: string; qrCode: string }> {
    return this.apiAuthService
      .authControllerGenerateMfaSecret()
      .pipe(
        catchError((error) =>
          this.handleError('Failed to generate MFA secret', error)
        )
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
          error.error?.message || 'Failed to enable MFA'
        );
        return of({
          success: false,
          message: error.error?.message || 'Failed to enable MFA',
          recoveryCodes: [],
        });
      })
    );
  }

  disableMfa(
    password: string
  ): Observable<{ success: boolean; message: string }> {
    return this.apiAuthService.authControllerDisableMfa({ password }).pipe(
      map(() => {
        return { success: true, message: 'MFA disabled successfully' };
      }),
      catchError((error) => {
        this.notificationService.showError(
          error.error?.message || 'Failed to disable MFA'
        );
        return of({
          success: false,
          message: error.error?.message || 'Failed to disable MFA',
        });
      })
    );
  }

  initiateLogin(
    email: string,
    password: string,
    rememberMe: boolean
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
            error.error?.message || 'Login failed'
          );
          return of({
            requiresOtp: false,
            message: error.error?.message || 'Login failed',
            success: false,
          });
        })
      );
  }

  verifyOtp(
    code: string,
    rememberMe: boolean
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
            error.error?.message || 'Invalid OTP code'
          );
          return of({
            success: false,
            message: error.error?.message || 'Invalid OTP code',
          });
        })
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
        userData.imgUrl
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
            error.error?.message || 'Registration failed'
          );
          return of({
            success: false,
            message: error.error?.message || 'Registration failed',
          });
        })
      );
  }

  verifyEmailToken(
    token: string
  ): Observable<{ success: boolean; message: string }> {
    return this.apiAuthService.authControllerVerifyEmail({ token }).pipe(
      map(() => {
        this.notificationService.showSuccess('Email verified successfully');
        return { success: true, message: 'Email verified successfully' };
      }),
      catchError((error) => {
        this.notificationService.showError(
          error.error?.message || 'Invalid or expired verification token'
        );
        return of({
          success: false,
          message:
            error.error?.message || 'Invalid or expired verification token',
        });
      })
    );
  }

  // Resend verification email - mock implementation until API supports it
  resendVerificationEmail(
    email: string
  ): Observable<{ success: boolean; message: string }> {
    // This is still mocked as it seems this endpoint might not exist yet
    return of({
      success: true,
      message: 'Verification email has been sent to ' + email,
    });
  }

  refreshToken(): Observable<any> {
    if (this.isRefreshing) return of(null);

    this.isRefreshing = true;
    return this.apiAuthService.authControllerRefreshToken().pipe(
      tap(() => {
        this.isRefreshing = false;
        this.authState.next(true);
      }),
      catchError((error) => {
        this.isRefreshing = false;
        this.clearAuthData();
        this.authState.next(false);
        return throwError(() => error);
      })
    );
  }
  completeLogin(): void {
    this.authState.next(true);
    this.notificationService.showSuccess('Login successful');
    this.router.navigate(['/']);
  }

  isAuthenticated(): boolean {
    return this.isBrowser() && !!localStorage.getItem('user_email');
  }

  setAuthData(userData: UserDto): void {
    if (!this.isBrowser() || !userData) return;

    localStorage.setItem('user_email', userData.email || '');
    localStorage.setItem('user_data', JSON.stringify(userData));
    this.currentUser.next(userData);
    this.authState.next(true);
  }

  public clearAuthData(): void {
    if (this.isBrowser()) {
      ['user_data', 'user_email'].forEach((key) =>
        localStorage.removeItem(key)
      );
    }
    this.currentUser.next(null);
  }

  logout() {
    this.apiAuthService
      .authControllerLogout()
      .pipe(
        timeout(5000),
        catchError(() => of(null))
      )
      .subscribe(() => {
        this.clearAuthData();
        this.authState.next(false);
        this.notificationService.showSuccess(
          'You have been successfully logged out'
        );
        setTimeout(() => this.router.navigate(['/login']), 10);
      });
  }

  getProfile(): Observable<UserDto> {
    return this.apiAuthService.authControllerGetProfile().pipe(
      tap((user) => {
        if (user) this.setAuthData(user);
      })
    );
  }

  forgotPassword(
    email: string
  ): Observable<{ success: boolean; message: string }> {
    return this.apiAuthService.authControllerForgotPassword({ email }).pipe(
      map((response) => {
        this.notificationService.showSuccess(
          'Password reset email sent. Please check your inbox.'
        );
        return { success: true, message: response.message };
      }),
      catchError((error) => {
        this.notificationService.showError(
          error.error?.message || 'Failed to request password reset'
        );
        return of({
          success: false,
          message: error.error?.message || 'Failed to request password reset',
        });
      })
    );
  }

  resetPassword(
    token: string,
    password: string
  ): Observable<{ success: boolean; message: string }> {
    return this.apiAuthService
      .authControllerResetPassword({ token, password })
      .pipe(
        map((response) => {
          this.notificationService.showSuccess(
            'Password reset successful. You can now log in with your new password.'
          );
          return { success: true, message: response.message };
        }),
        catchError((error) => {
          this.notificationService.showError(
            error.error?.message || 'Failed to reset password'
          );
          return of({
            success: false,
            message: error.error?.message || 'Failed to reset password',
          });
        })
      );
  }
}
