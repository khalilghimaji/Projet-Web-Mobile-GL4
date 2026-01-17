import {
  AfterViewInit,
  Component,
  ElementRef,
  OnInit,
  signal,
  viewChild,
} from '@angular/core';

import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { MessageModule } from 'primeng/message';
import { NotificationService } from '../../services/notification.service';
import { fromEvent } from 'rxjs';

@Component({
  selector: 'app-auth-callback',
  standalone: true,
  imports: [RouterModule, ProgressSpinnerModule, MessageModule],
  templateUrl: './auth-callback.component.html',
  styleUrl: './auth-callback.component.css',
})
export class AuthCallbackComponent implements OnInit, AfterViewInit {
  loading = signal(true);
  error = signal<string>('');
  provider = signal<string>('');

  tryAgainButtonRef = viewChild<ElementRef<HTMLElement>>('tryAgainButton');

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService,
    private notificationService: NotificationService,
  ) {}

  ngAfterViewInit(): void {
    const button = this.tryAgainButtonRef()?.nativeElement;
    if (button) {
      fromEvent(button, 'click').subscribe(() => {
        this.tryAgain();
      });
    }
  }

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
          `Successfully logged in with ${this.provider()}`,
        );
        this.loading.set(false);
        this.router.navigate([localStorage.getItem('redirectUrl') || '/']);
      },
      error: (err) => {
        this.error.set(
          err.error?.message || 'Failed to authenticate. Please try again.',
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
