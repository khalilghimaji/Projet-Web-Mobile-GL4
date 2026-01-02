import { Injectable } from '@angular/core';
import { AuthService } from './auth.service';
import { Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';

@Injectable({
  providedIn: 'root',
})
export class AuthInitializationService {
  constructor(private authService: AuthService) {}
  initializeAuth(): Observable<boolean> {
    return this.authService.getProfile().pipe(
      map((user) => {
        return true;
      }),
      catchError((error) => {
        console.log('error', error);
        return of(false);
      })
    );
  }
}
