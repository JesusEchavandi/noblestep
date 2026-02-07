import { Injectable, signal } from '@angular/core';
import { CartItem, ProductShop } from '../models/shop.models';

@Injectable({
  providedIn: 'root'
})
export class CartService {
  private readonly CART_STORAGE_KEY = 'noblestep_cart';
  
  cartItems = signal<CartItem[]>(this.loadCart());
  cartCount = signal<number>(0);
  cartTotal = signal<number>(0);

  constructor() {
    this.updateCartMetrics();
  }

  private loadCart(): CartItem[] {
    const stored = localStorage.getItem(this.CART_STORAGE_KEY);
    return stored ? JSON.parse(stored) : [];
  }

  private saveCart(): void {
    localStorage.setItem(this.CART_STORAGE_KEY, JSON.stringify(this.cartItems()));
    this.updateCartMetrics();
  }

  private updateCartMetrics(): void {
    const items = this.cartItems();
    this.cartCount.set(items.reduce((sum, item) => sum + item.quantity, 0));
    this.cartTotal.set(items.reduce((sum, item) => sum + (item.product.salePrice * item.quantity), 0));
  }

  addToCart(product: ProductShop, quantity: number = 1): void {
    const items = this.cartItems();
    const existingItem = items.find(item => item.product.id === product.id);

    if (existingItem) {
      // Verificar que no exceda el stock
      const newQuantity = existingItem.quantity + quantity;
      if (newQuantity <= product.stock) {
        existingItem.quantity = newQuantity;
      } else {
        existingItem.quantity = product.stock;
      }
    } else {
      items.push({ product, quantity: Math.min(quantity, product.stock) });
    }

    this.cartItems.set([...items]);
    this.saveCart();
  }

  removeFromCart(productId: number): void {
    const items = this.cartItems().filter(item => item.product.id !== productId);
    this.cartItems.set(items);
    this.saveCart();
  }

  updateQuantity(productId: number, quantity: number): void {
    const items = this.cartItems();
    const item = items.find(i => i.product.id === productId);
    
    if (item) {
      if (quantity <= 0) {
        this.removeFromCart(productId);
      } else {
        item.quantity = Math.min(quantity, item.product.stock);
        this.cartItems.set([...items]);
        this.saveCart();
      }
    }
  }

  clearCart(): void {
    this.cartItems.set([]);
    localStorage.removeItem(this.CART_STORAGE_KEY);
    this.updateCartMetrics();
  }

  getWhatsAppMessage(): string {
    const items = this.cartItems();
    let message = '¡Hola! Me gustaría realizar el siguiente pedido:\n\n';
    
    items.forEach(item => {
      message += `• ${item.product.name}\n`;
      message += `  Cantidad: ${item.quantity}\n`;
      message += `  Precio unitario: S/ ${item.product.salePrice.toFixed(2)}\n`;
      message += `  Subtotal: S/ ${(item.product.salePrice * item.quantity).toFixed(2)}\n\n`;
    });
    
    message += `*Total: S/ ${this.cartTotal().toFixed(2)}*\n\n`;
    message += 'Gracias!';
    
    return encodeURIComponent(message);
  }
}
