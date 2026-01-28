import {
  Component,
  ChangeDetectionStrategy,
  output,
  Signal,
  Input,
  DestroyRef,
  inject,
  ElementRef,
  AfterViewInit
} from '@angular/core';
import { fromEvent } from 'rxjs';

export type TabType = 'OVERVIEW' | 'LINEUPS' | 'STATS' | 'H2H' | 'MEDIA';

export interface TabItem {
  id: TabType;
  label: string;
}

@Component({
  selector: 'app-tabs-navigation',
  standalone: true,
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './tabs-navigation.section.html',
  styleUrls: ['./tabs-navigation.section.css']
})
export class TabsNavigationSection implements AfterViewInit {
  @Input({required: true}) activeTabSignal!: Signal<TabType>;

  tabChanged = output<TabType>();

  private readonly elementRef = inject(ElementRef);
  private readonly destroyRef = inject(DestroyRef);

  readonly tabs: TabItem[] = [
    { id: 'OVERVIEW', label: 'Overview' },
    { id: 'LINEUPS', label: 'Lineups' },
    { id: 'STATS', label: 'Stats' },
    { id: 'H2H', label: 'H2H' },
    { id: 'MEDIA', label: 'Media' }
  ];

  ngAfterViewInit(): void {
    const buttons = this.elementRef.nativeElement.querySelectorAll('.tab-button');

    buttons.forEach((button: HTMLElement) => {
      const subscription = fromEvent(button, 'click').subscribe(() => {
        const tabId = button.getAttribute('data-tab-id') as TabType;
        if (tabId) {
          this.tabChanged.emit(tabId);
        }
      });

      this.destroyRef.onDestroy(() => subscription.unsubscribe());
    });
  }
}

