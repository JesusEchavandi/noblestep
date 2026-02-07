import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { ProductService } from '../services/product.service';
import { CategoryService } from '../services/category.service';
import { CreateProduct, UpdateProduct, Product } from '../models/product.model';
import { Category } from '../models/category.model';

@Component({
  selector: 'app-product-form',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="container-fluid">
      <div class="row justify-content-center">
        <div class="col-md-8">
          <div class="card">
            <div class="card-header">
              <h4 class="mb-0">{{ isEditMode ? 'Editar Producto' : 'Agregar Nuevo Producto' }}</h4>
            </div>
            <div class="card-body">
              <form (ngSubmit)="onSubmit()" #productForm="ngForm">
                <div class="row">
                  <div class="col-md-6 mb-3">
                    <label for="name" class="form-label">Nombre del Producto *</label>
                    <input
                      type="text"
                      class="form-control"
                      id="name"
                      name="name"
                      [(ngModel)]="product.name"
                      required
                    />
                  </div>

                  <div class="col-md-6 mb-3">
                    <label for="brand" class="form-label">Marca *</label>
                    <input
                      type="text"
                      class="form-control"
                      id="brand"
                      name="brand"
                      [(ngModel)]="product.brand"
                      required
                    />
                  </div>
                </div>

                <div class="row">
                  <div class="col-md-6 mb-3">
                    <label for="categoryId" class="form-label">Categoría *</label>
                    <select
                      class="form-select"
                      id="categoryId"
                      name="categoryId"
                      [(ngModel)]="product.categoryId"
                      required
                    >
                      <option [ngValue]="0" disabled>Seleccione una categoría</option>
                      <option *ngFor="let category of categories" [ngValue]="category.id">
                        {{ category.name }}
                      </option>
                    </select>
                  </div>

                  <div class="col-md-6 mb-3">
                    <label for="size" class="form-label">Talla *</label>
                    <input
                      type="text"
                      class="form-control"
                      id="size"
                      name="size"
                      [(ngModel)]="product.size"
                      required
                      placeholder="ej., 8, 9, 10"
                    />
                  </div>
                </div>

                <div class="row">
                  <div class="col-md-6 mb-3">
                    <label for="price" class="form-label">Precio *</label>
                    <input
                      type="number"
                      class="form-control"
                      id="price"
                      name="price"
                      [(ngModel)]="product.price"
                      required
                      min="0"
                      step="0.01"
                    />
                  </div>

                  <div class="col-md-6 mb-3">
                    <label for="stock" class="form-label">Stock *</label>
                    <input
                      type="number"
                      class="form-control"
                      id="stock"
                      name="stock"
                      [(ngModel)]="product.stock"
                      required
                      min="0"
                    />
                  </div>
                </div>

                <div class="mb-3" *ngIf="isEditMode">
                  <div class="form-check">
                    <input
                      class="form-check-input"
                      type="checkbox"
                      id="isActive"
                      name="isActive"
                      [(ngModel)]="product.isActive"
                    />
                    <label class="form-check-label" for="isActive">
                      Activo
                    </label>
                  </div>
                </div>

                <div class="d-flex justify-content-end gap-2">
                  <button type="button" class="btn btn-secondary" (click)="cancel()">
                    Cancelar
                  </button>
                  <button
                    type="submit"
                    class="btn btn-primary"
                    [disabled]="!productForm.form.valid || saving"
                  >
                    <span *ngIf="saving" class="spinner-border spinner-border-sm me-2"></span>
                    {{ saving ? 'Guardando...' : 'Guardar Producto' }}
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  `
})
export class ProductFormComponent implements OnInit {
  private productService = inject(ProductService);
  private categoryService = inject(CategoryService);
  private router = inject(Router);
  private route = inject(ActivatedRoute);

  product: any = {
    name: '',
    brand: '',
    categoryId: 0,
    size: '',
    price: 0,
    stock: 0,
    isActive: true
  };

  categories: Category[] = [];
  isEditMode = false;
  productId: number = 0;
  saving = false;

  ngOnInit(): void {
    this.loadCategories();
    
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEditMode = true;
      this.productId = +id;
      this.loadProduct(this.productId);
    }
  }

  loadCategories(): void {
    this.categoryService.getCategories().subscribe({
      next: (data) => {
        this.categories = data;
      },
      error: (error) => console.error('Error loading categories:', error)
    });
  }

  loadProduct(id: number): void {
    this.productService.getProduct(id).subscribe({
      next: (data) => {
        this.product = data;
      },
      error: (error) => console.error('Error loading product:', error)
    });
  }

  onSubmit(): void {
    this.saving = true;

    if (this.isEditMode) {
      this.productService.updateProduct(this.productId, this.product as UpdateProduct).subscribe({
        next: () => {
          this.router.navigate(['/products']);
        },
        error: (error) => {
          console.error('Error updating product:', error);
          this.saving = false;
        }
      });
    } else {
      this.productService.createProduct(this.product as CreateProduct).subscribe({
        next: () => {
          this.router.navigate(['/products']);
        },
        error: (error) => {
          console.error('Error creating product:', error);
          this.saving = false;
        }
      });
    }
  }

  cancel(): void {
    this.router.navigate(['/products']);
  }
}
