import { HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { EcommerceAuthService } from '../services/ecommerce-auth.service';

export const ecommerceAuthInterceptor: HttpInterceptorFn = (req, next) => {
  const authService = inject(EcommerceAuthService);
  const token = authService.getToken();

  // Solo agregar el token si es una petición a nuestra API de e-commerce
  if (token && req.url.includes('/api/ecommerce/')) {
    req = req.clone({
      setHeaders: {
        Authorization: `Bearer ${token}`
      }
    });
  }

  return next(req);
};
