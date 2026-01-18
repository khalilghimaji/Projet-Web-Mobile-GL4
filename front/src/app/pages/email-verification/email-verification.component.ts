import {
  ChangeDetectionStrategy,
  Component,
  OnInit,
  signal,
  input,
  effect,
  linkedSignal,
} from '@angular/core';

import { RouterModule } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { ButtonModule } from 'primeng/button';
import { MessageModule } from 'primeng/message';

@Component({
  selector: 'app-email-verification',
  standalone: true,
  imports: [RouterModule, ProgressSpinnerModule, ButtonModule, MessageModule],
  templateUrl: './email-verification.component.html',
  styleUrl: './email-verification.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class EmailVerificationComponent {
  token = input<string | null>(null);

  isVerified = signal(false);
  isLoading = linkedSignal(() => {
    if (!this.token()) return false;
    return true;
  });
  errorMessage = linkedSignal<string>(() => {
    if (!this.token()) return 'Verification token is missing.'
    return ''
  });

  constructor(private authService: AuthService) {
    effect(() => {
      if (this.token()) {
        this.verifyEmailToken();
      }
    });
  }

  protected verifyEmailToken(): void {
    this.isLoading.set(true);

    this.authService.verifyEmailToken(this.token()!).subscribe({
      next: (response) => {
        this.isLoading.set(false);
        if (response.success) {
          this.isVerified.set(true);
        } else {
          this.errorMessage.set(
            response.message || 'Email verification failed.',
          );
        }
      },
      error: (error) => {
        this.isLoading.set(false);
        this.errorMessage.set(
          error.message ||
            'An error occurred during email verification. Please try again.',
        );
      },
    });
  }
}
