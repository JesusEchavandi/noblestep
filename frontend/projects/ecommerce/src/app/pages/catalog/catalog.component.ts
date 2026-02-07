import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { ShopService } from '../../services/shop.service';
import { CartService } from '../../services/cart.service';
import { NotificationService } from '../../services/notification.service';
import { Product, Category } from '../../models/product.model';

@Component({
  selector: 'app-catalog',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  templateUrl: './catalog.component.html',
  styleUrls: ['./catalog.component.css']
})
export class CatalogComponent implements OnInit {
  products: Product[] = [];
  categories: Category[] = [];
  loading = true;
  
  // Filtros
  selectedCategoryId: number | null = null;
  searchTerm = '';
  minPrice: number | null = null;
  maxPrice: number | null = null;

  constructor(
    private shopService: ShopService,
    private cartService: CartService,
    private notificationService: NotificationService
  ) {}

  ngOnInit() {
    this.loadCategories();
    this.loadProducts();
  }

  loadCategories() {
    this.shopService.getCategories().subscribe({
      next: (categories) => {
        this.categories = categories;
      },
      error: (err) => {
        console.error('Error loading categories:', err);
        this.notificationService.error('Error al cargar las categorías');
      }
    });
  }

  loadProducts() {
    this.loading = true;
    this.shopService.getProducts(
      this.selectedCategoryId || undefined,
      this.searchTerm || undefined,
      this.minPrice || undefined,
      this.maxPrice || undefined
    ).subscribe({
      next: (products) => {
        this.products = products;
        this.loading = false;
      },
      error: (err) => {
        console.error('Error loading products:', err);
        this.notificationService.error('Error al cargar los productos');
        this.loading = false;
      }
    });
  }

  onCategoryChange(categoryId: number | null) {
    this.selectedCategoryId = categoryId;
    this.loadProducts();
  }

  onSearch() {
    this.loadProducts();
  }

  onPriceFilter() {
    this.loadProducts();
  }

  clearFilters() {
    this.selectedCategoryId = null;
    this.searchTerm = '';
    this.minPrice = null;
    this.maxPrice = null;
    this.loadProducts();
  }

  addToCart(product: Product) {
    this.cartService.addToCart(product);
    this.notificationService.success(`✓ ${product.name} agregado al carrito`);
  }

  formatPrice(price: number): string {
    return `S/ ${price.toFixed(2)}`;
  }
}
