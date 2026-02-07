import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { ShopService } from '../../services/shop.service';
import { CartService } from '../../services/cart.service';
import { NotificationService } from '../../services/notification.service';
import { Product } from '../../models/product.model';

@Component({
  selector: 'app-product-detail',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  templateUrl: './product-detail.component.html',
  styleUrls: ['./product-detail.component.css']
})
export class ProductDetailComponent implements OnInit {
  product: Product | null = null;
  loading = true;
  quantity = 1;
  error = false;

  constructor(
    private route: ActivatedRoute,
    private shopService: ShopService,
    private cartService: CartService,
    private notificationService: NotificationService
  ) {}

  ngOnInit() {
    this.route.params.subscribe(params => {
      const id = +params['id'];
      this.loadProduct(id);
    });
  }

  loadProduct(id: number) {
    this.loading = true;
    this.error = false;
    
    this.shopService.getProduct(id).subscribe({
      next: (product) => {
        this.product = product;
        this.loading = false;
      },
      error: (err) => {
        console.error('Error loading product:', err);
        this.notificationService.error('Error al cargar el producto');
        this.loading = false;
        this.error = true;
      }
    });
  }

  increaseQuantity() {
    if (this.product && this.quantity < this.product.stock) {
      this.quantity++;
    } else if (this.product) {
      this.notificationService.warning(`Stock máximo disponible: ${this.product.stock}`);
    }
  }

  decreaseQuantity() {
    if (this.quantity > 1) {
      this.quantity--;
    }
  }

  addToCart() {
    if (this.product) {
      this.cartService.addToCart(this.product, this.quantity);
      this.notificationService.success(`✓ ${this.quantity} x ${this.product.name} agregado al carrito`);
      this.quantity = 1;
    }
  }

  formatPrice(price: number): string {
    return `S/ ${price.toFixed(2)}`;
  }
}
