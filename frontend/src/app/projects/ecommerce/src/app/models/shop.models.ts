export interface ProductShop {
  id: number;
  code: string;
  name: string;
  description: string;
  salePrice: number;
  stock: number;
  categoryId: number;
  categoryName: string;
  imageUrl?: string;
}

export interface CategoryShop {
  id: number;
  name: string;
  description: string;
  productCount: number;
}

export interface ContactForm {
  name: string;
  email: string;
  phone: string;
  message: string;
}

export interface CartItem {
  product: ProductShop;
  quantity: number;
}
