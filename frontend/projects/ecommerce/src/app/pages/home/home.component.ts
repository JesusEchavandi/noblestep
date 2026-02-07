import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { ShopService } from '../../services/shop.service';
import { CartService } from '../../services/cart.service';
import { NotificationService } from '../../services/notification.service';
import { Product } from '../../models/product.model';
import { HeroSliderComponent } from '../../components/hero-slider/hero-slider.component';
import { LoadingSkeletonComponent } from '../../components/loading-skeleton/loading-skeleton.component';
import { ProductBadgeComponent } from '../../components/product-badge/product-badge.component';
import { TrustBadgesComponent } from '../../components/trust-badges/trust-badges.component';
import { CategoryGridComponent } from '../../components/category-grid/category-grid.component';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    CommonModule, 
    RouterModule, 
    HeroSliderComponent, 
    LoadingSkeletonComponent, 
    ProductBadgeComponent,
    TrustBadgesComponent,
    CategoryGridComponent
  ],
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  featuredProducts: Product[] = [];
  loading = true;

  constructor(
    private shopService: ShopService,
    private cartService: CartService,
    private notificationService: NotificationService
  ) {}

  ngOnInit() {
    this.loadFeaturedProducts();
  }

  loadFeaturedProducts() {
    this.loading = true;
    this.shopService.getFeaturedProducts(8).subscribe({
      next: (products) => {
        this.featuredProducts = products;
        this.loading = false;
      },
      error: (err) => {
        console.error('Error loading featured products:', err);
        this.notificationService.error('Error al cargar los productos destacados');
        this.loading = false;
      }
    });
  }

  addToCart(product: Product) {
    this.cartService.addToCart(product);
    this.notificationService.success(`✓ ${product.name} agregado al carrito`);
  }

  formatPrice(price: number): string {
    return `S/ ${price.toFixed(2)}`;
  }

  isNew(product: Product): boolean {
    // Considerar nuevo si fue creado en los últimos 30 días
    if (!product.createdAt) return false;
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    return new Date(product.createdAt) > thirtyDaysAgo;
  }

  isLowStock(product: Product): boolean {
    return product.stock > 0 && product.stock < 5;
  }
}
