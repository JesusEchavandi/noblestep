import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ProductService } from '../services/product.service';
import { AuthService } from '../services/auth.service';
import { Product } from '../models/product.model';

@Component({
  selector: 'app-product-list',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="container-fluid">
      <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Productos</h2>
        <a *ngIf="isAdmin" routerLink="/products/new" class="btn btn-primary">
          Agregar Nuevo Producto
        </a>
      </div>

      <div class="card">
        <div class="card-body">
          <div *ngIf="loading" class="spinner-container">
            <div class="spinner-border text-primary" role="status">
              <span class="visually-hidden">Cargando...</span>
            </div>
          </div>

          <div *ngIf="!loading && products.length === 0" class="text-center py-5 text-muted">
            <h5>No se encontraron productos</h5>
            <p>Comience agregando su primer producto</p>
          </div>

          <div *ngIf="!loading && products.length > 0" class="table-responsive">
            <table class="table table-hover">
              <thead>
                <tr>
                  <th>Nombre</th>
                  <th>Marca</th>
                  <th>Categoría</th>
                  <th>Talla</th>
                  <th class="text-end">Precio</th>
                  <th class="text-end">Stock</th>
                  <th>Estado</th>
                  <th *ngIf="isAdmin" class="text-end">Acciones</th>
                </tr>
              </thead>
              <tbody>
                <tr *ngFor="let product of products">
                  <td>{{ product.name }}</td>
                  <td>{{ product.brand }}</td>
                  <td>{{ product.categoryName }}</td>
                  <td>{{ product.size }}</td>
                  <td class="text-end">{{ product.price | currency }}</td>
                  <td class="text-end">
                    <span [class.text-danger]="product.stock < 10">
                      {{ product.stock }}
                    </span>
                  </td>
                  <td>
                    <span class="badge" [class.bg-success]="product.isActive" [class.bg-secondary]="!product.isActive">
                      {{ product.isActive ? 'Activo' : 'Inactivo' }}
                    </span>
                  </td>
                  <td *ngIf="isAdmin" class="text-end">
                    <a [routerLink]="['/products/edit', product.id]" class="btn btn-sm btn-outline-primary me-2">
                      Editar
                    </a>
                    <button (click)="deleteProduct(product.id)" class="btn btn-sm btn-outline-danger">
                      Eliminar
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  `
})
export class ProductListComponent implements OnInit {
  private productService = inject(ProductService);
  private authService = inject(AuthService);

  products: Product[] = [];
  loading = true;
  isAdmin = this.authService.hasRole('Administrator');

  ngOnInit(): void {
    this.loadProducts();
  }

  loadProducts(): void {
    this.loading = true;
    this.productService.getProducts().subscribe({
      next: (data) => {
        this.products = data;
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading products:', error);
        this.loading = false;
      }
    });
  }

  deleteProduct(id: number): void {
    if (confirm('¿Está seguro que desea eliminar este producto?')) {
      this.productService.deleteProduct(id).subscribe({
        next: () => {
          this.loadProducts();
        },
        error: (error) => console.error('Error al eliminar producto:', error)
      });
    }
  }
}
