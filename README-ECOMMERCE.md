# 🛍️ NobleStep E-commerce

E-commerce moderno desarrollado con Angular 18 que consume la misma base de datos del sistema de gestión NobleStep.

## 🎨 Características

### ✅ Implementadas
- 🏠 **Página de Inicio** con productos destacados
- 📦 **Catálogo Completo** con filtros avanzados:
  - Búsqueda por nombre/marca
  - Filtro por categoría
  - Filtro por rango de precio
  - Indicador de stock
- 🔍 **Detalle de Producto** con información completa
- 🛒 **Carrito de Compras** persistente (localStorage)
- 📧 **Formulario de Contacto**
- 📱 **Diseño 100% Responsive**
- 🎨 **Interfaz moderna y atractiva**

### 🎯 Páginas Disponibles
1. **Home** (`/`) - Página principal con productos destacados
2. **Catálogo** (`/catalog`) - Todos los productos con filtros
3. **Detalle** (`/product/:id`) - Información detallada del producto
4. **Carrito** (`/cart`) - Gestión de productos seleccionados
5. **Contacto** (`/contact`) - Formulario de consultas

## 🚀 Inicio Rápido

### Opción 1: Script Automático (Recomendado)
```powershell
.\INICIAR-ECOMMERCE.ps1
```

### Opción 2: Manual

#### 1. Iniciar Backend
```bash
cd backend
dotnet run
```

#### 2. Iniciar E-commerce
```bash
cd frontend
npm install  # Solo la primera vez
npm run start -- --project ecommerce --port 4201 --open
```

## 🌐 URLs de Acceso

- **E-commerce:** http://localhost:4201
- **Backend API:** http://localhost:5000
- **Swagger Docs:** http://localhost:5000/swagger

## 📁 Estructura del Proyecto

```
frontend/projects/ecommerce/
├── src/
│   ├── app/
│   │   ├── components/          # Componentes reutilizables
│   │   │   ├── navbar/          # Barra de navegación
│   │   │   └── footer/          # Pie de página
│   │   ├── pages/               # Páginas principales
│   │   │   ├── home/            # Página de inicio
│   │   │   ├── catalog/         # Catálogo con filtros
│   │   │   ├── product-detail/  # Detalle de producto
│   │   │   ├── cart/            # Carrito de compras
│   │   │   └── contact/         # Formulario contacto
│   │   ├── services/            # Servicios
│   │   │   ├── shop.service.ts  # Consumo API
│   │   │   └── cart.service.ts  # Gestión carrito
│   │   └── models/              # Interfaces TypeScript
│   └── styles.css               # Estilos globales
```

## 🔌 API Endpoints Utilizados

El e-commerce consume los siguientes endpoints del backend:

- `GET /api/shop/products` - Listar productos con filtros
- `GET /api/shop/products/{id}` - Detalle de producto
- `GET /api/shop/products/featured` - Productos destacados
- `GET /api/shop/categories` - Listar categorías
- `POST /api/shop/contact` - Enviar consulta

## 💾 Base de Datos

El e-commerce utiliza la **misma base de datos** que el sistema de gestión:
- Base de datos: `noblestepdb`
- Tablas principales: `products`, `categories`
- Los productos se sincronizan automáticamente

## 🎨 Diseño

### Paleta de Colores
- **Primary:** Gradiente morado (#667eea → #764ba2)
- **Success:** Verde (#27ae60)
- **Background:** Gris claro (#f8f9fa)
- **Text:** Azul oscuro (#2c3e50)

### Características de Diseño
- ✅ Cards con sombras y hover effects
- ✅ Gradientes modernos
- ✅ Iconos emoji para mejor UX
- ✅ Animaciones suaves
- ✅ Diseño mobile-first

## 🛠️ Tecnologías

- **Framework:** Angular 18 (Standalone Components)
- **Backend:** ASP.NET Core 8.0
- **Base de Datos:** MySQL 8.0
- **HTTP Client:** Angular HttpClient
- **Routing:** Angular Router
- **Forms:** Angular Forms (Template-driven)
- **State Management:** RxJS BehaviorSubject
- **Storage:** LocalStorage (para carrito)

## 📱 Responsive Design

El e-commerce es completamente responsive y se adapta a:
- 📱 Móviles (< 768px)
- 💻 Tablets (768px - 1024px)
- 🖥️ Desktop (> 1024px)

## ⚙️ Configuración

### Cambiar Puerto del E-commerce
Editar `angular.json`:
```json
"serve": {
  "options": {
    "port": 4201  // Cambiar aquí
  }
}
```

### Cambiar URL del Backend
Editar `frontend/projects/ecommerce/src/app/services/shop.service.ts`:
```typescript
private apiUrl = 'http://localhost:5000/api/shop';  // Cambiar aquí
```

## 🔒 Seguridad

- ✅ Validación de formularios
- ✅ Sanitización de datos
- ✅ Manejo de errores HTTP
- ✅ Protección contra inyección

## 🚧 Funcionalidades Futuras

- [ ] Integración con pasarela de pagos
- [ ] Sistema de autenticación de clientes
- [ ] Historial de pedidos
- [ ] Wishlist/favoritos
- [ ] Valoraciones y reseñas
- [ ] Comparador de productos
- [ ] Notificaciones por email
- [ ] Panel de cliente
- [ ] Búsqueda avanzada con autocompletado
- [ ] Filtros adicionales (marca, talla, color)

## 📞 Soporte

Para consultas sobre el e-commerce, contacta a través de:
- Email: info@noblestep.com
- Teléfono: +51 999 999 999

## 📄 Licencia

© 2026 NobleStep. Todos los derechos reservados.

---

**Desarrollado con ❤️ usando Angular y ASP.NET Core**
