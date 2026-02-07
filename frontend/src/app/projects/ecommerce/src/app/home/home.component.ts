import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ShopService } from '../services/shop.service';
import { CartService } from '../services/cart.service';
import { ProductShop, CategoryShop } from '../models/shop.models';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent implements OnInit {
  featuredProducts = signal<ProductShop[]>([]);
  categories = signal<CategoryShop[]>([]);
  loading = signal<boolean>(true);
  cartCount = this.cartService.cartCount;

  constructor(
    private shopService: ShopService,
    private cartService: CartService
  ) {}

  ngOnInit(): void {
    this.loadData();
  }

  loadData(): void {
    this.loading.set(true);
    
    // Cargar productos destacados
    this.shopService.getFeaturedProducts(8).subscribe({
      next: (products) => {
        this.featuredProducts.set(products);
      },
      error: (error) => console.error('Error cargando productos:', error)
    });

    // Cargar categorías
    this.shopService.getCategories().subscribe({
      next: (categories) => {
        this.categories.set(categories);
        this.loading.set(false);
      },
      error: (error) => {
        console.error('Error cargando categorías:', error);
        this.loading.set(false);
      }
    });
  }

  addToCart(product: ProductShop, event: Event): void {
    event.stopPropagation();
    this.cartService.addToCart(product, 1);
  }

  getWhatsAppLink(): string {
    const phone = '51999999999'; // Cambiar por el número real
    const message = this.cartService.getWhatsAppMessage();
    return `https://wa.me/${phone}?text=${message}`;
  }
}
