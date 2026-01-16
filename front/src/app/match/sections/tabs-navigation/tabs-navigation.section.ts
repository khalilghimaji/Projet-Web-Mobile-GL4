import {Component, ChangeDetectionStrategy, input, output, Signal, Input} from '@angular/core';
import { CommonModule } from '@angular/common';

export type TabType = 'OVERVIEW' | 'LINEUPS' | 'STATS' | 'H2H' | 'MEDIA';

export interface TabItem {
  id: TabType;
  label: string;
}

@Component({
  selector: 'app-tabs-navigation',
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="sticky top-[68px] z-40 bg-background-light dark:bg-background-dark pt-2 pb-2 px-4 overflow-x-auto no-scrollbar border-b border-gray-200 dark:border-white/5">
      <div class="flex space-x-6 min-w-max">
        @for (tab of tabs; track tab.id) {
          <button
            class="pb-2 text-sm transition-colors"
            [class.font-bold]="activeTabSignal() === tab.id"
            [class.text-slate-900]="activeTabSignal() === tab.id"
            [class.dark:text-white]="activeTabSignal() === tab.id"
            [class.border-b-2]="activeTabSignal() === tab.id"
            [class.border-primary]="activeTabSignal() === tab.id"
            [class.font-medium]="activeTabSignal() !== tab.id"
            [class.text-gray-500]="activeTabSignal() !== tab.id"
            [class.dark:text-gray-400]="activeTabSignal() !== tab.id"
            [class.hover:text-slate-900]="activeTabSignal() !== tab.id"
            [class.dark:hover:text-white]="activeTabSignal() !== tab.id"
            (click)="onTabClick(tab.id)"
          >
            {{ tab.label }}
          </button>
        }
      </div>
    </div>
  `,
  styles: [`
    :host {
      display: block;
    }

    .no-scrollbar::-webkit-scrollbar {
      display: none;
    }

    .no-scrollbar {
      -ms-overflow-style: none;
      scrollbar-width: none;
    }
  `]
})
export class TabsNavigationSection {
  // Signal reference from parent
  @Input({required: true}) activeTabSignal!: Signal<TabType>;
  // Output event for tab change
  tabChanged = output<TabType>();

  // Static tabs configuration
  tabs: TabItem[] = [
    { id: 'OVERVIEW', label: 'Overview' },
    { id: 'LINEUPS', label: 'Lineups' },
    { id: 'STATS', label: 'Stats' },
    { id: 'H2H', label: 'H2H' },
    { id: 'MEDIA', label: 'Media' }
  ];

  onTabClick(tabId: TabType): void {
    this.tabChanged.emit(tabId);
  }
}
