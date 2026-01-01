import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import {
  NavigationCancel,
  NavigationEnd,
  NavigationError,
  NavigationStart,
  Router,
} from '@angular/router';
import { filter } from 'rxjs/operators';

@Injectable({
  providedIn: 'root',
})
export class LoadingService {
  private loadingSubject = new BehaviorSubject<boolean>(false);
  private progressSubject = new BehaviorSubject<number>(0);

  // Observable streams for components to subscribe to
  public loading$ = this.loadingSubject.asObservable();
  public loadingProgress$ = this.progressSubject.asObservable();

  constructor(private router: Router) {
    // Track router events to show/hide loading indicator
    this.router.events
      .pipe(
        filter(
          (event) =>
            event instanceof NavigationStart ||
            event instanceof NavigationEnd ||
            event instanceof NavigationCancel ||
            event instanceof NavigationError
        )
      )
      .subscribe((event) => {
        if (event instanceof NavigationStart) {
          // Start with 20% progress when navigation begins
          this.progressSubject.next(20);
          this.loadingSubject.next(true);

          // Simulate progress while waiting for navigation to complete
          let progress = 20;
          const interval = setInterval(() => {
            if (progress < 65) {
              progress += 5;
              this.progressSubject.next(progress);
            } else {
              clearInterval(interval);
            }
          }, 250);
        } else if (
          event instanceof NavigationEnd ||
          event instanceof NavigationCancel ||
          event instanceof NavigationError
        ) {
          this.progressSubject.next(100);
          this.loadingSubject.next(false);
          // Reset progress after a short delay
          setTimeout(() => {
            if (!this.loadingSubject.value) {
              this.progressSubject.next(0);
            }
          }, 300);
        }
      });
  }
}
