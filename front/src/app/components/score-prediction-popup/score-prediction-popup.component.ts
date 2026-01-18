import {
  Component,
  output,
  input,
  inject,
  ChangeDetectionStrategy,
  model,
  Input,
  Signal,
  effect,
  viewChild,
  ElementRef,
  computed,
  AfterViewInit,
  DestroyRef,
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
import { InputTextModule } from 'primeng/inputtext';
import { FloatLabelModule } from 'primeng/floatlabel';
import { IconFieldModule } from 'primeng/iconfield';
import { InputIconModule } from 'primeng/inputicon';
import { EMPTY, fromEvent, Observable, of, Subscription } from 'rxjs';
import {
  map,
  catchError,
  switchMap,
  filter,
  tap,
  finalize,
} from 'rxjs/operators';
import { MatchesService, Prediction } from '../../services/Api';
import { NotificationService } from '../../services/notification.service';
import {
  takeUntilDestroyed,
  toObservable,
  toSignal,
} from '@angular/core/rxjs-interop';

export interface TeamPrediction {
  team1Score?: number;
  team2Score?: number;
  matchId?: number;
  numberOfDiamonds?: number;
  isUpdating?: boolean;
}

@Component({
  selector: 'app-score-prediction-popup',
  standalone: true,
  imports: [
    FormsModule,
    ReactiveFormsModule,
    DialogModule,
    ButtonModule,
    InputTextModule,
    FloatLabelModule,
    IconFieldModule,
    InputIconModule,
  ],
  templateUrl: './score-prediction-popup.component.html',
  styleUrls: ['./score-prediction-popup.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ScorePredictionPopupComponent {
  visible = model(false);

  team1Name = input('');
  team2Name = input('');

  team1Flag = input<string | undefined>(undefined);
  team2Flag = input<string | undefined>(undefined);

  predictionSubmitted = output<TeamPrediction>();

  private readonly matchesService = inject(MatchesService);
  private readonly notificationService = inject(NotificationService);

  @Input({ required: true }) predictionDataSignal!: Signal<TeamPrediction>;

  predictionForm: FormGroup = new FormGroup({
    team1Score: new FormControl<number | null>(0, [Validators.min(0)]),
    team2Score: new FormControl<number | null>(0, [Validators.min(0)]),
    numberOfDiamonds: new FormControl<number | null>(1, {
      validators: [Validators.min(1)],
      asyncValidators: [this.diamondAsyncValidator.bind(this)],
      updateOn: 'blur',
    }),
  });

  formChangeSignal = toSignal(this.predictionForm.valueChanges);

  areValuesChanged = computed(() => {
    return (
      this.predictionDataSignal().team1Score !==
        this.formChangeSignal()?.team1Score ||
      this.predictionDataSignal().team2Score !==
        this.formChangeSignal()?.team2Score ||
      this.predictionDataSignal().numberOfDiamonds !==
        this.formChangeSignal()?.numberOfDiamonds
    );
  });
  private destroRef = inject(DestroyRef);
  cancelButtonRef = viewChild<ElementRef>('cancelButton');
  submitButtonRef = viewChild<ElementRef>('submitButton');

  constructor() {
    toObservable(this.cancelButtonRef)
      .pipe(
        switchMap((ref) => {
          if (!ref?.nativeElement) {
            return of(null);
          }
          return fromEvent(ref.nativeElement, 'click').pipe(
            takeUntilDestroyed(this.destroRef),
          );
        }),
      )
      .subscribe((el) => !el || this.onCancel());

    toObservable(this.submitButtonRef)
      .pipe(
        switchMap((ref) => {
          if (!ref?.nativeElement) {
            return of(null);
          }
          return fromEvent(ref.nativeElement, 'click').pipe(
            takeUntilDestroyed(this.destroRef),
          );
        }),
      )
      .subscribe((el) => !el || this.onSubmit());

    // Update form values when predictionDataSignal changes
    effect(() => {
      const predictionData = this.predictionDataSignal();
      this.predictionForm.patchValue({
        team1Score: predictionData.team1Score || 0,
        team2Score: predictionData.team2Score || 0,
        numberOfDiamonds: predictionData.numberOfDiamonds || 1,
      });
    });
  }

  diamondAsyncValidator(
    control: AbstractControl,
  ): Observable<ValidationErrors | null> {
    if (!this.visible()) return of(null);
    const requestedDiamonds = control.value || 0;

    // When updating, check if user has enough diamonds for the difference
    const diamondsNeeded = this.predictionDataSignal().isUpdating
      ? requestedDiamonds - (this.predictionDataSignal().numberOfDiamonds || 1)
      : requestedDiamonds;

    // If reducing bet or keeping same, no validation needed
    if (diamondsNeeded <= 0) {
      return of(null);
    }

    return this.matchesService
      .matchesControllerCanPredict(
        String(this.predictionDataSignal().matchId),
        {
          numberOfDiamondsBet: diamondsNeeded,
        },
      )
      .pipe(
        map((canPredict) => {
          return canPredict ? null : { insufficientDiamonds: true };
        }),
        catchError(() => {
          return of({ invalidDiamond: true });
        }),
      );
  }

  onHide(): void {
    this.visible.set(false);
  }

  async onSubmit(): Promise<void> {
    if (this.predictionForm.valid) {
      const formValue = this.predictionForm.getRawValue();
      const prediction: TeamPrediction = {
        team1Score: Number(formValue.team1Score),
        team2Score: Number(formValue.team2Score),
        matchId: this.predictionDataSignal().matchId,
        numberOfDiamonds: Number(formValue.numberOfDiamonds),
      };
      const operation$ = this.predictionDataSignal().isUpdating
        ? this.matchesService.matchesControllerUpdatePrediction(
            String(prediction.matchId) || '0',
            {
              scoreFirst: prediction.team1Score,
              scoreSecond: prediction.team2Score,
              numberOfDiamondsBet: prediction.numberOfDiamonds,
            },
          )
        : this.matchesService.matchesControllerMakePrediction(
            String(prediction.matchId) || '0',
            {
              scoreFirst: prediction.team1Score || 0,
              scoreSecond: prediction.team2Score || 0,
              numberOfDiamondsBet: prediction.numberOfDiamonds || 1,
            },
          );

      operation$.subscribe({
        next: () => {
          this.notificationService.showSuccess(
            this.predictionDataSignal().isUpdating
              ? 'Your prediction has been updated successfully!'
              : 'Your prediction has been saved successfully!',
          );
          this.predictionSubmitted.emit(prediction);
        },
        error: (e) => {
          this.notificationService.showError(
            `There was an error ${
              this.predictionDataSignal().isUpdating ? 'updating' : 'saving'
            } your prediction. ${e.error.message}. Please try again.`,
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
