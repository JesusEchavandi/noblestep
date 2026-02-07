import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface OrderItem {
  productId: number;
  quantity: number;
  unitPrice: number;
}

export interface CreateOrderData {
  customerFullName: string;
  customerEmail: string;
  customerPhone: string;
  customerAddress: string;
  customerCity: string;
  customerDistrict: string;
  customerReference?: string;
  customerDocumentNumber?: string;
  paymentMethod: string;
  paymentDetails?: string;
  invoiceType: string;
  companyName?: string;
  companyRUC?: string;
  companyAddress?: string;
  items: OrderItem[];
}

export interface OrderDetail {
  id: number;
  productId: number;
  productName: string;
  productCode: string;
  productSize?: string;
  quantity: number;
  unitPrice: number;
  subtotal: number;
}

export interface Order {
  id: number;
  orderNumber: string;
  customerFullName: string;
  customerEmail: string;
  customerPhone: string;
  customerAddress: string;
  customerCity: string;
  customerDistrict: string;
  customerReference?: string;
  subtotal: number;
  shippingCost: number;
  total: number;
  paymentMethod: string;
  paymentStatus: string;
  orderStatus: string;
  invoiceType: string;
  companyName?: string;
  companyRUC?: string;
  orderDate: Date;
  deliveredDate?: Date;
  items: OrderDetail[];
}

@Injectable({
  providedIn: 'root'
})
export class OrderService {
  private apiUrl = 'http://localhost:5000/api/ecommerce/orders';

  constructor(private http: HttpClient) { }

  createOrder(orderData: CreateOrderData): Observable<Order> {
    return this.http.post<Order>(this.apiUrl, orderData);
  }

  getMyOrders(): Observable<Order[]> {
    return this.http.get<Order[]>(`${this.apiUrl}/my-orders`);
  }

  getOrder(id: number): Observable<Order> {
    return this.http.get<Order>(`${this.apiUrl}/${id}`);
  }
}
