import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ProductShop, CategoryShop, ContactForm } from '../models/shop.models';

@Injectable({
  providedIn: 'root'
})
export class ShopService {
  private readonly API_URL = 'http://localhost:5000/api/shop';

  constructor(private http: HttpClient) { }

  // Obtener productos con filtros opcionales
  getProducts(filters?: {
    categoryId?: number;
    search?: string;
    minPrice?: number;
    maxPrice?: number;
    inStock?: boolean;
  }): Observable<ProductShop[]> {
    let params = new HttpParams();
    
    if (filters) {
      if (filters.categoryId) params = params.set('categoryId', filters.categoryId.toString());
      if (filters.search) params = params.set('search', filters.search);
      if (filters.minPrice) params = params.set('minPrice', filters.minPrice.toString());
      if (filters.maxPrice) params = params.set('maxPrice', filters.maxPrice.toString());
      if (filters.inStock !== undefined) params = params.set('inStock', filters.inStock.toString());
    }

    return this.http.get<ProductShop[]>(`${this.API_URL}/products`, { params });
  }

  // Obtener detalle de un producto
  getProduct(id: number): Observable<ProductShop> {
    return this.http.get<ProductShop>(`${this.API_URL}/products/${id}`);
  }

  // Obtener productos destacados
  getFeaturedProducts(limit: number = 8): Observable<ProductShop[]> {
    return this.http.get<ProductShop[]>(`${this.API_URL}/products/featured?limit=${limit}`);
  }

  // Obtener categorías
  getCategories(): Observable<CategoryShop[]> {
    return this.http.get<CategoryShop[]>(`${this.API_URL}/categories`);
  }

  // Enviar consulta de contacto
  submitContact(contact: ContactForm): Observable<any> {
    return this.http.post(`${this.API_URL}/contact`, contact);
  }
}
