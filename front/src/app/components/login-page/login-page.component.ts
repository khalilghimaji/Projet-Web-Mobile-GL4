import { Component, signal, inject } from '@angular/core';

import {
  FormBuilder,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { RouterModule } from '@angular/router';
import { InputTextModule } from 'primeng/inputtext';
import { ButtonModule } from 'primeng/button';
import { RippleModule } from 'primeng/ripple';
import { AuthService } from '../../services/auth.service';
import { MessageModule } from 'primeng/message';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { environment } from '../../../environments/environment';
import { CheckboxModule } from 'primeng/checkbox';

@Component({
  selector: 'app-login-page',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    RouterModule,
    InputTextModule,
    ButtonModule,
    RippleModule,
    MessageModule,
    ProgressSpinnerModule,
    CheckboxModule
],
  templateUrl: './login-page.component.html',
  styleUrl: './login-page.component.css',
})
export class LoginPageComponent {
  private readonly fb = inject(FormBuilder);
  private readonly authService = inject(AuthService);

  isLoading = signal(false);
  requiresOtp = signal(false);
  showOtpStep = signal(false);
  errorMessage = signal('');

  loginForm = this.fb.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', Validators.required],
    rememberMe: [false],
  });

  otpForm = this.fb.group({
    otpCode: [
      '',
      [
        Validators.required,
        Validators.minLength(6),
        Validators.maxLength(6),
        Validators.pattern('^[0-9]*$'),
      ],
    ],
  });

  onLogin() {
    if (!this.loginForm.valid) {
      this.loginForm.markAllAsTouched();
      return;
    }

    const { email, password, rememberMe } = this.loginForm.value;
    this.isLoading.set(true);
    this.errorMessage.set('');

    this.authService.initiateLogin(email!, password!, rememberMe!).subscribe({
      next: (response) => {
        this.isLoading.set(false);
        if (response.requiresOtp) {
          this.showOtpStep.set(true);
          this.requiresOtp.set(true);
        } else if (response.success) {
          this.authService.completeLogin();
        } else {
          this.errorMessage.set(response.message);
        }
      },
      error: (error) => {
        this.isLoading.set(false);
        this.errorMessage.set(
          error.message || 'Login failed. Please try again.'
        );
      },
    });
  }

  onVerifyOtp() {
    if (!this.otpForm.valid) {
      this.otpForm.markAllAsTouched();
      return;
    }

    const { otpCode } = this.otpForm.value;
    this.isLoading.set(true);
    this.errorMessage.set('');

    this.authService
      .verifyOtp(otpCode!, this.loginForm.controls['rememberMe'].value!)
      .subscribe({
        next: (response) => {
          this.isLoading.set(false);
          if (!response.success) {
            this.errorMessage.set(response.message);
          }
        },
        error: (error) => {
          this.isLoading.set(false);
          this.errorMessage.set(
            error.message || 'OTP verification failed. Please try again.'
          );
        },
      });
  }

  backToLogin() {
    this.showOtpStep.set(false);
    this.requiresOtp.set(false);
    this.otpForm.reset();
    this.errorMessage.set('');
  }

  loginWithGoogle() {
    const apiUrl = environment.apiUrl;
    window.location.href = `${apiUrl}/auth/google`;
  }

  loginWithGithub() {
    const apiUrl = environment.apiUrl;
    window.location.href = `${apiUrl}/auth/github`;
  }
}
