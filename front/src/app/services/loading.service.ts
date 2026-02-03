import { Injectable } from '@angular/core';
import { BehaviorSubject, merge, timer } from 'rxjs';
import {
  NavigationCancel,
  NavigationEnd,
  NavigationError,
  NavigationStart,
  Router,
} from '@angular/router';
import { filter, switchMap, takeUntil, takeWhile, tap } from 'rxjs/operators';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

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
    const navigationEnd$ = this.router.events.pipe(
      filter(
        (event) =>
          event instanceof NavigationEnd ||
          event instanceof NavigationCancel ||
          event instanceof NavigationError,
      ),
    );

    const navigationStart$ = this.router.events.pipe(
      filter((event) => event instanceof NavigationStart),
      tap(() => {
        this.progressSubject.next(20);
        this.loadingSubject.next(true);
      }),
      switchMap(() => {
        let progress = 20;
        return timer(0, 250).pipe(
          takeUntil(navigationEnd$),
          takeWhile(() => progress < 65),
          tap(() => {
            progress += 5;
            this.progressSubject.next(progress);
          }),
        );
      }),
    );

    const navigationComplete$ = navigationEnd$.pipe(
      tap(() => {
        this.progressSubject.next(100);
        this.loadingSubject.next(false);
      }),
      switchMap(() =>
        timer(300).pipe(
          filter(() => !this.loadingSubject.value),
          tap(() => this.progressSubject.next(0)),
        ),
      ),
    );

    // Merge both streams and subscribe once
    merge(navigationStart$, navigationComplete$)
      .pipe(takeUntilDestroyed())
      .subscribe();
  }
}
