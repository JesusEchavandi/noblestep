export interface Product {
  id: number;
  name: string;
  brand: string;
  categoryId: number;
  categoryName: string;
  size: string;
  price: number;
  stock: number;
  isActive: boolean;
}

export interface CreateProduct {
  name: string;
  brand: string;
  categoryId: number;
  size: string;
  price: number;
  stock: number;
}

export interface UpdateProduct extends CreateProduct {
  isActive: boolean;
}
