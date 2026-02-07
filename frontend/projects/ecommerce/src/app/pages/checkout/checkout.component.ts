import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { CartService, CartItem } from '../../services/cart.service';
import { NotificationService } from '../../services/notification.service';
import { OrderService, CreateOrderData } from '../../services/order.service';
import { EcommerceAuthService } from '../../services/ecommerce-auth.service';
import { CheckoutProgressComponent } from '../../components/checkout-progress/checkout-progress.component';

@Component({
  selector: 'app-checkout',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule, CheckoutProgressComponent],
  templateUrl: './checkout.component.html',
  styleUrls: ['./checkout.component.css']
})
export class CheckoutComponent implements OnInit {
  cartItems: CartItem[] = [];
  
  // Datos del cliente
  customerData = {
    fullName: '',
    email: '',
    phone: '',
    address: '',
    city: '',
    district: '',
    reference: ''
  };
  
  // Método de pago seleccionado
  paymentMethod: 'yape' | 'card' | 'transfer' = 'yape';
  
  // Datos de pago
  paymentData = {
    // Para Yape
    yapePhone: '',
    
    // Para tarjeta
    cardNumber: '',
    cardName: '',
    cardExpiry: '',
    cardCvv: '',
    
    // Para transferencia
    transferBank: '',
    transferAccount: ''
  };
  
  processing = false;
  termsAccepted = false;

  constructor(
    private cartService: CartService,
    private notificationService: NotificationService,
    private orderService: OrderService,
    private authService: EcommerceAuthService,
    private router: Router
  ) {}

  ngOnInit() {
    this.cartService.cart$.subscribe(items => {
      this.cartItems = items;
      
      // Si el carrito está vacío, redirigir
      if (this.cartItems.length === 0) {
        this.notificationService.warning('Tu carrito está vacío');
        this.router.navigate(['/catalog']);
      }
    });

    // Pre-rellenar datos si el usuario está autenticado
    const customer = this.authService.getCurrentCustomer();
    if (customer) {
      this.customerData.fullName = customer.fullName;
      this.customerData.email = customer.email;
      this.customerData.phone = customer.phone || '';
      this.customerData.address = customer.address || '';
      this.customerData.city = customer.city || '';
      this.customerData.district = customer.district || '';
    }
  }

  getSubtotal(): number {
    return this.cartItems.reduce((total, item) => 
      total + (item.product.salePrice * item.quantity), 0
    );
  }

  getShipping(): number {
    return this.getSubtotal() >= 100 ? 0 : 10;
  }

  getTotal(): number {
    return this.getSubtotal() + this.getShipping();
  }

  formatPrice(price: number): string {
    return `S/ ${price.toFixed(2)}`;
  }

  selectPaymentMethod(method: 'yape' | 'card' | 'transfer') {
    this.paymentMethod = method;
  }

  isFormValid(): boolean {
    // Validar datos del cliente
    const customerValid = !!(
      this.customerData.fullName &&
      this.customerData.email &&
      this.customerData.phone &&
      this.customerData.address &&
      this.customerData.city &&
      this.customerData.district
    );

    if (!customerValid) return false;

    // Validar según método de pago
    if (this.paymentMethod === 'yape') {
      return !!this.paymentData.yapePhone && this.paymentData.yapePhone.length === 9;
    } else if (this.paymentMethod === 'card') {
      return !!(
        this.paymentData.cardNumber &&
        this.paymentData.cardName &&
        this.paymentData.cardExpiry &&
        this.paymentData.cardCvv
      );
    } else if (this.paymentMethod === 'transfer') {
      return !!(
        this.paymentData.transferBank &&
        this.paymentData.transferAccount
      );
    }

    return false;
  }

  processPayment() {
    if (!this.termsAccepted) {
      this.notificationService.warning('Debes aceptar los términos y condiciones');
      return;
    }

    if (!this.isFormValid()) {
      this.notificationService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    this.processing = true;

    // Preparar datos del pedido
    const orderData: CreateOrderData = {
      customerFullName: this.customerData.fullName,
      customerEmail: this.customerData.email,
      customerPhone: this.customerData.phone,
      customerAddress: this.customerData.address,
      customerCity: this.customerData.city,
      customerDistrict: this.customerData.district,
      customerReference: this.customerData.reference,
      paymentMethod: this.paymentMethod,
      invoiceType: 'Boleta',
      items: this.cartItems.map(item => ({
        productId: item.product.id,
        quantity: item.quantity,
        unitPrice: item.product.salePrice
      }))
    };

    // Enviar pedido al backend
    this.orderService.createOrder(orderData).subscribe({
      next: (order) => {
        this.processing = false;
        this.notificationService.success(
          `¡Pedido #${order.orderNumber} realizado con éxito! Recibirás un email de confirmación.`
        );
        
        // Limpiar carrito
        this.cartService.clearCart();
        
        // Redirigir según si está autenticado
        if (this.authService.isAuthenticated()) {
          this.router.navigate(['/account'], { queryParams: { tab: 'orders' } });
        } else {
          this.router.navigate(['/'], { queryParams: { order: 'success' } });
        }
      },
      error: (error) => {
        this.processing = false;
        this.notificationService.error(
          error.error?.message || 'Error al procesar el pedido. Por favor intenta nuevamente.'
        );
      }
    });
  }

  consultStock() {
    // Generar mensaje de WhatsApp para consulta de stock
    const message = this.generateStockConsultMessage();
    const phone = '51999999999'; // Cambiar por número real
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
