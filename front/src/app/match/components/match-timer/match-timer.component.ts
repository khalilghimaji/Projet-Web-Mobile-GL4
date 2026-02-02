import {Component, ChangeDetectionStrategy, input, computed, effect, signal, inject, DestroyRef} from '@angular/core';
import {interval, Subscription} from 'rxjs';
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

  showSeconds = input<boolean>(false);

  private currentMinute = signal(0);
  private currentSeconds = signal(0);
  private destroyRef = inject(DestroyRef);
  private timerSubscription: Subscription | null = null;

  displayTime = computed(() => {
    const status = this.statusSignal();
    const minute = this.currentMinute();
    const seconds = this.currentSeconds();
    const shouldShowSeconds = this.showSeconds();
    const formattedSeconds = seconds.toString().padStart(2, '0');

    if (status.status === 'HT') {
      return 'HT';
    }

    if (status.status === 'FT') {
      return 'FT';
    }

    if (!status.isLive && status.status === 'SCHEDULED') {
      return '--:--';
    }

    if (status.isLive && status.status === 'LIVE') {
      const secondsPart = shouldShowSeconds ? `:${formattedSeconds}` : '';

      if (minute < 45) {
        return `${minute}${secondsPart}`;
      }
      if (minute >= 45 && minute < 46) {
        return `45${secondsPart}`;
      }
      if (minute >= 46 && minute < 90) {
        return `${minute}${secondsPart}`;
      }
      if (minute >= 90) {
        const addedTime = minute - 90;
        return addedTime === 0 ? `90${secondsPart}` : `90+${addedTime}${secondsPart}`;
      }

      return `${minute}${secondsPart}`;
    }


    return '--:--';
  });

  isLive = computed(() => this.statusSignal().isLive && this.statusSignal().status === 'LIVE');
  isHalftime = computed(() => this.statusSignal().status === 'HT');

  constructor() {
    let previousStatus: 'SCHEDULED' | 'LIVE' | 'HT' | 'FT' = 'SCHEDULED';

    effect(() => {
      const status = this.statusSignal();
      const newMinute = status.minute;
      const currentMinuteValue = this.currentMinute();
      const isCurrentlyLive = status.isLive && status.status === 'LIVE';
      const wasTimerRunning = this.timerSubscription !== null;
      const isHalftimeToLive = previousStatus === 'HT' && status.status === 'LIVE';
      const shouldSyncTimer = (
        currentMinuteValue === 0 ||
        isHalftimeToLive
      );

      if (status.status === 'HT' || status.status === 'FT') {
        this.timerSubscription?.unsubscribe();
        this.timerSubscription = null;
        this.currentMinute.set(newMinute);
        this.currentSeconds.set(0);
      } else if (shouldSyncTimer && isCurrentlyLive) {
        this.timerSubscription?.unsubscribe();
        this.timerSubscription = null;
        this.currentMinute.set(newMinute);
        this.currentSeconds.set(0);
        this.timerSubscription = this.startTimer();
      } else if (isCurrentlyLive && !wasTimerRunning) {
        this.currentMinute.set(newMinute);
        this.currentSeconds.set(0);
        this.timerSubscription = this.startTimer();
      } else if (!isCurrentlyLive && wasTimerRunning) {
        this.timerSubscription?.unsubscribe();
        this.timerSubscription = null;
      }

      previousStatus = status.status;
    });
  }

  private startTimer(): Subscription {
    return interval(1000)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe(() => {
        const currentSecs = this.currentSeconds();
        const currentMins = this.currentMinute();

        if (currentSecs >= 59) {
          this.currentMinute.set(Math.min(currentMins + 1, 120));
          this.currentSeconds.set(0);
        } else {
          this.currentSeconds.set(currentSecs + 1);
        }
      });
  }
}
