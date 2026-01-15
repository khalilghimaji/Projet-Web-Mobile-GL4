import {
  Component,
  signal,
  OnInit,
  OnDestroy,
  ChangeDetectionStrategy,
  viewChild,
  ElementRef,
  AfterViewInit,
  viewChildren,
} from '@angular/core';
import { AsyncPipe, CommonModule, NgOptimizedImage } from '@angular/common';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { DrawerModule } from 'primeng/drawer';
import { AuthService } from '../../services/auth.service';
import { NotificationsApiService } from '../../services/notifications-api.service';
import { filter, fromEvent, Subscription } from 'rxjs';
import { ImageDefaultPipe } from '../../shared/pipes/image-default.pipe';
import { MenuItem } from 'primeng/api';

interface CustomMenuItem {
  icon: string;
  label: string;
  route?: string;
  active?: boolean;
  badge?: number;
  hasChildren?: boolean;
  children?: CustomMenuItem[];
}

@Component({
  selector: 'app-side-menu',
  standalone: true,
  imports: [
    CommonModule,
    RouterLink,
    RouterLinkActive,
    NgOptimizedImage,
    DrawerModule,
    AsyncPipe,
    ImageDefaultPipe,
  ],
  templateUrl: './side-menu.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  styleUrls: ['./side-menu.component.css'],
})
export class SideMenuComponent implements OnInit, OnDestroy, AfterViewInit {
  isMenuOpen = signal(false);

  // Desktop menubar expanded states
  isTopMenuExpanded = signal(false);
  isBottomMenuExpanded = signal(false);
  isAuthMenuExpanded = signal(false);

  topMenuItems: CustomMenuItem[] = [
    {
      icon: 'pi pi-chart-bar',
      label: 'Standings',
      route: '/standings',
    },
  ];

  authMenuItems: CustomMenuItem[] = [
    {
      icon: 'pi pi-user',
      label: 'Login',
      route: '/login',
    },
    {
      icon: 'pi pi-user-plus',
      label: 'Sign Up',
      route: '/signup',
    },
    {
      icon: 'pi pi-lock',
      label: 'Forgot Password',
      route: '/forget-password',
    },
  ];

  bottomMenuItems: CustomMenuItem[] = [
    {
      icon: 'pi pi-bell',
      label: 'Notifications',
      route: '/notifications',
    },
    {
      icon: 'pi pi-crown',
      label: 'Diamond Store',
      route: '/diamond-store',
    },
    {
      icon: 'pi pi-trophy',
      label: 'Rankings',
      route: '/rankings',
    },
    {
      icon: 'pi pi-shield',
      label: 'Security Settings',
      route: '/mfa-setup',
    },
  ];

  diamonds = signal(0);
  gainedDiamonds = signal(0);
  private sseSubscription: Subscription | null = null;

  toggleButtonsRef = viewChildren<ElementRef<HTMLElement>>('toggleMenuButtons');
  logoutButtonsRef = viewChildren<ElementRef<HTMLElement>>('logOutButtons');
  toggleAuthButtonRef = viewChild<ElementRef<HTMLElement>>(
    'toggleAuthMenuButton'
  );

  toggleBottomMenuRef = viewChild<ElementRef<HTMLElement>>(
    'toggleBottomMenuButton'
  );

  toggleTopMenuRef = viewChild<ElementRef<HTMLElement>>('toggleTopMenuButton');
  ngAfterViewInit(): void {
    for (const buttonRef of this.toggleButtonsRef()) {
      const button = buttonRef?.nativeElement;
      if (button) {
        fromEvent(button, 'click').subscribe(() => this.toggleMenu());
      }
    }

    for (const logoutButtonRef of this.logoutButtonsRef()) {
      const button = logoutButtonRef?.nativeElement;
      if (button) {
        fromEvent(button, 'click').subscribe(() => this.toggleMenu());
      }
    }

    const authButton = this.toggleAuthButtonRef()?.nativeElement;
    if (authButton) {
      fromEvent(authButton, 'click').subscribe(() => this.toggleAuthMenu());
    }

    const bottomMenuButton = this.toggleBottomMenuRef()?.nativeElement;
    if (bottomMenuButton) {
      fromEvent(bottomMenuButton, 'click').subscribe(() =>
        this.toggleBottomMenu()
      );
    }

    const topMenuButton = this.toggleTopMenuRef()?.nativeElement;
    if (topMenuButton) {
      fromEvent(topMenuButton, 'click').subscribe(() => this.toggleTopMenu());
    }
  }
  get menubarItems(): MenuItem[] {
    const items = [...this.topMenuItems];
    if (this.authService.authStateSignal()) {
      items.push(...this.bottomMenuItems);
    }
    return items.map((item) => ({
      label: item.label,
      icon: item.icon,
      route: item.route,
      badge: item.badge?.toString(),
      items: item.children?.map((child) => ({
        label: child.label,
        icon: child.icon,
        route: child.route,
        badge: child.badge?.toString(),
      })),
    }));
  }
  constructor(
    public authService: AuthService,
    private notificationsApi: NotificationsApiService
  ) {
    this.authService.currentUser$.subscribe((user) => {
      if (user && 'diamonds' in user) {
        this.diamonds.set(user.diamonds ?? 0);
      }
    });
  }

  ngOnInit(): void {
    this.connectToSSE();
  }

  ngOnDestroy(): void {
    this.disconnectSSE();
  }

  private connectToSSE(): void {
    this.sseSubscription = this.notificationsApi
      .connectToSSE()
      .pipe(
        filter(
          (event) =>
            event.type === 'CHANGE_OF_POSSESSED_GEMS' ||
            event.type === 'DIAMOND_UPDATE'
        )
      )
      .subscribe({
        next: (notification) => {
          if (
            notification.type === 'CHANGE_OF_POSSESSED_GEMS' &&
            notification.data?.newDiamonds
          ) {
            this.diamonds.set(notification.data?.newDiamonds);
          }
          if (notification.type === 'DIAMOND_UPDATE') {
            this.gainedDiamonds.set(Number(notification.data?.gain) || 0);
          }
        },
        error: (error) => {
          console.error('SSE error:', error);
        },
      });
  }
  get isAuthenticated() {
    return this.authService.authState$;
  }
  private disconnectSSE(): void {
    if (this.sseSubscription) {
      this.sseSubscription.unsubscribe();
    }
    this.notificationsApi.disconnectSSE();
  }

  toggleMenu() {
    this.isMenuOpen.set(!this.isMenuOpen());
  }

  toggleTopMenu() {
    this.isTopMenuExpanded.set(!this.isTopMenuExpanded());
    this.isBottomMenuExpanded.set(false);
    this.isAuthMenuExpanded.set(false);
  }

  toggleBottomMenu() {
    this.isBottomMenuExpanded.set(!this.isBottomMenuExpanded());
    this.isTopMenuExpanded.set(false);
    this.isAuthMenuExpanded.set(false);
  }

  toggleAuthMenu() {
    this.isAuthMenuExpanded.set(!this.isAuthMenuExpanded());
    this.isTopMenuExpanded.set(false);
    this.isBottomMenuExpanded.set(false);
  }

  onLogout() {
    this.authService.logout();
    this.isMenuOpen.set(false);
  }
}
