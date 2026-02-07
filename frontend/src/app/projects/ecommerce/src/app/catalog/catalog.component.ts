import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, ActivatedRoute } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { ShopService } from '../services/shop.service';
import { CartService } from '../services/cart.service';
import { ProductShop, CategoryShop } from '../models/shop.models';

@Component({
  selector: 'app-catalog',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './catalog.component.html',
  styleUrl: './catalog.component.css'
})
export class CatalogComponent implements OnInit {
  products = signal<ProductShop[]>([]);
  categories = signal<CategoryShop[]>([]);
  loading = signal<boolean>(true);
  cartCount = this.cartService.cartCount;

  // Filtros
  selectedCategoryId = signal<number | undefined>(undefined);
  searchText = signal<string>('');
  minPrice = signal<number | undefined>(undefined);
  maxPrice = signal<number | undefined>(undefined);

  constructor(
    private shopService: ShopService,
    private cartService: CartService,
    private route: ActivatedRoute
  ) {}

  ngOnInit(): void {
    // Cargar categorías
    this.shopService.getCategories().subscribe({
      next: (categories) => this.categories.set(categories),
      error: (error) => console.error('Error cargando categorías:', error)
    });

    // Verificar si hay categoryId en query params
    this.route.queryParams.subscribe(params => {
      if (params['categoryId']) {
        this.selectedCategoryId.set(+params['categoryId']);
      }
      this.loadProducts();
    });
  }

  loadProducts(): void {
    this.loading.set(true);
    
    const filters = {
      categoryId: this.selectedCategoryId(),
      search: this.searchText() || undefined,
      minPrice: this.minPrice(),
      maxPrice: this.maxPrice(),
      inStock: true
    };

    this.shopService.getProducts(filters).subscribe({
      next: (products) => {
        this.products.set(products);
        this.loading.set(false);
      },
      error: (error) => {
        console.error('Error cargando productos:', error);
        this.loading.set(false);
      }
    });
  }

  onCategoryChange(categoryId: number | undefined): void {
    this.selectedCategoryId.set(categoryId);
    this.loadProducts();
  }

  onSearchChange(search: string): void {
    this.searchText.set(search);
    this.loadProducts();
  }

  onPriceFilterChange(): void {
    this.loadProducts();
  }

  clearFilters(): void {
    this.selectedCategoryId.set(undefined);
    this.searchText.set('');
    this.minPrice.set(undefined);
    this.maxPrice.set(undefined);
    this.loadProducts();
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
