import { Component, Input, OnInit, output, input, inject } from '@angular/core';

import {
  FormsModule,
  ReactiveFormsModule,
  FormBuilder,
  FormGroup,
  Validators,
  AbstractControl,
  ValidationErrors,
} from '@angular/forms';
import { DialogModule } from 'primeng/dialog';
import { ButtonModule } from 'primeng/button';
import { InputNumberModule } from 'primeng/inputnumber';
import { Observable, of } from 'rxjs';
import { delay } from 'rxjs/operators';

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

  private fb = inject(FormBuilder);
  predictionForm: FormGroup = this.fb.group({
    team1Score: [0, [Validators.min(0)]],
    team2Score: [0, [Validators.min(0)]],
    matchId: [this.matchId, [Validators.required]],
    numberOfDiamonds: [
      1,
      [Validators.min(1)],
      [this.diamondAsyncValidator.bind(this)],
    ],
  });
  constructor() {}
  diamondAsyncValidator(
    control: AbstractControl
  ): Observable<ValidationErrors | null> {
    // Dummy async validator: simulate checking if the number is not 5
    return of(control.value === 5 ? { invalidDiamond: true } : null).pipe(
      delay(1000)
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
      this.predictionSubmitted.emit(prediction);
      this.onHide();
    }
  }

  onCancel(): void {
    this.onHide();
  }
}
