import { inject, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
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
      this.eventSource.close();
    }

    this.eventSource = new EventSource(
      `${environment.apiUrl}/notifications/sse`,
      {
        withCredentials: true,
      }
    );

    this.eventSource.onmessage = (event) => {
      console.log('SSE message received:', event);
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
    };

    return this.notificationsSubject.asObservable();
  }

  disconnectSSE(): void {
    if (this.eventSource) {
      this.eventSource.close();
      this.eventSource = null;
    }
  }
}
