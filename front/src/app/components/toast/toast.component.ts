import { ChangeDetectionStrategy, Component } from '@angular/core';
import { Toast } from 'primeng/toast';
@Component({
  selector: 'app-toast',
  standalone: true,
  imports: [Toast],
  template: '<p-toast position="top-right"></p-toast>',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ToastComponent {
  constructor() {}
}
