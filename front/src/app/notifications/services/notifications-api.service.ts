import { inject, Injectable, effect } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { Notification } from '../../services/Api/model/notification';
import { environment } from '../../../environments/environment';
import { NotificationsService } from '../../services/Api';
import { AuthService } from '../../auth/services/auth.service';

@Injectable({
  providedIn: 'root',
})
export class NotificationsApiService {
  private readonly notificationcontroller = inject(NotificationsService);
  private readonly authService = inject(AuthService);

  private eventSource: EventSource | null = null;
  private notificationsSubject = new Subject<Notification>();
  private shouldReconnect = true;
  private reconnectAttempts = 0;
  private maxReconnectAttempts = 10;
  private reconnectDelay = 1000; // Start with 1 second
  private isConnectionRequested = false;

  constructor() {
    // Automatically manage SSE connection based on authentication state
    effect(() => {
      const isAuthenticated = this.authService.isAuthenticated();

      if (isAuthenticated && this.isConnectionRequested) {
        // User is authenticated and connection was requested - connect
        this.shouldReconnect = true;
        if (!this.eventSource) {
          console.log('User authenticated - establishing SSE connection');
          this.createEventSource();
        }
      } else if (!isAuthenticated && this.eventSource) {
        // User is not authenticated - disconnect
        console.log('User not authenticated - closing SSE connection');
        this.disconnectSSE();
      }
    });
  }

  getUserNotifications() {
    return this.notificationcontroller.notificationsControllerGetUserNotifications();
  }

  markAsRead(notificationId: string) {
    return this.notificationcontroller.notificationsControllerMarkNotificationAsRead(
      notificationId,
    );
  }

  deleteNotification(notificationId: string) {
    return this.notificationcontroller.notificationsControllerDeleteNotification(
      notificationId,
    );
  }

  connectToSSE(): Observable<Notification> {
    this.isConnectionRequested = true;

    // Only create connection if user is authenticated
    if (this.authService.isAuthenticated() && !this.eventSource) {
      this.shouldReconnect = true;
      this.createEventSource();
    }

    return this.notificationsSubject.asObservable();
  }

  private createEventSource(): void {
    // Double-check authentication before creating connection
    if (!this.authService.isAuthenticated()) {
      console.log('Cannot create SSE connection - user not authenticated');
      return;
    }

    if (this.eventSource) {
      this.eventSource.close();
    }

    this.eventSource = new EventSource(
      `${environment.apiUrl}/notifications/sse`,
      {
        withCredentials: true,
      },
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

      // Only attempt reconnect if user is still authenticated
      if (
        this.shouldReconnect &&
        this.authService.isAuthenticated() &&
        this.reconnectAttempts < this.maxReconnectAttempts
      ) {
        this.reconnectAttempts++;
        const delay = Math.min(
          this.reconnectDelay * Math.pow(2, this.reconnectAttempts - 1),
          30000,
        );

        console.log(
          `Attempting to reconnect (${this.reconnectAttempts}/${this.maxReconnectAttempts}) in ${delay}ms...`,
        );

        setTimeout(() => {
          if (this.shouldReconnect && this.authService.isAuthenticated()) {
            this.createEventSource();
          }
        }, delay);
      } else if (this.reconnectAttempts >= this.maxReconnectAttempts) {
        console.error(
          'Max reconnection attempts reached. Please refresh the page.',
        );
      }
    };
  }

  disconnectSSE(): void {
    this.shouldReconnect = false;
    this.reconnectAttempts = 0;
    this.isConnectionRequested = false;

    if (this.eventSource) {
      this.eventSource.close();
      this.eventSource = null;
    }
  }
}
