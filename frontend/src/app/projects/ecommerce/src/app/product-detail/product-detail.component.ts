import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, ActivatedRoute, Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { ShopService } from '../services/shop.service';
import { CartService } from '../services/cart.service';
import { ProductShop } from '../models/shop.models';

@Component({
  selector: 'app-product-detail',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './product-detail.component.html',
  styleUrl: './product-detail.component.css'
})
export class ProductDetailComponent implements OnInit {
  product = signal<ProductShop | null>(null);
  loading = signal<boolean>(true);
  quantity = signal<number>(1);
  cartCount = this.cartService.cartCount;

  constructor(
    private shopService: ShopService,
    private cartService: CartService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      const id = +params['id'];
      if (id) {
        this.loadProduct(id);
      }
    });
  }

  loadProduct(id: number): void {
    this.loading.set(true);
    this.shopService.getProduct(id).subscribe({
      next: (product) => {
        this.product.set(product);
        this.loading.set(false);
      },
      error: (error) => {
        console.error('Error cargando producto:', error);
        this.loading.set(false);
        // Redirigir al catálogo si no se encuentra el producto
        this.router.navigate(['/catalog']);
      }
    });
  }

  increaseQuantity(): void {
    const product = this.product();
    if (product && this.quantity() < product.stock) {
      this.quantity.update(q => q + 1);
    }
  }

  decreaseQuantity(): void {
    if (this.quantity() > 1) {
      this.quantity.update(q => q - 1);
    }
  }

  addToCart(): void {
    const product = this.product();
    if (product) {
      this.cartService.addToCart(product, this.quantity());
      // Mostrar notificación (opcional)
      alert(`${this.quantity()} unidad(es) agregadas al carrito`);
    }
  }

  buyNow(): void {
    const product = this.product();
    if (product) {
      this.cartService.addToCart(product, this.quantity());
      const phone = '51999999999'; // Cambiar por el número real
      const message = this.cartService.getWhatsAppMessage();
      window.open(`https://wa.me/${phone}?text=${message}`, '_blank');
    }
  }

  getWhatsAppLink(): string {
    const phone = '51999999999';
    const message = this.cartService.getWhatsAppMessage();
    return `https://wa.me/${phone}?text=${message}`;
  }
}
