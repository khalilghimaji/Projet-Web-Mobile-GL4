import {
  Component,
  input,
  computed,
  ChangeDetectionStrategy,
} from '@angular/core';

import { RouterModule } from '@angular/router';
import { Location } from '@angular/common';
import { FormsModule } from '@angular/forms';
@Component({
  selector: 'app-error-page',
  standalone: true,
  imports: [RouterModule, FormsModule],
  templateUrl: './error-page.component.html',
  styleUrls: ['./error-page.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ErrorPageComponent {
  // Input signals for error code and message
  errorCode = input<number>(404, { alias: 'errorCode' });
  errorMessage = input<string>('', { alias: 'errorMessage' });

  // Error details map
  private errorDetails: Record<number, { title: string; message: string }> = {
    404: {
      title: 'Page Not Found',
      message: "The page you are looking for doesn't exist or has been moved.",
    },
    500: {
      title: 'Server Error',
      message: 'Something went wrong on our end. Please try again later.',
    },
    403: {
      title: 'Access Denied',
      message: "You don't have permission to access this resource.",
    },
  };

  // Computed error detail based on error code
  errorDetail = computed(() => {
    const code = this.errorCode();
    return this.errorDetails[code] || { title: 'Error', message: 'Something went wrong' };
  });

  // Computed title and message
  title = computed(() => this.errorDetail().title);

  message = computed(() => {
    const customMessage = this.errorMessage();
    return customMessage || this.errorDetail().message;
  });

  constructor(private location: Location) {}

  goBack() {
    this.location.back();
  }
}
