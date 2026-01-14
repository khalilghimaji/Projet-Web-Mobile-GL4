import {
  Component,
  Input,
  output,
  input,
  inject,
  ChangeDetectionStrategy,
  effect,
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
import { map, catchError } from 'rxjs/operators';
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
  @Input() visible = false;
  team1Name = input('');
  team2Name = input('');
  team1Flag = input<string | undefined>(undefined);
  team2Flag = input<string | undefined>(undefined);

  visibleChange = output<boolean>();
  predictionSubmitted = output<TeamPrediction>();

  @Input() matchId: number = 0;

  private readonly matchesService = inject(MatchesService);
  private readonly notificationService = inject(NotificationService);

  existingPrediction: Prediction | null = null;
  originalDiamondsBet: number = 0;
  isUpdating: boolean = false;

  predictionForm: FormGroup = new FormGroup({
    team1Score: new FormControl(0, [Validators.min(0)]),
    team2Score: new FormControl(0, [Validators.min(0)]),
    matchId: new FormControl(this.matchId, [Validators.required]),
    numberOfDiamonds: new FormControl(1, {
      validators: [Validators.min(1)],
      asyncValidators: [this.diamondAsyncValidator.bind(this)],
      updateOn: 'blur',
    }),
  });

  constructor() {
    effect(() => {
      if (this.visible && this.matchId) {
        this.fetchExistingPrediction();
      }
    });
  }

  fetchExistingPrediction(): void {
    this.matchesService
      .matchesControllerGetUserPrediction(String(this.matchId))
      .subscribe({
        next: (prediction) => {
          if (prediction) {
            const pred = prediction as Prediction;
            this.existingPrediction = pred;
            this.originalDiamondsBet = pred.numberOfDiamondsBet;
            this.isUpdating = true;
            this.predictionForm.patchValue({
              team1Score: pred.scoreFirstEquipe,
              team2Score: pred.scoreSecondEquipe,
              matchId: pred.matchId,
              numberOfDiamonds: pred.numberOfDiamondsBet,
            });
          } else {
            this.resetForm();
          }
        },
        error: () => {
          this.resetForm();
        },
      });
  }

  resetForm(): void {
    this.existingPrediction = null;
    this.originalDiamondsBet = 0;
    this.isUpdating = false;
    this.predictionForm.patchValue({
      team1Score: 0,
      team2Score: 0,
      matchId: this.matchId,
      numberOfDiamonds: 1,
    });
  }

  diamondAsyncValidator(
    control: AbstractControl
  ): Observable<ValidationErrors | null> {
    if (!this.visible) return of(null);
    const matchId = control.parent?.get('matchId')?.value || this.matchId;
    const requestedDiamonds = control.value || 0;

    // When updating, check if user has enough diamonds for the difference
    const diamondsNeeded = this.isUpdating
      ? requestedDiamonds - this.originalDiamondsBet
      : requestedDiamonds;

    // If reducing bet or keeping same, no validation needed
    if (diamondsNeeded <= 0) {
      return of(null);
    }

    return this.matchesService
      .matchesControllerCanPredict(matchId, {
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
    this.visible = false;
    this.visibleChange.emit(false);
  }

  onSubmit(): void {
    if (this.predictionForm.valid) {
      const prediction: TeamPrediction = {
        team1Score: this.predictionForm.value.team1Score,
        team2Score: this.predictionForm.value.team2Score,
        matchId: this.predictionForm.value.matchId,
        numberOfDiamonds: this.predictionForm.value.numberOfDiamonds,
      };

      const operation$ = this.isUpdating
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
            this.isUpdating
              ? 'Your prediction has been updated successfully!'
              : 'Your prediction has been saved successfully!'
          );
        },
        error: (e) => {
          console.error('Error saving prediction:', e);
          this.notificationService.showError(
            `There was an error ${
              this.isUpdating ? 'updating' : 'saving'
            } your prediction. Please try again.`
          );
        },
        complete: () => {
          this.visible = false;
          this.visibleChange.emit(false);
        },
      });
      this.predictionSubmitted.emit(prediction);
      this.onHide();
    }
  }

  onCancel(): void {
    this.onHide();
  }
}
