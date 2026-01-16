import { inject, Injectable } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { Notification } from './Api/model/notification';
import { environment } from '../../environments/environment';
import { NotificationsService } from './Api';

@Injectable({
  providedIn: 'root',
})
export class NotificationsApiService {
  private eventSource: EventSource | null = null;
  private notificationsSubject = new Subject<Notification>();
  private shouldReconnect = true;
  private reconnectAttempts = 0;
  private maxReconnectAttempts = 10;
  private reconnectDelay = 1000; // Start with 1 second

  private readonly notificationcontroller = inject(NotificationsService);
  constructor() {}

  getUserNotifications() {
    return this.notificationcontroller.notificationsControllerGetUserNotifications();
  }

  markAsRead(notificationId: string) {
    return this.notificationcontroller.notificationsControllerMarkNotificationAsRead(
      notificationId
    );
  }

  deleteNotification(notificationId: string) {
    return this.notificationcontroller.notificationsControllerDeleteNotification(
      notificationId
    );
  }

  connectToSSE(): Observable<Notification> {
    if (this.eventSource) {
      return this.notificationsSubject.asObservable();
    }

    this.shouldReconnect = true;
    this.createEventSource();

    return this.notificationsSubject.asObservable();
  }

  private createEventSource(): void {
    if (this.eventSource) {
      this.eventSource.close();
    }

    this.eventSource = new EventSource(
      `${environment.apiUrl}/notifications/sse`,
      {
        withCredentials: true,
      }
    );

    this.eventSource.onopen = () => {
      console.log('SSE connection established');
      this.reconnectAttempts = 0;
      this.reconnectDelay = 1000;
    };

    this.eventSource.onmessage = (event) => {
      if (event.data !== 'ping') {
        try {
          const notification: Notification = JSON.parse(event.data);
          this.notificationsSubject.next(notification);
        } catch (error) {
          console.error('Error parsing SSE data:', error);
        }
      }
    };

    this.eventSource.onerror = (error) => {
      console.error('SSE error:', error);

      if (this.eventSource) {
        this.eventSource.close();
        this.eventSource = null;
      }

      if (
        this.shouldReconnect &&
        this.reconnectAttempts < this.maxReconnectAttempts
      ) {
        this.reconnectAttempts++;
        const delay = Math.min(
          this.reconnectDelay * Math.pow(2, this.reconnectAttempts - 1),
          30000
        );

        console.log(
          `Attempting to reconnect (${this.reconnectAttempts}/${this.maxReconnectAttempts}) in ${delay}ms...`
        );

        setTimeout(() => {
          if (this.shouldReconnect) {
            this.createEventSource();
          }
        }, delay);
      } else if (this.reconnectAttempts >= this.maxReconnectAttempts) {
        console.error(
          'Max reconnection attempts reached. Please refresh the page.'
        );
      }
    };
  }

  disconnectSSE(): void {
    this.shouldReconnect = false;
    this.reconnectAttempts = 0;

    if (this.eventSource) {
      this.eventSource.close();
      this.eventSource = null;
    }
  }
}
