import {
  Component,
  signal,
  inject,
  ChangeDetectionStrategy,
  viewChild,
  ElementRef,
  AfterViewInit,
} from '@angular/core';

import {
  AbstractControl,
  FormBuilder,
  ReactiveFormsModule,
  ValidationErrors,
  Validators,
} from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { InputTextModule } from 'primeng/inputtext';
import { ButtonModule } from 'primeng/button';
import { PasswordModule } from 'primeng/password';
import { CheckboxModule } from 'primeng/checkbox';
import { RippleModule } from 'primeng/ripple';
import { AuthService } from '../../services/auth.service';
import { NotificationService } from '../../services/notification.service';
import { MessageModule } from 'primeng/message';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { environment } from '../../../environments/environment';
import { fromEvent } from 'rxjs';

@Component({
  selector: 'app-signup-page',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    RouterModule,
    InputTextModule,
    ButtonModule,
    PasswordModule,
    CheckboxModule,
    RippleModule,
    MessageModule,
    ProgressSpinnerModule,
  ],
  templateUrl: './signup-page.component.html',
  styleUrl: './signup-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SignupPageComponent implements AfterViewInit {
  private readonly fb = inject(FormBuilder);
  private readonly router = inject(Router);
  private readonly authService = inject(AuthService);
  private readonly notificationService = inject(NotificationService);

  isLoading = signal(false);
  errorMessage = signal('');
  profileImagePreview = signal<string | null>(null);
  selectedProfileImage = signal<File | null>(null);

  profileImagePreviewRef = viewChild<ElementRef>('profileImagePreviewId');
  profileImageInputRef = viewChild<ElementRef>('profileImageInput');
  googleButtonRef = viewChild<ElementRef>('googleButton');
  githubButtonRef = viewChild<ElementRef>('githubButton');

  signupForm = this.fb.group({
    firstName: ['', Validators.required],
    lastName: ['', Validators.required],
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(8)]],
    profileImage: [null],
    agreeTerms: [false, Validators.requiredTrue],
  });

  ngAfterViewInit(): void {
    const profileImagePreview = this.profileImagePreviewRef()?.nativeElement;
    const profileImageInput = this.profileImageInputRef()?.nativeElement;
    if (profileImagePreview && profileImageInput) {
      fromEvent(profileImagePreview, 'click').subscribe(() =>
        profileImageInput.click()
      );
    }

    if (profileImageInput) {
      fromEvent(profileImageInput, 'change').subscribe((event) =>
        this.onProfileImageSelected(event as Event)
      );
    }

    const googleButton = this.googleButtonRef()?.nativeElement;
    if (googleButton) {
      fromEvent(googleButton, 'click').subscribe(() => this.loginWithGoogle());
    }

    const githubButton = this.githubButtonRef()?.nativeElement;
    if (githubButton) {
      fromEvent(githubButton, 'click').subscribe(() => this.loginWithGithub());
    }
  }

  onProfileImageSelected(event: Event) {
    const fileInput = event.target as HTMLInputElement;

    if (fileInput.files && fileInput.files.length > 0) {
      const file = fileInput.files[0];

      const validImageTypes = [
        'image/jpeg',
        'image/png',
        'image/jpg',
        'image/gif',
      ];
      if (!validImageTypes.includes(file.type)) {
        this.errorMessage.set(
          'Please select a valid image file (JPEG, PNG, JPG, GIF)'
        );
        return;
      }

      if (file.size > 5 * 1024 * 1024) {
        this.errorMessage.set('Image size should not exceed 5MB');
        return;
      }

      this.selectedProfileImage.set(file);

      const reader = new FileReader();
      reader.onload = () => {
        this.profileImagePreview.set(reader.result as string);
      };
      reader.readAsDataURL(file);

      this.errorMessage.set('');
    }
  }

  passwordMatchingValidator(control: AbstractControl): ValidationErrors | null {
    const password = control.get('password');
    const confirmPassword = control.get('confirmPassword');

    if (
      password &&
      confirmPassword &&
      password.value !== confirmPassword.value
    ) {
      return { passwordMismatch: true };
    }
    return null;
  }

  onSignup() {
    if (!this.signupForm.valid) {
      return;
    }

    this.isLoading.set(true);
    this.errorMessage.set('');

    const userData = {
      fisrtname: this.signupForm.value.firstName || '',
      lastname: this.signupForm.value.lastName || '',
      email: this.signupForm.value.email || '',
      password: this.signupForm.value.password || '',
      imgUrl: this.selectedProfileImage() || undefined,
    };

    this.authService.register(userData).subscribe({
      next: (response) => {
        this.isLoading.set(false);
        if (response.success) {
          this.notificationService.showSuccess(
            'Registration successful! Please check your email to verify your account.'
          );
          this.router.navigate(['/login']);
        } else {
          this.errorMessage.set(response.message);
        }
      },
      error: (error) => {
        this.isLoading.set(false);
        this.errorMessage.set(
          error.message || 'Registration failed. Please try again.'
        );
      },
    });
  }

  loginWithGithub() {
    const apiUrl = environment.apiUrl;
    window.location.href = `${apiUrl}/auth/github`;
  }

  loginWithGoogle() {
    const apiUrl = environment.apiUrl;
    window.location.href = `${apiUrl}/auth/google`;
  }
}
