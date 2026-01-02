import {
  Component,
  input,
  computed,
  inject,
  signal,
  ChangeDetectionStrategy,
} from '@angular/core';

import { RouterModule, ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';
import { toSignal } from '@angular/core/rxjs-interop';
import { map } from 'rxjs/operators';
import {
  ScorePredictionPopupComponent,
  TeamPrediction,
} from '../score-prediction-popup/score-prediction-popup.component';
import { MatchesService } from '../../services/Api';
import { NotificationService } from '../../services/notification.service';

@Component({
  selector: 'app-error-page',
  standalone: true,
  imports: [RouterModule, ScorePredictionPopupComponent],
  templateUrl: './error-page.component.html',
  styleUrls: ['./error-page.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ErrorPageComponent {
  // Input signals for direct component usage
  errorCodeInput = input<number | null>(null, { alias: 'errorCode' });
  errorMessageInput = input<string>('', { alias: 'errorMessage' });
  private route = inject(ActivatedRoute);
  // Get error code from route params or input
  private routeParams = toSignal(this.route.paramMap);
  private routeData = toSignal(this.route.data);

  // Computed error code from route or input
  errorCode = computed(() => {
    const routeCode = this.routeParams()?.get('code');
    if (routeCode) return parseInt(routeCode, 10);

    const dataCode = this.routeData()?.['errorCode'];
    if (dataCode) return dataCode;

    return this.errorCodeInput() || 404;
  });

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

  // Computed title and message based on error code
  title = computed(() => {
    const code = this.errorCode();
    return this.errorDetails[code]?.title || 'Error';
  });

  message = computed(() => {
    const code = this.errorCode();
    const customMessage = this.errorMessageInput();
    return (
      customMessage ||
      this.errorDetails[code]?.message ||
      'Something went wrong'
    );
  });

  // ================ this part is specific to demonstrate score prediction popup ==================

  // Score prediction popup state
  showPredictionDialog = signal(false);

  // Demo team data
  team1Name = 'Barcelona';
  team2Name = 'Real Madrid';
  team1Flag = 'https://flagcdn.com/w320/it.png';
  team2Flag = 'https://flagcdn.com/w320/es.png';
  // ====================================  end ============================================
  constructor(private location: Location) {}

  goBack() {
    this.location.back();
  }
  // ================ score prediction popup methods ==================
  openPredictionDialog() {
    this.showPredictionDialog.set(true);
  }

  onPredictionSubmitted(prediction: TeamPrediction) {
    console.log('Prediction submitted:', prediction);
  }

  onCloseDialog(event: any) {
    this.showPredictionDialog.set(false);
  }
  // ===============================  end =================================================
}
