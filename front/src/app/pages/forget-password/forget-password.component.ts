import {
  Component,
  signal,
  inject,
  ChangeDetectionStrategy,
  input,
  computed,
} from '@angular/core';

import {
  AbstractControl,
  FormBuilder,
  ReactiveFormsModule,
  ValidationErrors,
  ValidatorFn,
  Validators,
} from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { InputTextModule } from 'primeng/inputtext';
import { ButtonModule } from 'primeng/button';
import { MessageModule } from 'primeng/message';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-forget-password',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    RouterModule,
    InputTextModule,
    ButtonModule,
    MessageModule,
  ],
  templateUrl: './forget-password.component.html',
  styleUrl: './forget-password.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ForgetPasswordComponent {
  private readonly fb = inject(FormBuilder);
  private readonly router = inject(Router);
  private readonly authService = inject(AuthService);

  isLoading = signal(false);
  errorMessage = signal('');
  token = input<string | null>(null);
  currentStep = computed<'email' | 'reset'>(() => {
    return this.token() ? 'reset' : 'email';
  });
  successMessage = signal('');

  forgetPasswordForm = this.fb.group(
    {
      email: ['', [Validators.required, Validators.email]],
      newPassword: ['', [Validators.required, Validators.minLength(8)]],
      confirmPassword: ['', Validators.required],
    },
    { validators: this.passwordMatchValidator() }
  );

  private passwordMatchValidator(): ValidatorFn {
    return (group: AbstractControl): ValidationErrors | null => {
      const password = group.get('newPassword')?.value;
      const confirm = group.get('confirmPassword')?.value;
      return password && confirm && password !== confirm
        ? { passwordMismatch: true }
        : null;
    };
  }

  private isEmailStepValid(): boolean {
    return this.forgetPasswordForm.get('email')?.valid ?? false;
  }

  private isResetStepValid(): boolean {
    const tokenValid = !!this.token();
    const passwordValid = this.forgetPasswordForm.get('newPassword')?.valid;
    const confirmValid = this.forgetPasswordForm.get('confirmPassword')?.valid;
    const noMismatch = !this.forgetPasswordForm.hasError('passwordMismatch');
    return !!(tokenValid && passwordValid && confirmValid && noMismatch);
  }

  onSubmit() {
    this.errorMessage.set('');
    this.successMessage.set('');

    if (this.currentStep() === 'email' && this.isEmailStepValid()) {
      this.handleEmailSubmit();
    } else if (this.currentStep() === 'reset' && this.isResetStepValid()) {
      this.handleResetSubmit();
    }
  }

  private handleEmailSubmit() {
    this.isLoading.set(true);
    const email = this.forgetPasswordForm.get('email')?.value;

    this.authService.forgotPassword(email!).subscribe({
      next: (response) => {
        this.isLoading.set(false);
        response.success
          ? this.successMessage.set(
              'Password reset instructions have been sent to your email.'
            )
          : this.errorMessage.set(response.message);
      },
      error: (error) => {
        this.isLoading.set(false);
        this.errorMessage.set(
          error.error?.message ||
            'Failed to send reset email. Please try again.'
        );
      },
    });
  }

  private handleResetSubmit() {
    this.isLoading.set(true);
    const token = this.token();
    const password = this.forgetPasswordForm.get('newPassword')?.value;

    this.authService.resetPassword(token!, password!).subscribe({
      next: (response) => {
        this.isLoading.set(false);
        if (response.success) {
          this.successMessage.set('Password reset successful!');
          setTimeout(() => this.router.navigate(['/login']), 2000);
        } else {
          this.errorMessage.set(response.message);
        }
      },
      error: (error) => {
        this.isLoading.set(false);
        this.errorMessage.set(
          error.error?.message || 'Failed to reset password. Please try again.'
        );
      },
    });
  }
}
