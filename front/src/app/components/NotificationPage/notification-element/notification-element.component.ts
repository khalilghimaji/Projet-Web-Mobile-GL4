import { ChangeDetectionStrategy, Component, input, output } from '@angular/core';
import { MessageModule } from 'primeng/message';
import { DatePipe, NgStyle } from '@angular/common';
import { Notification } from '../../../services/Api/model/notification';

@Component({
  selector: 'app-notification-element',
  imports: [MessageModule, NgStyle, DatePipe],
  templateUrl: './notification-element.component.html',
  styleUrls: ['./notification-element.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  standalone: true,
})
export class NotificationElementComponent {
  notification = input.required<Notification>();
  markAsRead = output<Notification>();
  delete = output<Notification>();
  isRealTime = input.required<boolean>();

  onMarkAsRead() {
    this.markAsRead.emit(this.notification());
  }

  onDelete() {
    this.delete.emit(this.notification());
  }
}
