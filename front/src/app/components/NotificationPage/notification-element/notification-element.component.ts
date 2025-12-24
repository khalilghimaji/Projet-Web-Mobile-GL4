import { Component, input, output } from '@angular/core';
import { MessagesModule } from 'primeng/messages';
import { DatePipe, NgStyle, NgIf } from '@angular/common';
import { Notification } from '../../../services/Api/model/notification';

@Component({
  selector: 'app-notification-element',
  imports: [MessagesModule, NgStyle, DatePipe, NgIf],
  templateUrl: './notification-element.component.html',
  styleUrls: ['./notification-element.component.css'],
  standalone: true,
})
export class NotificationElementComponent {
  notification = input.required<Notification>();
  markAsRead = output<Notification>();
  delete = output<Notification>();
  isRealTime = input.required<boolean>();

  ngOnInit() {
    console.log(this.isRealTime());
  }

  onMarkAsRead() {
    this.markAsRead.emit(this.notification());
  }

  onDelete() {
    this.delete.emit(this.notification());
  }
}
