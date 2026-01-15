import {defer, Observable, share} from 'rxjs';
import {webSocket} from 'rxjs/webSocket';
import {MatchEvent} from '../types/timeline.types';
import {Injectable} from '@angular/core';

@Injectable({ providedIn: 'root' })
export class LiveEventsService {
  private readonly closeDelayMs = 300;

  private socket$ = defer(() => {
    console.log('WS CONNECT');
    return webSocket<MatchEvent>('wss://example.com/live');
  });

  private subscribers = 0;
  private closeTimer: any = null;

  readonly events$ = new Observable<any>(observer => {
    this.subscribers++;

    if (this.closeTimer) {
      clearTimeout(this.closeTimer);
      this.closeTimer = null;
    }

    const sub = this.socket$.subscribe(observer);

    return () => {
      this.subscribers--;

      if (this.subscribers === 0) {
        this.closeTimer = setTimeout(() => {
          console.log('WS DISCONNECT');
          sub.unsubscribe();
        }, this.closeDelayMs);
      } else {
        sub.unsubscribe();
      }
    };
  }).pipe(share());
}
