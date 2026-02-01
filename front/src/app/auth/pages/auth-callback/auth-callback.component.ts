import { Component, OnInit, signal, input, linkedSignal } from '@angular/core';

import { Router, RouterModule } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { MessageModule } from 'primeng/message';
import { NotificationService } from '../../../notifications/services/notification.service';

@Component({
  selector: 'app-auth-callback',
  standalone: true,
  imports: [RouterModule, ProgressSpinnerModule, MessageModule],
  templateUrl: './auth-callback.component.html',
  styleUrl: './auth-callback.component.css',
})
export class AuthCallbackComponent implements OnInit {
  provider = input<string>('');
  error = input<string>('');

  loading = linkedSignal(() => {
    if (this.error() || !this.provider()) {
      return false;
    }
    return true;
  });
  displayError = linkedSignal(() => {
    if (this.error()) {
      return decodeURIComponent(this.error());
    }
    if (!this.provider()) {
      return 'Authentication provider not specified';
    }
    return null;
  });

  constructor(
    private router: Router,
    private authService: AuthService,
    private notificationService: NotificationService,
  ) {}

  ngOnInit(): void {
    this.authService.getProfile().subscribe({
      next: (user) => {
        this.authService.setAuthData(user);
        this.notificationService.showSuccess(
          `Successfully logged in with ${this.provider()}`,
        );
        this.loading.set(false);
        this.router.navigate([localStorage.getItem('redirectUrl') || '/']);
      },
      error: (err) => {
        this.displayError.set(
          err.error?.message || 'Failed to authenticate. Please try again.',
        );
        this.loading.set(false);
      },
    });
  }
}
