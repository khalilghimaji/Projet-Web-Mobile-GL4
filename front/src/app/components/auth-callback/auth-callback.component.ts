import { Component, OnInit, signal } from '@angular/core';

import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { MessageModule } from 'primeng/message';
import { NotificationService } from '../../services/notification.service';

@Component({
  selector: 'app-auth-callback',
  standalone: true,
  imports: [RouterModule, ProgressSpinnerModule, MessageModule],
  templateUrl: './auth-callback.component.html',
  styleUrl: './auth-callback.component.css',
})
export class AuthCallbackComponent implements OnInit {
  loading = signal(true);
  error = signal<string>('');
  provider = signal<string>('');

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService,
    private notificationService: NotificationService
  ) {}

  ngOnInit(): void {
    const params = this.route.snapshot.queryParams;
    this.provider.set(params['provider']);
    const error = params['error'];

    if (error) {
      this.error.set(decodeURIComponent(error));
      this.loading.set(false);
      return;
    }

    if (!this.provider()) {
      this.error.set('Authentication provider not specified');
      this.loading.set(false);
      return;
    }

    this.authService.getProfile().subscribe({
      next: (user) => {
        this.authService.setAuthData(user);
        this.notificationService.showSuccess(
          `Successfully logged in with ${this.provider()}`
        );
        this.loading.set(false);
        this.router.navigate(['/']);
      },
      error: (err) => {
        this.error.set(
          err.error?.message || 'Failed to authenticate. Please try again.'
        );
        this.loading.set(false);
      },
    });
  }

  tryAgain(): void {
    // Redirect to login page
    this.router.navigate(['/login']);
  }
}
