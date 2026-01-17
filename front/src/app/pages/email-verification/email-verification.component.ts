import {
  ChangeDetectionStrategy,
  Component,
  OnInit,
  signal,
  viewChild,
  ElementRef,
  AfterViewInit,
} from '@angular/core';

import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { ButtonModule } from 'primeng/button';
import { MessageModule } from 'primeng/message';
import { fromEvent } from 'rxjs';

@Component({
  selector: 'app-email-verification',
  standalone: true,
  imports: [RouterModule, ProgressSpinnerModule, ButtonModule, MessageModule],
  templateUrl: './email-verification.component.html',
  styleUrl: './email-verification.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class EmailVerificationComponent implements OnInit, AfterViewInit {
  token = signal<string | null>(null);
  isLoading = signal(true);
  isVerified = signal(false);
  errorMessage = signal('');
  loginButtonRef = viewChild<ElementRef>('loginButton');
  retryButtonRef = viewChild<ElementRef>('retryButton');
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

  ngAfterViewInit(): void {
    const loginButton = this.loginButtonRef()?.nativeElement;
    if (loginButton) {
      fromEvent(loginButton, 'click').subscribe(() => this.goToLogin());
    }

    const retryButton = this.retryButtonRef()?.nativeElement;
    if (retryButton) {
      fromEvent(retryButton, 'click').subscribe(() => this.verifyEmailToken());
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
