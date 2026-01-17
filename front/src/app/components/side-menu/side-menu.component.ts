import { Component, signal, ChangeDetectionStrategy } from '@angular/core';
import { AsyncPipe, CommonModule, NgOptimizedImage } from '@angular/common';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { DrawerModule } from 'primeng/drawer';
import { AuthService } from '../../services/auth.service';
import { NotificationsStateService } from '../../services/notifications-state.service';
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
    ImageDefaultPipe,
  ],
  templateUrl: './side-menu.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  styleUrls: ['./side-menu.component.css'],
})
export class SideMenuComponent {
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

  // Combined menu items for desktop menubar
  get menubarItems(): MenuItem[] {
    const items = [...this.topMenuItems];
    if (this.authService.isAuthenticated()) {
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
    public notificationsState: NotificationsStateService,
  ) {}

  get isAuthenticated() {
    return this.authService.isAuthenticated;
  }

  get diamonds() {
    return this.notificationsState.diamonds;
  }

  get gainedDiamonds() {
    return this.notificationsState.gainedDiamonds;
  }

  get unreadNotificationsCount() {
    return this.notificationsState.unreadCount;
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
