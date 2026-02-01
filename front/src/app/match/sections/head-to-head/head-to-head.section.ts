import {Component, ChangeDetectionStrategy, Input, Signal, effect} from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormIndicatorComponent, FormResult } from '../../components/form-indicator/form-indicator.component';

export interface HeadToHead {
  homeTeamLogo: string;
  awayTeamLogo: string;
  recentForm: FormResult[];
}

@Component({
  selector: 'app-head-to-head',
  standalone: true,
  imports: [CommonModule, FormIndicatorComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './head-to-head.section.html',
  styleUrl: './head-to-head.section.css'
})
export class HeadToHeadSection {
  @Input({required: true}) h2hSignal!: Signal<HeadToHead>
  private readonly _log = effect(()=>console.log('HeadToHeadSection h2hSignal', this.h2hSignal()) );
  protected readonly Math = Math;
}
