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
        
        <ul class="nav-links">
          <li><a routerLink="/" routerLinkActive="active" [routerLinkActiveOptions]="{exact: true}">Inicio</a></li>
          <li><a routerLink="/catalog" routerLinkActive="active">Catálogo</a></li>
          <li><a routerLink="/contact" routerLinkActive="active">Contacto</a></li>
        </ul>
        
        <div class="nav-actions">
          <a *ngIf="!isAuthenticated" routerLink="/login" class="login-button">
            👤 Iniciar Sesión
          </a>
          <div *ngIf="isAuthenticated" class="user-menu">
            <a routerLink="/account" class="user-button">
              👤 {{ currentCustomer?.fullName }}
            </a>
          </div>
          <a routerLink="/cart" class="cart-button">
            <span class="cart-icon">🛒</span>
            <span class="cart-count" *ngIf="cartItemCount > 0">{{ cartItemCount }}</span>
          </a>
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
    }

    .logo {
      display: flex;
      align-items: center;
      gap: var(--spacing-sm);
      text-decoration: none;
      color: var(--color-white);
      font-size: var(--font-size-2xl);
      font-weight: bold;
    }

    .logo-img {
      height: 45px;
      width: auto;
      filter: brightness(0) invert(1);
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

    @media (max-width: 768px) {
      .nav-links {
        gap: var(--spacing-md);
      }
      
      .logo-text {
        display: none;
      }
    }
  `]
})
export class NavbarComponent implements OnInit {
  cartItemCount = 0;
  currentCustomer: EcommerceCustomer | null = null;
  isAuthenticated = false;

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

  logout() {
    this.authService.logout();
  }
}
