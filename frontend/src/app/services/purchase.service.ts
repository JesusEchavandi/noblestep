import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Purchase, CreatePurchase } from '../models/purchase.model';

@Injectable({
  providedIn: 'root'
})
export class PurchaseService {
  private http = inject(HttpClient);
  private apiUrl = 'http://localhost:5000/api/Purchases';

  getPurchases(): Observable<Purchase[]> {
    return this.http.get<Purchase[]>(this.apiUrl);
  }

  getPurchase(id: number): Observable<Purchase> {
    return this.http.get<Purchase>(`${this.apiUrl}/${id}`);
  }

  createPurchase(purchase: CreatePurchase): Observable<Purchase> {
    return this.http.post<Purchase>(this.apiUrl, purchase);
  }

  getPurchasesSummary(): Observable<{ totalPurchases: number; totalCount: number }> {
    return this.http.get<{ totalPurchases: number; totalCount: number }>(`${this.apiUrl}/Summary`);
  }

  getPurchasesByDate(startDate: string, endDate: string): Observable<{ purchases: Purchase[]; totalPurchases: number }> {
    return this.http.get<{ purchases: Purchase[]; totalPurchases: number }>(`${this.apiUrl}/ByDateRange?startDate=${startDate}&endDate=${endDate}`);
  }
}
