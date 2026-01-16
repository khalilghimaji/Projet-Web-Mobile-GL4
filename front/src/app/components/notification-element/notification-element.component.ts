import {
  ChangeDetectionStrategy,
  Component,
  ElementRef,
  input,
  output,
  viewChild,
  AfterViewInit,
} from '@angular/core';
import { MessageModule } from 'primeng/message';
import { DatePipe, NgStyle } from '@angular/common';
import { Notification } from '../../services/Api';
import { fromEvent } from 'rxjs';

@Component({
  selector: 'app-notification-element',
  imports: [MessageModule, NgStyle, DatePipe],
  templateUrl: './notification-element.component.html',
  styleUrls: ['./notification-element.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  standalone: true,
})
export class NotificationElementComponent implements AfterViewInit {
  notification = input.required<Notification>();
  markAsRead = output<Notification>();
  delete = output<Notification>();
  isRealTime = input.required<boolean>();

  deleteButtonRef = viewChild<ElementRef<HTMLElement>>('onDeleteButton');
  markAsReadButtonRef =
    viewChild<ElementRef<HTMLElement>>('onMarkAsReadButton');
  ngAfterViewInit() {
    const deletebutton = this.deleteButtonRef()?.nativeElement;
    if (deletebutton) {
      fromEvent(deletebutton, 'click').subscribe(() => {
        this.onDelete();
      });
    }
    const markAsReadButton = this.markAsReadButtonRef()?.nativeElement;
    if (markAsReadButton) {
      fromEvent(markAsReadButton, 'click').subscribe(() => {
        this.onMarkAsRead();
      });
    }
  }

  onMarkAsRead() {
    this.markAsRead.emit(this.notification());
  }

  onDelete() {
    this.delete.emit(this.notification());
  }
}
