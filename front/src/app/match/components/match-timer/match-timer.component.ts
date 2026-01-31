import {Component, ChangeDetectionStrategy, input, computed, effect, signal, inject, DestroyRef} from '@angular/core';
import {interval} from 'rxjs';
import {takeUntilDestroyed} from '@angular/core/rxjs-interop';

@Component({
  selector: 'app-match-timer',
  standalone: true,
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './match-timer.component.html',
  styleUrl: './match-timer.component.css'
})
export class MatchTimerComponent {
  statusSignal = input.required<{
    status: 'SCHEDULED' | 'LIVE' | 'HT' | 'FT';
    minute: number;
    isLive: boolean;
  }>();

  private currentMinute = signal(0);
  private currentSeconds = signal(0);
  private destroyRef = inject(DestroyRef);

  displayTime = computed(() => {
    const status = this.statusSignal();
    const minute = this.currentMinute();
    const seconds = this.currentSeconds();
    const formattedSeconds = seconds.toString().padStart(2, '0');

    if (!status.isLive && status.status === 'SCHEDULED') {
      return '--:--';
    }

    if (status.status === 'HT') {
      return 'HT';
    }

    if (status.status === 'FT') {
      return 'FT';
    }

    if (status.isLive && status.status === 'LIVE') {
      // 1ère mi-temps (0-44)
      if (minute < 45) {
        return `${minute}:${formattedSeconds}`;
      }
      // Exactement 45 minutes (pas encore de temps additionnel affiché)
      if (minute === 45) {
        return `45:${formattedSeconds}`;
      }
      // Temps additionnel 1ère MT (46-49)
      if (minute >= 46 && minute < 50) {
        return `45+${minute - 45}:${formattedSeconds}`;
      }
      // 2ème mi-temps (50-89 en cas de problème, normalement 46-89)
      if (minute >= 50 && minute < 90) {
        return `${minute}:${formattedSeconds}`;
      }
      // Exactement 90 minutes
      if (minute === 90) {
        return `90:${formattedSeconds}`;
      }
      // Temps additionnel 2ème MT (91+)
      if (minute >= 91) {
        return `90+${minute - 90}:${formattedSeconds}`;
      }

      return `${minute}:${formattedSeconds}`;
    }

    return '--:--';
  });

  isLive = computed(() => this.statusSignal().isLive && this.statusSignal().status === 'LIVE');
  isHalftime = computed(() => this.statusSignal().status === 'HT');

  constructor() {
    effect(() => {
      const status = this.statusSignal();
      this.currentMinute.set(status.minute);
      this.currentSeconds.set(0);

      if (status.isLive && status.status === 'LIVE') {
        this.startTimer();
      }
    });
  }

  private startTimer(): void {
    interval(1000)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe(() => {
        this.currentSeconds.update(s => {
          if (s >= 59) {
            this.currentMinute.update(m => {
              // Validation: ne jamais dépasser 120 minutes (prolongations comprises)
              const nextMinute = m + 1;
              return Math.min(nextMinute, 120);
            });
            return 0;
          }
          return s + 1;
        });
      });
  }
}
