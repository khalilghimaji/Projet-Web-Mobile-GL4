import {
  ChangeDetectionStrategy,
  Component,
  ElementRef,
  input,
  output,
  viewChild,
  DestroyRef,
  inject,
} from '@angular/core';
import { MessageModule } from 'primeng/message';
import { DatePipe, NgStyle } from '@angular/common';
import { Notification } from '../../services/Api';
import { fromEvent, of } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { takeUntilDestroyed, toObservable } from '@angular/core/rxjs-interop';

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

  deleteButtonRef = viewChild<ElementRef<HTMLElement>>('onDeleteButton');
  markAsReadButtonRef =
    viewChild<ElementRef<HTMLElement>>('onMarkAsReadButton');

  private readonly destroRef = inject(DestroyRef);
  constructor() {
    // Delete button click
    toObservable(this.deleteButtonRef)
      .pipe(
        switchMap((ref) => {
          if (!ref?.nativeElement) {
            return of(null);
          }
          return fromEvent(ref.nativeElement, 'click').pipe(
            takeUntilDestroyed(this.destroRef),
          );
        }),
      )
      .subscribe((el) => !el || this.onDelete());

    // Mark as read button click
    toObservable(this.markAsReadButtonRef)
      .pipe(
        switchMap((ref) => {
          if (!ref?.nativeElement) {
            return of(null);
          }
          return fromEvent(ref.nativeElement, 'click').pipe(
            takeUntilDestroyed(this.destroRef),
          );
        }),
      )
      .subscribe((el) => !el || this.onMarkAsRead());
  }

  onMarkAsRead() {
    this.markAsRead.emit(this.notification());
  }

  onDelete() {
    this.delete.emit(this.notification());
  }
}
