import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { ButtonModule } from 'primeng/button';
import { MessageModule } from 'primeng/message';

@Component({
  selector: 'app-email-verification',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    ProgressSpinnerModule,
    ButtonModule,
    MessageModule,
  ],
  templateUrl: './email-verification.component.html',
  styleUrl: './email-verification.component.css',
})
export class EmailVerificationComponent implements OnInit {
  token = signal<string | null>(null);
  isLoading = signal(true);
  isVerified = signal(false);
  errorMessage = signal('');

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    const params = this.route.snapshot.queryParams;
    this.token.set(params['token']);

    if (this.token()) {
      this.verifyEmailToken();
    } else {
      this.isLoading.set(false);
      this.errorMessage.set('Verification token is missing.');
    }
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
            response.message || 'Email verification failed.'
          );
        }
      },
      error: (error) => {
        this.isLoading.set(false);
        this.errorMessage.set(
          error.message ||
            'An error occurred during email verification. Please try again.'
        );
      },
    });
  }

  goToLogin(): void {
    this.router.navigate(['/login']);
  }
}
