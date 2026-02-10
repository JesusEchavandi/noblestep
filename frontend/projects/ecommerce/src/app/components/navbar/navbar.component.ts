import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { CartService } from '../../services/cart.service';
import { EcommerceAuthService, EcommerceCustomer } from '../../services/ecommerce-auth.service';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <nav class="navbar">
      <div class="container">
        <a routerLink="/" class="logo">
          <img src="/logo.svg" alt="NobleStep" class="logo-img">
          <span class="logo-text">NobleStep Shop</span>
        </a>
        
        <!-- Mobile Menu Toggle -->
        <button class="menu-toggle" (click)="toggleMenu()" [class.active]="menuOpen">
          <span></span>
          <span></span>
          <span></span>
        </button>
        
        <!-- Navigation Menu -->
        <div class="nav-menu" [class.open]="menuOpen">
          <ul class="nav-links">
            <li><a routerLink="/" routerLinkActive="active" [routerLinkActiveOptions]="{exact: true}" (click)="closeMenu()">Inicio</a></li>
            <li><a routerLink="/catalog" routerLinkActive="active" (click)="closeMenu()">Catálogo</a></li>
            <li><a routerLink="/contact" routerLinkActive="active" (click)="closeMenu()">Contacto</a></li>
          </ul>
          
          <div class="nav-actions">
            <a *ngIf="!isAuthenticated" routerLink="/login" class="login-button" (click)="closeMenu()">
              👤 <span class="btn-text">Iniciar Sesión</span>
            </a>
            <div *ngIf="isAuthenticated" class="user-menu">
              <a routerLink="/account" class="user-button" (click)="closeMenu()">
                👤 <span class="user-name">{{ currentCustomer?.fullName }}</span>
              </a>
            </div>
            <a routerLink="/cart" class="cart-button" (click)="closeMenu()">
              <span class="cart-icon">🛒</span>
              <span class="cart-count" *ngIf="cartItemCount > 0">{{ cartItemCount }}</span>
            </a>
          </div>
        </div>
      </div>
    </nav>
  `,
  styles: [`
    .navbar {
      background: var(--color-dark);
      padding: 1rem 0;
      box-shadow: var(--shadow-lg);
      position: sticky;
      top: 0;
      z-index: 1000;
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 var(--spacing-xl);
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: relative;
    }

    .logo {
      display: flex;
      align-items: center;
      gap: var(--spacing-sm);
      text-decoration: none;
      color: var(--color-white);
      font-size: var(--font-size-2xl);
      font-weight: bold;
      z-index: 1001;
    }

    .logo-img {
      height: 45px;
      width: auto;
      filter: brightness(0) invert(1);
    }

    /* Mobile Menu Toggle */
    .menu-toggle {
      display: none;
      flex-direction: column;
      gap: 5px;
      background: transparent;
      border: none;
      cursor: pointer;
      z-index: 1001;
      padding: 5px;
    }

    .menu-toggle span {
      display: block;
      width: 25px;
      height: 3px;
      background: var(--color-white);
      transition: var(--transition-base);
      border-radius: 2px;
    }

    .menu-toggle.active span:nth-child(1) {
      transform: translateY(8px) rotate(45deg);
    }

    .menu-toggle.active span:nth-child(2) {
      opacity: 0;
    }

    .menu-toggle.active span:nth-child(3) {
      transform: translateY(-8px) rotate(-45deg);
    }

    /* Nav Menu */
    .nav-menu {
      display: flex;
      align-items: center;
      gap: var(--spacing-2xl);
    }

    .nav-links {
      display: flex;
      list-style: none;
      gap: var(--spacing-xl);
      margin: 0;
      padding: 0;
    }

    .nav-links a {
      color: var(--color-white);
      text-decoration: none;
      font-weight: 500;
      transition: var(--transition-base);
      padding: var(--spacing-sm);
    }

    .nav-links a:hover,
    .nav-links a.active {
      color: var(--color-cream);
      text-decoration: underline;
    }

    .nav-actions {
      display: flex;
      gap: var(--spacing-md);
      align-items: center;
    }

    .login-button,
    .user-button,
    .cart-button {
      position: relative;
      background: var(--color-success);
      color: var(--color-white);
      padding: var(--spacing-sm) var(--spacing-md);
      border-radius: var(--radius-full);
      text-decoration: none;
      display: flex;
      align-items: center;
      gap: var(--spacing-sm);
      transition: var(--transition-base);
      font-weight: 500;
      box-shadow: var(--shadow-sm);
      white-space: nowrap;
    }

    .login-button:hover,
    .user-button:hover,
    .cart-button:hover {
      background: var(--color-secondary);
      transform: translateY(-2px);
      box-shadow: var(--shadow-md);
    }

    .cart-icon {
      font-size: var(--font-size-2xl);
    }

    .cart-count {
      background: var(--color-primary);
      color: var(--color-white);
      border-radius: var(--radius-full);
      padding: 0.2rem 0.5rem;
      font-size: var(--font-size-xs);
      font-weight: bold;
      min-width: 20px;
      text-align: center;
    }

    /* Responsive Design */
    @media (max-width: 992px) {
      .menu-toggle {
        display: flex;
      }

      .nav-menu {
        position: fixed;
        top: 0;
        right: -100%;
        width: 280px;
        height: 100vh;
        background: var(--color-dark);
        flex-direction: column;
        align-items: flex-start;
        padding: 80px 2rem 2rem;
        gap: var(--spacing-xl);
        transition: right 0.3s ease-in-out;
        box-shadow: -5px 0 15px rgba(0,0,0,0.3);
        overflow-y: auto;
      }

      .nav-menu.open {
        right: 0;
      }

      .nav-links {
        flex-direction: column;
        gap: var(--spacing-md);
        width: 100%;
      }

      .nav-links li {
        width: 100%;
      }

      .nav-links a {
        display: block;
        padding: var(--spacing-md);
        border-bottom: 1px solid rgba(255,255,255,0.1);
        font-size: var(--font-size-lg);
      }

      .nav-actions {
        flex-direction: column;
        width: 100%;
        gap: var(--spacing-sm);
      }

      .login-button,
      .user-button,
      .cart-button {
        width: 100%;
        justify-content: center;
        padding: var(--spacing-md);
        font-size: var(--font-size-lg);
      }

      .logo-text {
        display: none;
      }

      /* Overlay when menu is open */
      .nav-menu.open::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        right: 280px;
        bottom: 0;
        background: rgba(0,0,0,0.5);
        z-index: -1;
      }
    }

    @media (max-width: 480px) {
      .container {
        padding: 0 var(--spacing-md);
      }

      .logo-img {
        height: 35px;
      }

      .nav-menu {
        width: 100%;
        right: -100%;
      }

      .nav-menu.open::before {
        right: 0;
      }

      .btn-text {
        display: inline;
      }

      .user-name {
        max-width: 150px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
    }
  `]
})
export class NavbarComponent implements OnInit {
  cartItemCount = 0;
  currentCustomer: EcommerceCustomer | null = null;
  isAuthenticated = false;
  menuOpen = false;

  constructor(
    private cartService: CartService,
    private authService: EcommerceAuthService
  ) {}

  ngOnInit() {
    this.cartService.cart$.subscribe(() => {
      this.cartItemCount = this.cartService.getItemCount();
    });

    this.authService.currentCustomer$.subscribe(customer => {
      this.currentCustomer = customer;
      this.isAuthenticated = !!customer;
    });
  }

  toggleMenu() {
    this.menuOpen = !this.menuOpen;
  }

  closeMenu() {
    this.menuOpen = false;
  }

  logout() {
    this.authService.logout();
  }
}
