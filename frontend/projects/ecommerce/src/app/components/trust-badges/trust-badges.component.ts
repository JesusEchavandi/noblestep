import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-trust-badges',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="trust-badges">
      <div class="badge-item">
        <div class="icon">🔒</div>
        <div class="text">
          <strong>Compra Segura</strong>
          <span>Pago 100% Protegido</span>
        </div>
      </div>
      <div class="badge-item">
        <div class="icon">🚚</div>
        <div class="text">
          <strong>Envío Gratis</strong>
          <span>En pedidos +S/ 100</span>
        </div>
      </div>
      <div class="badge-item">
        <div class="icon">↩️</div>
        <div class="text">
          <strong>Devolución Fácil</strong>
          <span>Garantía 30 días</span>
        </div>
      </div>
      <div class="badge-item">
        <div class="icon">💳</div>
        <div class="text">
          <strong>Pago Seguro</strong>
          <span>Visa, Mastercard, Yape</span>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .trust-badges {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: var(--spacing-lg);
      padding: var(--spacing-xl);
      background: var(--color-background);
      border-radius: var(--radius-lg);
      margin: var(--spacing-xl) 0;
    }

    .badge-item {
      display: flex;
      align-items: center;
      gap: var(--spacing-md);
      padding: var(--spacing-md);
      background: var(--color-white);
      border-radius: var(--radius-md);
      transition: var(--transition-base);
      box-shadow: var(--shadow-sm);
    }

    .badge-item:hover {
      transform: translateY(-3px);
      box-shadow: var(--shadow-md);
    }

    .icon {
      font-size: var(--font-size-3xl);
      flex-shrink: 0;
    }

    .text {
      display: flex;
      flex-direction: column;
      gap: var(--spacing-xs);
    }

    .text strong {
      font-size: var(--font-size-base);
      color: var(--color-dark);
      font-weight: 600;
    }

    .text span {
      font-size: var(--font-size-sm);
      color: var(--color-text-secondary);
    }

    @media (max-width: 768px) {
      .trust-badges {
        grid-template-columns: 1fr;
      }
    }
  `]
})
export class TrustBadgesComponent {}
