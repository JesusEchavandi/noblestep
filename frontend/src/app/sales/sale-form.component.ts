import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { SaleService } from '../services/sale.service';
import { CustomerService } from '../services/customer.service';
import { ProductService } from '../services/product.service';
import { CreateSale, CreateSaleDetail } from '../models/sale.model';
import { Customer } from '../models/customer.model';
import { Product } from '../models/product.model';

@Component({
  selector: 'app-sale-form',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="container-fluid">
      <div class="row justify-content-center">
        <div class="col-md-10">
          <div class="card">
            <div class="card-header">
              <h4 class="mb-0">Nueva Venta</h4>
            </div>
            <div class="card-body">
              <form (ngSubmit)="onSubmit()" #saleForm="ngForm">
                <div class="row mb-4">
                  <div class="col-md-6">
                    <label for="customerId" class="form-label">Cliente *</label>
                    <select
                      class="form-select"
                      id="customerId"
                      name="customerId"
                      [(ngModel)]="sale.customerId"
                      required
                    >
                      <option [ngValue]="0" disabled>Seleccione un cliente</option>
                      <option *ngFor="let customer of customers" [ngValue]="customer.id">
                        {{ customer.fullName }} - {{ customer.documentNumber }}
                      </option>
                    </select>
                  </div>
                </div>

                <h5 class="mb-3">Artículos de Venta</h5>

                <div *ngFor="let item of saleItems; let i = index" class="card mb-3">
                  <div class="card-body">
                    <div class="row align-items-end">
                      <div class="col-md-5">
                        <label class="form-label">Producto *</label>
                        <select
                          class="form-select"
                          [(ngModel)]="item.productId"
                          [name]="'product_' + i"
                          (change)="onProductChange(i)"
                          required
                        >
                          <option [ngValue]="0" disabled>Seleccione un producto</option>
                          <option *ngFor="let product of products" [ngValue]="product.id">
                            {{ product.name }} - {{ product.brand }} ({{ product.size }})
                            - Stock: {{ product.stock }}
                          </option>
                        </select>
                      </div>

                      <div class="col-md-2">
                        <label class="form-label">Cantidad *</label>
                        <input
                          type="number"
                          class="form-control"
                          [(ngModel)]="item.quantity"
                          [name]="'quantity_' + i"
                          (change)="calculateTotal()"
                          min="1"
                          required
                        />
                      </div>

                      <div class="col-md-2">
                        <label class="form-label">Precio Unitario</label>
                        <input
                          type="text"
                          class="form-control"
                          [value]="item.unitPrice | currency"
                          readonly
                        />
                      </div>

                      <div class="col-md-2">
                        <label class="form-label">Subtotal</label>
                        <input
                          type="text"
                          class="form-control"
                          [value]="item.subtotal | currency"
                          readonly
                        />
                      </div>

                      <div class="col-md-1">
                        <button
                          type="button"
                          class="btn btn-danger btn-sm"
                          (click)="removeItem(i)"
                          [disabled]="saleItems.length === 1"
                        >
                          Quitar
                        </button>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="mb-4">
                  <button type="button" class="btn btn-outline-primary" (click)="addItem()">
                    + Agregar Artículo
                  </button>
                </div>

                <!-- Payment Method Selection -->
                <div class="mb-4">
                  <h5 class="mb-3">💳 Método de Pago</h5>
                  <div class="row g-3">
                    <!-- Efectivo -->
                    <div class="col-md-3">
                      <div 
                        class="payment-method-card" 
                        [class.active]="selectedPaymentMethod === 'Efectivo'"
                        (click)="selectPaymentMethod('Efectivo')"
                      >
                        <i class="bi bi-cash-coin payment-icon"></i>
                        <div class="payment-name">Efectivo</div>
                        <i *ngIf="selectedPaymentMethod === 'Efectivo'" class="bi bi-check-circle-fill check-icon"></i>
                      </div>
                    </div>
                    
                    <!-- Tarjeta -->
                    <div class="col-md-3">
                      <div 
                        class="payment-method-card" 
                        [class.active]="selectedPaymentMethod === 'Tarjeta'"
                        [class.confirmed]="selectedPaymentMethod === 'Tarjeta' && paymentConfirmed"
                        (click)="selectPaymentMethod('Tarjeta')"
                      >
                        <i class="bi bi-credit-card payment-icon"></i>
                        <div class="payment-name">Tarjeta</div>
                        <i *ngIf="selectedPaymentMethod === 'Tarjeta' && paymentConfirmed" class="bi bi-check-circle-fill check-icon"></i>
                      </div>
                    </div>
                    
                    <!-- Yape -->
                    <div class="col-md-3">
                      <div 
                        class="payment-method-card" 
                        [class.active]="selectedPaymentMethod === 'Yape'"
                        [class.confirmed]="selectedPaymentMethod === 'Yape' && paymentConfirmed"
                        (click)="selectPaymentMethod('Yape')"
                      >
                        <i class="bi bi-phone payment-icon"></i>
                        <div class="payment-name">Yape</div>
                        <i *ngIf="selectedPaymentMethod === 'Yape' && paymentConfirmed" class="bi bi-check-circle-fill check-icon"></i>
                      </div>
                    </div>
                    
                    <!-- Transferencia -->
                    <div class="col-md-3">
                      <div 
                        class="payment-method-card" 
                        [class.active]="selectedPaymentMethod === 'Transferencia'"
                        [class.confirmed]="selectedPaymentMethod === 'Transferencia' && paymentConfirmed"
                        (click)="selectPaymentMethod('Transferencia')"
                      >
                        <i class="bi bi-bank payment-icon"></i>
                        <div class="payment-name">Transferencia</div>
                        <i *ngIf="selectedPaymentMethod === 'Transferencia' && paymentConfirmed" class="bi bi-check-circle-fill check-icon"></i>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="row mb-4">
                  <div class="col-md-12 text-end">
                    <h4>Total: {{ totalAmount | currency }}</h4>
                  </div>
                </div>

                <div *ngIf="errorMessage" class="alert alert-danger" role="alert">
                  {{ errorMessage }}
                </div>

                <div class="d-flex justify-content-end gap-2">
                  <button type="button" class="btn btn-secondary" (click)="cancel()">
                    Cancelar
                  </button>
                  <button
                    type="submit"
                    class="btn btn-primary"
                    [disabled]="!saleForm.form.valid || saving || !isValid()"
                  >
                    <span *ngIf="saving" class="spinner-border spinner-border-sm me-2"></span>
                    {{ saving ? 'Procesando...' : 'Completar Venta' }}
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Yape -->
    <div class="modal fade" [class.show]="showYapeModal" [style.display]="showYapeModal ? 'block' : 'none'" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header" style="background: var(--color-dark); color: white;">
            <h5 class="modal-title">
              <i class="bi bi-phone me-2"></i>Pago con Yape
            </h5>
            <button type="button" class="btn-close btn-close-white" (click)="closePaymentModal()"></button>
          </div>
          <div class="modal-body text-center p-4">
            <div class="yape-qr-container mb-4">
              <div class="qr-placeholder">
                <i class="bi bi-qr-code" style="font-size: 8rem; color: var(--color-dark);"></i>
              </div>
              <p class="mt-3 text-muted">Escanea el código QR con tu app Yape</p>
            </div>
            
            <div class="alert" style="background: var(--color-warning-bg); border-color: var(--color-warning-border);">
              <strong>Monto a pagar:</strong>
              <div style="font-size: 2rem; color: var(--color-primary); font-weight: bold;">
                {{ totalAmount | currency }}
              </div>
            </div>
            
            <p class="text-muted small mb-4">
              Después de realizar el pago, presiona el botón para confirmar
            </p>
            
            <button 
              class="btn btn-lg w-100" 
              [class.btn-primary]="!processingPayment"
              [class.btn-secondary]="processingPayment"
              (click)="confirmYapePayment()" 
              [disabled]="processingPayment"
            >
              <span *ngIf="processingPayment" class="spinner-border spinner-border-sm me-2"></span>
              {{ processingPayment ? 'Confirmando...' : 'Confirmar Pago Realizado' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Tarjeta -->
    <div class="modal fade" [class.show]="showCardModal" [style.display]="showCardModal ? 'block' : 'none'" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header" style="background: var(--color-dark); color: white;">
            <h5 class="modal-title">
              <i class="bi bi-credit-card me-2"></i>Pago con Tarjeta
            </h5>
            <button type="button" class="btn-close btn-close-white" (click)="closePaymentModal()"></button>
          </div>
          <div class="modal-body p-4">
            <div class="alert" style="background: var(--color-warning-bg); border-color: var(--color-warning-border);">
              <strong>Monto a pagar:</strong>
              <span style="font-size: 1.5rem; color: var(--color-primary); font-weight: bold; margin-left: 1rem;">
                {{ totalAmount | currency }}
              </span>
            </div>

            <div class="mb-3">
              <label class="form-label">Número de Tarjeta *</label>
              <input 
                type="text" 
                class="form-control" 
                [(ngModel)]="cardData.cardNumber"
                placeholder="1234 5678 9012 3456"
                maxlength="19"
              />
            </div>
            
            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label">Fecha de Expiración *</label>
                <input 
                  type="text" 
                  class="form-control" 
                  [(ngModel)]="cardData.expiryDate"
                  placeholder="MM/AA"
                  maxlength="5"
                />
              </div>
              <div class="col-md-6 mb-3">
                <label class="form-label">CVV *</label>
                <input 
                  type="text" 
                  class="form-control" 
                  [(ngModel)]="cardData.cvv"
                  placeholder="123"
                  maxlength="3"
                />
              </div>
            </div>
            
            <div class="mb-4">
              <label class="form-label">Nombre del Titular *</label>
              <input 
                type="text" 
                class="form-control" 
                [(ngModel)]="cardData.cardholderName"
                placeholder="Nombre como aparece en la tarjeta"
              />
            </div>
            
            <button 
              class="btn btn-lg btn-primary w-100" 
              (click)="processCardPayment()" 
              [disabled]="processingPayment"
            >
              <span *ngIf="processingPayment" class="spinner-border spinner-border-sm me-2"></span>
              <i *ngIf="!processingPayment" class="bi bi-lock-fill me-2"></i>
              {{ processingPayment ? 'Procesando pago...' : 'Pagar ' + (totalAmount | currency) }}
            </button>
            
            <p class="text-muted text-center small mt-3 mb-0">
              <i class="bi bi-shield-check me-1"></i>Pago seguro y encriptado
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Transferencia -->
    <div class="modal fade" [class.show]="showTransferModal" [style.display]="showTransferModal ? 'block' : 'none'" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header" style="background: var(--color-dark); color: white;">
            <h5 class="modal-title">
              <i class="bi bi-bank me-2"></i>Transferencia Bancaria
            </h5>
            <button type="button" class="btn-close btn-close-white" (click)="closePaymentModal()"></button>
          </div>
          <div class="modal-body p-4">
            <div class="alert" style="background: var(--color-warning-bg); border-color: var(--color-warning-border);">
              <strong>Monto a pagar:</strong>
              <span style="font-size: 1.5rem; color: var(--color-primary); font-weight: bold; margin-left: 1rem;">
                {{ totalAmount | currency }}
              </span>
            </div>
            
            <div class="card mb-3" style="background: var(--color-gray-50);">
              <div class="card-body">
                <h6 class="mb-3"><i class="bi bi-building me-2"></i>Datos Bancarios</h6>
                <div class="row g-2">
                  <div class="col-5"><strong>Banco:</strong></div>
                  <div class="col-7">BCP</div>
                  
                  <div class="col-5"><strong>Cuenta:</strong></div>
                  <div class="col-7">191-12345678-0-90</div>
                  
                  <div class="col-5"><strong>CCI:</strong></div>
                  <div class="col-7">00219100123456780090</div>
                  
                  <div class="col-5"><strong>Titular:</strong></div>
                  <div class="col-7">NobleStep SAC</div>
                </div>
              </div>
            </div>
            
            <div class="mb-4">
              <label class="form-label">Número de Operación *</label>
              <input 
                type="text" 
                class="form-control" 
                [(ngModel)]="operationNumber"
                placeholder="Ingrese el número de operación"
              />
              <small class="text-muted">Ingrese el código que aparece en su constancia de pago</small>
            </div>
            
            <button 
              class="btn btn-lg btn-primary w-100" 
              (click)="confirmTransferPayment()" 
              [disabled]="processingPayment"
            >
              <span *ngIf="processingPayment" class="spinner-border spinner-border-sm me-2"></span>
              {{ processingPayment ? 'Confirmando...' : 'Confirmar Transferencia' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Backdrop -->
    <div class="modal-backdrop fade" [class.show]="showYapeModal || showCardModal || showTransferModal" 
         *ngIf="showYapeModal || showCardModal || showTransferModal"></div>
  `,
  styles: [`
    /* Payment Method Cards */
    .payment-method-card {
      border: 2px solid var(--color-gray-200);
      border-radius: var(--radius-lg);
      padding: 1.5rem 1rem;
      text-align: center;
      cursor: pointer;
      transition: all var(--transition-base);
      background: white;
      position: relative;
      min-height: 140px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }

    .payment-method-card:hover {
      transform: translateY(-4px);
      box-shadow: var(--shadow-md);
      border-color: var(--color-primary);
    }

    .payment-method-card.active {
      border-color: var(--color-primary);
      background: linear-gradient(135deg, rgba(232, 74, 95, 0.05), rgba(255, 132, 124, 0.05));
      box-shadow: var(--shadow-md);
    }

    .payment-method-card.confirmed {
      border-color: var(--color-success);
      background: linear-gradient(135deg, rgba(153, 184, 152, 0.05), rgba(153, 184, 152, 0.1));
    }

    .payment-icon {
      font-size: 3rem;
      color: var(--color-dark);
      margin-bottom: 0.5rem;
      transition: all var(--transition-base);
    }

    .payment-method-card.active .payment-icon {
      color: var(--color-primary);
      transform: scale(1.1);
    }

    .payment-method-card.confirmed .payment-icon {
      color: var(--color-success);
    }

    .payment-name {
      font-weight: var(--font-weight-semibold);
      color: var(--color-dark);
      font-size: var(--font-size-base);
    }

    .check-icon {
      position: absolute;
      top: 0.5rem;
      right: 0.5rem;
      font-size: 1.5rem;
      color: var(--color-success);
      animation: checkPop 0.3s ease;
    }

    @keyframes checkPop {
      0% { transform: scale(0); }
      50% { transform: scale(1.2); }
      100% { transform: scale(1); }
    }

    /* Modal Styles */
    .modal {
      background: rgba(42, 54, 59, 0.7);
    }

    .modal.show {
      display: block !important;
    }

    .modal-backdrop.show {
      opacity: 0.5;
    }

    .modal-content {
      border: none;
      border-radius: var(--radius-xl);
      box-shadow: var(--shadow-xl);
    }

    .modal-header {
      border-bottom: 1px solid var(--color-gray-100);
      padding: 1.5rem;
    }

    .modal-body {
      max-height: 70vh;
      overflow-y: auto;
    }

    /* Yape QR */
    .yape-qr-container {
      padding: 2rem;
    }

    .qr-placeholder {
      width: 250px;
      height: 250px;
      margin: 0 auto;
      background: linear-gradient(135deg, var(--color-gray-50), white);
      border: 3px dashed var(--color-gray-300);
      border-radius: var(--radius-lg);
      display: flex;
      align-items: center;
      justify-content: center;
      animation: qrPulse 2s ease-in-out infinite;
    }

    @keyframes qrPulse {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.02); }
    }

    /* Responsive */
    @media (max-width: 768px) {
      .payment-method-card {
        min-height: 120px;
        padding: 1rem 0.5rem;
      }

      .payment-icon {
        font-size: 2.5rem;
      }

      .payment-name {
        font-size: var(--font-size-sm);
      }
    }
  `]
})
export class SaleFormComponent implements OnInit {
  private saleService = inject(SaleService);
  private customerService = inject(CustomerService);
  private productService = inject(ProductService);
  private router = inject(Router);

  sale: CreateSale = {
    customerId: 0,
    paymentMethod: 'Efectivo',
    details: []
  };

  saleItems: any[] = [{
    productId: 0,
    quantity: 1,
    unitPrice: 0,
    subtotal: 0
  }];

  customers: Customer[] = [];
  products: Product[] = [];
  totalAmount = 0;
  errorMessage = '';
  saving = false;

  // Payment method variables
  selectedPaymentMethod = 'Efectivo';
  showYapeModal = false;
  showCardModal = false;
  showTransferModal = false;
  
  // Card payment data
  cardData = {
    cardNumber: '',
    expiryDate: '',
    cvv: '',
    cardholderName: ''
  };
  
  // Yape/Transfer confirmation
  paymentConfirmed = false;
  processingPayment = false;
  operationNumber = '';

  ngOnInit(): void {
    this.loadCustomers();
    this.loadProducts();
  }

  loadCustomers(): void {
    this.customerService.getCustomers().subscribe({
      next: (data) => {
        this.customers = data;
      },
      error: (error) => console.error('Error loading customers:', error)
    });
  }

  loadProducts(): void {
    this.productService.getProducts().subscribe({
      next: (data) => {
        this.products = data.filter(p => p.stock > 0);
      },
      error: (error) => console.error('Error loading products:', error)
    });
  }

  onProductChange(index: number): void {
    const item = this.saleItems[index];
    const product = this.products.find(p => p.id === item.productId);
    
    if (product) {
      item.unitPrice = product.price;
      item.subtotal = item.quantity * item.unitPrice;
      this.calculateTotal();
    }
  }

  calculateTotal(): void {
    this.totalAmount = this.saleItems.reduce((sum, item) => {
      return sum + (item.quantity * item.unitPrice);
    }, 0);

    this.saleItems.forEach(item => {
      item.subtotal = item.quantity * item.unitPrice;
    });
  }

  addItem(): void {
    this.saleItems.push({
      productId: 0,
      quantity: 1,
      unitPrice: 0,
      subtotal: 0
    });
  }

  removeItem(index: number): void {
    this.saleItems.splice(index, 1);
    this.calculateTotal();
  }

  isValid(): boolean {
    return this.sale.customerId > 0 && 
           this.saleItems.length > 0 && 
           this.saleItems.every(item => item.productId > 0 && item.quantity > 0);
  }

  // Payment method selection
  selectPaymentMethod(method: string): void {
    this.selectedPaymentMethod = method;
    this.sale.paymentMethod = method;
    this.paymentConfirmed = false;
    
    if (method === 'Yape') {
      this.showYapeModal = true;
    } else if (method === 'Tarjeta') {
      this.showCardModal = true;
    } else if (method === 'Transferencia') {
      this.showTransferModal = true;
    }
  }

  // Yape payment confirmation
  confirmYapePayment(): void {
    this.processingPayment = true;
    
    setTimeout(() => {
      const transactionId = `YAPE-${Date.now()}`;
      this.sale.transactionId = transactionId;
      this.paymentConfirmed = true;
      this.processingPayment = false;
      this.showYapeModal = false;
      
      alert('✅ Pago Yape confirmado exitosamente');
    }, 1500);
  }

  // Card payment processing
  processCardPayment(): void {
    if (!this.cardData.cardNumber || !this.cardData.expiryDate || 
        !this.cardData.cvv || !this.cardData.cardholderName) {
      alert('Por favor complete todos los campos de la tarjeta');
      return;
    }
    
    this.processingPayment = true;
    
    // Simulate payment processing
    setTimeout(() => {
      const transactionId = `TRX-CARD-${Date.now()}`;
      this.sale.transactionId = transactionId;
      this.paymentConfirmed = true;
      this.processingPayment = false;
      this.showCardModal = false;
      
      alert('✅ Pago con tarjeta procesado exitosamente');
      
      // Clear card data
      this.cardData = {
        cardNumber: '',
        expiryDate: '',
        cvv: '',
        cardholderName: ''
      };
    }, 2000);
  }

  // Transfer payment confirmation
  confirmTransferPayment(): void {
    if (!this.operationNumber) {
      alert('Por favor ingrese el número de operación');
      return;
    }
    
    this.processingPayment = true;
    
    setTimeout(() => {
      const transactionId = `TRANS-${this.operationNumber}-${Date.now()}`;
      this.sale.transactionId = transactionId;
      this.paymentConfirmed = true;
      this.processingPayment = false;
      this.showTransferModal = false;
      
      alert('✅ Transferencia confirmada exitosamente');
      this.operationNumber = '';
    }, 1500);
  }

  // Close modals
  closePaymentModal(): void {
    this.showYapeModal = false;
    this.showCardModal = false;
    this.showTransferModal = false;
    this.processingPayment = false;
  }

  onSubmit(): void {
    // Validate payment for digital methods
    if ((this.selectedPaymentMethod === 'Yape' || 
         this.selectedPaymentMethod === 'Tarjeta' || 
         this.selectedPaymentMethod === 'Transferencia') && 
        !this.paymentConfirmed) {
      alert('Por favor complete el proceso de pago antes de continuar');
      return;
    }

    this.errorMessage = '';
    this.saving = true;

    this.sale.details = this.saleItems.map(item => ({
      productId: item.productId,
      quantity: item.quantity
    }));

    this.saleService.createSale(this.sale).subscribe({
      next: () => {
        this.router.navigate(['/sales']);
      },
      error: (error) => {
        this.errorMessage = error.error?.message || 'Error al crear la venta. Por favor intente nuevamente.';
        this.saving = false;
      }
    });
  }

  cancel(): void {
    this.router.navigate(['/sales']);
  }
}
