import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterOutlet } from '@angular/router';
import { MenuItem } from 'primeng/api';
import { MenubarModule } from 'primeng/menubar';
import { ButtonModule } from 'primeng/button';
import { Toast } from 'primeng/toast';
import { SideMenuComponent } from './components/side-menu/side-menu.component';
import { AuthService } from './services/auth.service';
import { LoadingComponent } from './components/loading/loading.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    RouterOutlet,
    MenubarModule,
    ButtonModule,
    Toast,
    SideMenuComponent,
    LoadingComponent,
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
})
export class AppComponent implements OnInit {
  title = 'KickStream';
  menuItems: MenuItem[] = [];

  constructor(private router: Router, private authService: AuthService) {}

  ngOnInit() {
    this.menuItems = [
      {
        label: 'Home',
        icon: 'pi pi-home',
        routerLink: '/',
      },
      {
        label: 'Categories',
        icon: 'pi pi-list',
        items: [
          { label: 'Fiction', routerLink: ['/'] },
          { label: 'Non-Fiction', routerLink: ['/'] },
          { label: 'Science', routerLink: ['/'] },
          { label: 'Technology', routerLink: ['/'] },
          { label: 'History', routerLink: ['/'] },
        ],
      },
      {
        label: 'About',
        icon: 'pi pi-info-circle',
      },
    ];
  }
}
