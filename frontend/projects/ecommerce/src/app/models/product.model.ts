export interface Product {
  id: number;
  code: string;
  name: string;
  description: string;
  salePrice: number;
  stock: number;
  categoryId: number;
  categoryName: string;
  imageUrl?: string;
  createdAt?: string | Date;
}

export interface Category {
  id: number;
  name: string;
  description: string;
  productCount: number;
}

export interface CartItem {
  product: Product;
  quantity: number;
}
