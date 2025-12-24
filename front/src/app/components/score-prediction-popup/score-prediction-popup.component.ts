import { Component, Input, OnInit, output, input } from '@angular/core';

import { FormsModule } from '@angular/forms';
import { DialogModule } from 'primeng/dialog';
import { ButtonModule } from 'primeng/button';
import { InputNumberModule } from 'primeng/inputnumber';

export interface TeamPrediction {
  team1Name: string;
  team2Name: string;
  team1Flag?: string;
  team2Flag?: string;
  team1Score?: number;
  team2Score?: number;
}

@Component({
  selector: 'app-score-prediction-popup',
  standalone: true,
  imports: [
    FormsModule,
    DialogModule,
    ButtonModule,
    InputNumberModule
],
  templateUrl: './score-prediction-popup.component.html',
  styleUrls: ['./score-prediction-popup.component.css'],
})
export class ScorePredictionPopupComponent implements OnInit {
  @Input() visible = false;
  team1Name = input('');
  team2Name = input('');
  team1Flag = input<string | undefined>(undefined);
  team2Flag = input<string | undefined>(undefined);

  visibleChange = output<boolean>();
  predictionSubmitted = output<TeamPrediction>();

  team1Score: number = 0;
  team2Score: number = 0;

  ngOnInit(): void {
    // Initialize scores to 0
    this.team1Score = 0;
    this.team2Score = 0;
  }

  onHide(): void {
    this.visible = false;
    this.visibleChange.emit(false);
  }

  onSubmit(): void {
    const prediction: TeamPrediction = {
      team1Name: this.team1Name(),
      team2Name: this.team2Name(),
      team1Flag: this.team1Flag(),
      team2Flag: this.team2Flag(),
      team1Score: this.team1Score,
      team2Score: this.team2Score,
    };

    this.predictionSubmitted.emit(prediction);
    this.onHide();
  }

  onCancel(): void {
    this.onHide();
  }
}
