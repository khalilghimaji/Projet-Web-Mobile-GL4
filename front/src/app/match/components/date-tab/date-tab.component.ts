import { Component, ChangeDetectionStrategy, input, output, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DateTab } from '../../types/fixture.types';

@Component({
  selector: 'app-date-tab',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './date-tab.component.html',
  styleUrls: ['./date-tab.component.css']
})
export class DateTabComponent {
  dateTab = input.required<DateTab>();
  selectedDate = input.required<Date>();
  tabClicked = output<Date>();

  isSelected = computed(() => {
    const tab = this.dateTab();
    const selected = this.selectedDate();
    return tab.date.toDateString() === selected.toDateString();
  });
}

