import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { CartService } from '../../services/cart.service';
import { CartItem } from '../../models/product.model';
import { FreeShippingBarComponent } from '../../components/free-shipping-bar/free-shipping-bar.component';

@Component({
  selector: 'app-cart',
  standalone: true,
  imports: [CommonModule, RouterModule, FreeShippingBarComponent],
  templateUrl: './cart.component.html',
  styleUrls: ['./cart.component.css']
})
export class CartComponent implements OnInit {
  cartItems: CartItem[] = [];
  
  constructor(
    private cartService: CartService,
    private router: Router
  ) {}

  ngOnInit() {
    this.loadCart();
    this.cartService.cart$.subscribe(() => {
      this.loadCart();
    });
  }

  loadCart() {
    this.cartItems = this.cartService.getCartItems();
  }

  updateQuantity(productId: number, quantity: number) {
    if (quantity > 0) {
      this.cartService.updateQuantity(productId, quantity);
    }
  }

  removeItem(productId: number) {
    if (confirm('¿Estás seguro de eliminar este producto del carrito?')) {
      this.cartService.removeFromCart(productId);
    }
  }

  clearCart() {
    if (confirm('¿Estás seguro de vaciar todo el carrito?')) {
      this.cartService.clearCart();
    }
  }

  getSubtotal(): number {
    return this.cartService.getTotal();
  }

  getTotal(): number {
    return this.getSubtotal();
  }

  formatPrice(price: number): string {
    return `S/ ${price.toFixed(2)}`;
  }

  checkout() {
    // Redirigir a la página de checkout para completar el pago
    this.router.navigate(['/checkout']);
  }

  consultStock() {
    // Generar mensaje de WhatsApp para consulta de stock
    const message = this.generateStockConsultMessage();
    const phone = '51999999999'; // Número de WhatsApp de la tienda (cambiar por el real)
    const url = `https://wa.me/${phone}?text=${encodeURIComponent(message)}`;
    window.open(url, '_blank');
  }

  generateStockConsultMessage(): string {
    let message = '¡Hola! Me gustaría consultar la disponibilidad de los siguientes productos:\n\n';
    
    this.cartItems.forEach((item, index) => {
      message += `${index + 1}. ${item.product.name}\n`;
      message += `   Cantidad deseada: ${item.quantity}\n\n`;
    });
    
    message += '¿Están disponibles para entrega inmediata?';
    
    return message;
  }
}
