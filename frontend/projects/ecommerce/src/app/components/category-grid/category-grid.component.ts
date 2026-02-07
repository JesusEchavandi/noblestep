import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { ShopService } from '../../services/shop.service';

@Component({
  selector: 'app-category-grid',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <section class="category-section">
      <div class="container">
        <h2 class="section-title">Explora por Categorías</h2>
        <div class="category-grid">
          @for (category of categories; track category.id) {
            <a [routerLink]="['/catalog']" [queryParams]="{category: category.id}" class="category-card">
              <div class="category-overlay"></div>
              <div class="category-content">
                <div class="category-icon">{{ category.icon }}</div>
                <h3 class="category-name">{{ category.name }}</h3>
                <p class="category-count">{{ category.productCount }} productos</p>
              </div>
            </a>
          }
        </div>
      </div>
    </section>
  `,
  styles: [`
    .category-section {
      padding: var(--spacing-2xl) 0;
      background: var(--color-white);
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 var(--spacing-xl);
    }

    .section-title {
      text-align: center;
      font-size: var(--font-size-3xl);
      margin-bottom: var(--spacing-2xl);
      color: var(--color-dark);
    }

    .category-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: var(--spacing-lg);
    }

    .category-card {
      position: relative;
      height: 200px;
      border-radius: var(--radius-lg);
      overflow: hidden;
      cursor: pointer;
      text-decoration: none;
      background: linear-gradient(135deg, var(--color-success) 0%, var(--color-secondary) 100%);
      transition: var(--transition-base);
      box-shadow: var(--shadow-md);
    }

    .category-card:nth-child(2) {
      background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
    }

    .category-card:nth-child(3) {
      background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-cream) 100%);
    }

    .category-card:nth-child(4) {
      background: linear-gradient(135deg, var(--color-cream) 0%, var(--color-success) 100%);
    }

    .category-overlay {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0, 0, 0, 0.2);
      transition: var(--transition-base);
    }

    .category-card:hover .category-overlay {
      background: rgba(0, 0, 0, 0.4);
    }

    .category-card:hover {
      transform: translateY(-5px);
      box-shadow: var(--shadow-xl);
    }

    .category-content {
      position: relative;
      z-index: 1;
      height: 100%;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      color: var(--color-white);
      text-align: center;
      padding: var(--spacing-lg);
    }

    .category-icon {
      font-size: 4rem;
      margin-bottom: var(--spacing-md);
      animation: float 3s ease-in-out infinite;
    }

    @keyframes float {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-10px); }
    }

    .category-name {
      font-size: var(--font-size-2xl);
      font-weight: bold;
      margin-bottom: var(--spacing-xs);
      text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
    }

    .category-count {
      font-size: var(--font-size-sm);
      opacity: 0.9;
    }

    @media (max-width: 768px) {
      .category-grid {
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
      }

      .category-card {
        height: 150px;
      }

      .category-icon {
        font-size: 3rem;
      }

      .category-name {
        font-size: var(--font-size-lg);
      }
    }
  `]
})
export class CategoryGridComponent implements OnInit {
  categories: any[] = [];

  constructor(private shopService: ShopService) {}

  ngOnInit() {
    this.loadCategories();
  }

  loadCategories() {
    this.shopService.getCategories().subscribe({
      next: (categories) => {
        this.categories = categories.map((cat: any, index: number) => ({
          ...cat,
          icon: this.getCategoryIcon(index),
          productCount: Math.floor(Math.random() * 50) + 10 // Temporal
        }));
      },
      error: (err) => console.error('Error loading categories:', err)
    });
  }

  getCategoryIcon(index: number): string {
    const icons = ['🛍️', '👔', '👟', '⌚', '💼', '🎒', '👓', '🎧'];
    return icons[index % icons.length];
  }
}
