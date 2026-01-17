import {
  Component,
  OnInit,
  signal,
  inject,
  ChangeDetectionStrategy,
  viewChild,
  ElementRef,
  AfterViewInit,
} from '@angular/core';

import { FormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { ButtonModule } from 'primeng/button';
import { InputTextModule } from 'primeng/inputtext';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { MessageModule } from 'primeng/message';
import { AuthService } from '../../services/auth.service';
import { NotificationService } from '../../services/notification.service';
import { fromEvent } from 'rxjs';

@Component({
  selector: 'app-mfa-setup',
  standalone: true,
  imports: [
    FormsModule,
    RouterModule,
    ButtonModule,
    InputTextModule,
    ProgressSpinnerModule,
    MessageModule,
  ],
  templateUrl: './mfa-setup.component.html',
  styleUrls: ['./mfa-setup.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class MfaSetupComponent implements OnInit, AfterViewInit {
  private readonly authService = inject(AuthService);
  // State signals
  userProfile = this.authService.currentUser;
  mfaEnabled = this.authService.hasOtpEnabled;

  setupStarted = signal(false);
  step = signal(1);
  isLoading = signal(false);
  errorMessage = signal('');

  secretKey = signal('');
  qrCodeUrl = signal('');
  otpCode = signal('');
  recoveryCodes = signal<string[]>([]);
  password = signal('');

  startMfaButtonRef = viewChild<ElementRef>('startMfaButton');
  nextButtonRef = viewChild<ElementRef>('nextButton');
  backButton1Ref = viewChild<ElementRef>('backButton1');
  enableMfaButtonRef = viewChild<ElementRef>('enableMfaButton');
  backButton2Ref = viewChild<ElementRef>('backButton2');
  finishSetupButtonRef = viewChild<ElementRef>('finishSetupButton');
  disableMfaButtonRef = viewChild<ElementRef>('disableMfaButton');
  qrCodeImgRef = viewChild<ElementRef>('qrCodeImg');

  constructor(
    private notificationService: NotificationService,
    private router: Router,
  ) {}

  ngOnInit(): void {
    if (!this.authService.isAuthenticated()) {
      this.router.navigate(['/login']);
      return;
    }

    // Refresh profile to ensure MFA status is current
    this.isLoading.set(true);
    this.authService.getProfile().subscribe({
      next: () => this.isLoading.set(false),
      error: () => {
        this.isLoading.set(false);
        this.notificationService.showError('Failed to load profile');
      },
    });
  }

  ngAfterViewInit(): void {
    const startMfaButton = this.startMfaButtonRef()?.nativeElement;
    if (startMfaButton) {
      fromEvent(startMfaButton, 'click').subscribe(() => this.startMfaSetup());
    }

    const nextButton = this.nextButtonRef()?.nativeElement;
    if (nextButton) {
      fromEvent(nextButton, 'click').subscribe(() => this.nextStep());
    }

    const backButton1 = this.backButton1Ref()?.nativeElement;
    if (backButton1) {
      fromEvent(backButton1, 'click').subscribe(() => this.previousStep());
    }

    const enableMfaButton = this.enableMfaButtonRef()?.nativeElement;
    if (enableMfaButton) {
      fromEvent(enableMfaButton, 'click').subscribe(() => this.enableMfa());
    }

    const backButton2 = this.backButton2Ref()?.nativeElement;
    if (backButton2) {
      fromEvent(backButton2, 'click').subscribe(() => this.previousStep());
    }

    const finishSetupButton = this.finishSetupButtonRef()?.nativeElement;
    if (finishSetupButton) {
      fromEvent(finishSetupButton, 'click').subscribe(() => this.finishSetup());
    }

    const disableMfaButton = this.disableMfaButtonRef()?.nativeElement;
    if (disableMfaButton) {
      fromEvent(disableMfaButton, 'click').subscribe(() => this.disableMfa());
    }

    const qrCodeImg = this.qrCodeImgRef()?.nativeElement;
    if (qrCodeImg) {
      fromEvent<Event>(qrCodeImg, 'load').subscribe((event) =>
        this.onQrCodeLoaded(event),
      );
    }
  }

  startMfaSetup(): void {
    this.isLoading.set(true);
    this.errorMessage.set('');

    this.authService.generateMfaSecret().subscribe({
      next: (response) => {
        this.secretKey.set(response.secret);
        this.qrCodeUrl.set(response.qrCode);
        this.setupStarted.set(true);
        this.step.set(1);
        this.isLoading.set(false);
      },
      error: (error) => {
        this.errorMessage.set(
          error.error?.message ||
            'Failed to generate MFA secret. Please try again.',
        );
        this.isLoading.set(false);
      },
    });
  }

  onQrCodeLoaded(event: Event): void {
    const img = event.target as HTMLImageElement;
    if (!img || img.naturalWidth === 0) {
      this.errorMessage.set('Failed to load QR code image. Please try again.');
    }
  }

  nextStep(): void {
    if (this.step() < 3) {
      this.step.update((s) => s + 1);
      this.errorMessage.set('');
    }
  }

  previousStep(): void {
    if (this.step() > 1) {
      this.step.update((s) => s - 1);
      this.errorMessage.set('');
    }
  }

  enableMfa(): void {
    if (this.otpCode().length !== 6) {
      this.errorMessage.set('Please enter a valid 6-digit code');
      return;
    }

    this.isLoading.set(true);
    this.errorMessage.set('');

    this.authService.enableMfa(this.otpCode()).subscribe({
      next: (response) => {
        this.isLoading.set(false);
        if (response.success) {
          this.recoveryCodes.set(response.recoveryCodes);
          this.nextStep();
        } else {
          this.errorMessage.set(response.message);
        }
      },
      error: (error) => {
        this.isLoading.set(false);
        this.errorMessage.set(
          error.error?.message || 'Failed to enable MFA. Please try again.',
        );
      },
    });
  }

  finishSetup(): void {
    this.notificationService.showSuccess(
      'Two-factor authentication enabled successfully',
    );
    this.setupStarted.set(false);
    this.step.set(1);
    // Refresh profile to update MFA status
    this.authService.getProfile().subscribe();
  }

  disableMfa(): void {
    if (!this.password()) {
      this.errorMessage.set(
        'Password is required to disable two-factor authentication',
      );
      return;
    }

    this.isLoading.set(true);
    this.errorMessage.set('');

    this.authService.disableMfa(this.password()).subscribe({
      next: (response) => {
        this.isLoading.set(false);
        if (response.success) {
          this.notificationService.showSuccess(
            'Two-factor authentication disabled successfully',
          );
          this.setupStarted.set(false);
          this.password.set('');
          // Refresh profile to update MFA status
          this.authService.getProfile().subscribe();
        } else {
          this.errorMessage.set(response.message);
        }
      },
      error: (error) => {
        this.isLoading.set(false);
        this.errorMessage.set(
          error.error?.message || 'Failed to disable MFA. Please try again.',
        );
      },
    });
  }
}
