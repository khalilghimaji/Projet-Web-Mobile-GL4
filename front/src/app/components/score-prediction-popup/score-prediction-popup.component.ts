import {
  Component,
  output,
  input,
  inject,
  ChangeDetectionStrategy,
  model,
  signal,
} from '@angular/core';

import {
  FormsModule,
  ReactiveFormsModule,
  FormGroup,
  FormControl,
  Validators,
  AbstractControl,
  ValidationErrors,
} from '@angular/forms';
import { DialogModule } from 'primeng/dialog';
import { ButtonModule } from 'primeng/button';
import { InputNumberModule } from 'primeng/inputnumber';
import { Observable, of } from 'rxjs';
import { map, catchError, tap } from 'rxjs/operators';
import { rxResource } from '@angular/core/rxjs-interop';
import { MatchesService, Prediction } from '../../services/Api';
import { NotificationService } from '../../services/notification.service';

export interface TeamPrediction {
  team1Score?: number;
  team2Score?: number;
  matchId?: number;
  numberOfDiamonds?: number;
}

@Component({
  selector: 'app-score-prediction-popup',
  standalone: true,
  imports: [
    FormsModule,
    ReactiveFormsModule,
    DialogModule,
    ButtonModule,
    InputNumberModule,
  ],
  templateUrl: './score-prediction-popup.component.html',
  styleUrls: ['./score-prediction-popup.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ScorePredictionPopupComponent {
  visible = model(false);

  team1Name = input('');
  team2Name = input('');
  matchId = input(0);
  team1Flag = input<string | undefined>(undefined);
  team2Flag = input<string | undefined>(undefined);

  predictionSubmitted = output<TeamPrediction>();

  private readonly matchesService = inject(MatchesService);
  private readonly notificationService = inject(NotificationService);

  originalDiamondsBet = signal(0);
  isUpdating = signal(false);

  predictionForm: FormGroup = new FormGroup({
    team1Score: new FormControl(0, [Validators.min(0)]),
    team2Score: new FormControl(0, [Validators.min(0)]),
    numberOfDiamonds: new FormControl(1, {
      validators: [Validators.min(1)],
      asyncValidators: [this.diamondAsyncValidator.bind(this)],
      updateOn: 'blur',
    }),
  });

  existingPrediction = rxResource({
    params: () => ({ visible: this.visible(), matchId: this.matchId() }),
    stream: ({ params }) => {
      if (!params.visible || !params.matchId) {
        return of(null);
      }
      return this.matchesService
        .matchesControllerGetUserPrediction(String(params.matchId))
        .pipe(
          map((prediction) => (prediction as Prediction) || null),
          tap((pred) => {
            if (pred) {
              this.originalDiamondsBet.set(pred.numberOfDiamondsBet);
              this.isUpdating.set(true);
              this.predictionForm.patchValue({
                team1Score: pred.scoreFirstEquipe,
                team2Score: pred.scoreSecondEquipe,
                numberOfDiamonds: pred.numberOfDiamondsBet,
              });
            } else {
              this.resetForm();
            }
          }),
          catchError(() => of(null))
        );
    },
  });

  resetForm(): void {
    this.originalDiamondsBet.set(0);
    this.isUpdating.set(false);
    this.predictionForm.patchValue({
      team1Score: 0,
      team2Score: 0,
      numberOfDiamonds: 1,
    });
  }

  diamondAsyncValidator(
    control: AbstractControl
  ): Observable<ValidationErrors | null> {
    if (!this.visible()) return of(null);
    const requestedDiamonds = control.value || 0;

    // When updating, check if user has enough diamonds for the difference
    const diamondsNeeded = this.isUpdating()
      ? requestedDiamonds - this.originalDiamondsBet()
      : requestedDiamonds;

    // If reducing bet or keeping same, no validation needed
    if (diamondsNeeded <= 0) {
      return of(null);
    }

    return this.matchesService
      .matchesControllerCanPredict(String(this.matchId()), {
        numberOfDiamondsBet: diamondsNeeded,
      })
      .pipe(
        map((canPredict) => {
          return canPredict ? null : { insufficientDiamonds: true };
        }),
        catchError(() => {
          return of({ invalidDiamond: true });
        })
      );
  }

  onHide(): void {
    this.visible.set(false);
  }

  onSubmit(): void {
    if (this.predictionForm.valid) {
      const prediction: TeamPrediction = {
        team1Score: this.predictionForm.value.team1Score,
        team2Score: this.predictionForm.value.team2Score,
        matchId: this.matchId(),
        numberOfDiamonds: this.predictionForm.value.numberOfDiamonds,
      };

      const operation$ = this.isUpdating()
        ? this.matchesService.matchesControllerUpdatePrediction(
            String(prediction.matchId) || '0',
            {
              scoreFirst: prediction.team1Score,
              scoreSecond: prediction.team2Score,
              numberOfDiamondsBet: prediction.numberOfDiamonds,
            }
          )
        : this.matchesService.matchesControllerMakePrediction(
            String(prediction.matchId) || '0',
            {
              scoreFirst: prediction.team1Score || 0,
              scoreSecond: prediction.team2Score || 0,
              numberOfDiamondsBet: prediction.numberOfDiamonds || 1,
            }
          );

      operation$.subscribe({
        next: () => {
          this.notificationService.showSuccess(
            this.isUpdating()
              ? 'Your prediction has been updated successfully!'
              : 'Your prediction has been saved successfully!'
          );
          this.predictionSubmitted.emit(prediction);
        },
        error: (e) => {
          console.error('Error saving prediction:', e);
          this.notificationService.showError(
            `There was an error ${
              this.isUpdating() ? 'updating' : 'saving'
            } your prediction. Please try again.`
          );
        },
        complete: () => {
          this.visible.set(false);
        },
      });
      this.onHide();
    }
  }

  onCancel(): void {
    this.onHide();
  }
}
