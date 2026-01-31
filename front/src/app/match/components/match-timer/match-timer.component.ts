import {Component, ChangeDetectionStrategy, input, computed, effect, signal, DestroyRef, inject, NgZone} from '@angular/core';
import {interval, Subscription} from 'rxjs';

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
  private zone = inject(NgZone);
  private destroyRef = inject(DestroyRef);
  private timerSubscription: Subscription | null = null;

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
      if (minute < 45) {
        return `${minute}:${formattedSeconds}`;
      }
      if (minute >= 45 && minute < 50) {
        return `45+${minute - 45}:${formattedSeconds}`;
      }
      if (minute >= 45 && minute < 90) {
        return `${minute}:${formattedSeconds}`;
      }
      if (minute >= 90) {
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
      this.stopTimer();

      if (status.isLive && status.status === 'LIVE') {
        this.startTimer();
      }
    });

    this.destroyRef.onDestroy(() => {
      this.stopTimer();
    });
  }

  private startTimer(): void {
    this.zone.runOutsideAngular(() => {
      this.timerSubscription = interval(1000).subscribe(() => {
        this.currentSeconds.update(s => {
          if (s >= 59) {
            this.currentMinute.update(m => m + 1);
            return 0;
          }
          return s + 1;
        });
      });
    });
  }

  private stopTimer(): void {
    if (this.timerSubscription) {
      this.timerSubscription.unsubscribe();
      this.timerSubscription = null;
    }
  }
}

