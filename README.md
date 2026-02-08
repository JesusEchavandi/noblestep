# NobleStep - Sistema de Gestión de Calzado 👟

Sistema completo de gestión de ventas de calzado con panel administrativo y tienda e-commerce integrada.

## 📌 Descripción

NobleStep es una solución integral que combina:
- **Sistema Web Administrativo**: Panel completo para gestionar inventario, ventas, compras, clientes y proveedores
- **E-commerce**: Tienda online con autenticación, carrito de compras y procesamiento de pedidos
- **Base de Datos Unificada**: MySQL con datos de demostración incluidos

## 🚀 Características Principales

### 🖥️ Panel Administrativo
- ✅ **Dashboard** con estadísticas en tiempo real
- 📦 **Gestión de Productos** (CRUD completo con stock)
- 🏷️ **Categorías** de calzado
- 👥 **Clientes y Proveedores**
- 💰 **Registro de Ventas** con detalles
- 🛒 **Gestión de Compras** a proveedores
- 📊 **Reportes Avanzados** (ventas, productos, inventario)
- 👤 **Sistema de Usuarios** con roles (Admin/Vendedor)
- 📋 **Pedidos E-commerce** desde el panel

### 🛍️ Tienda E-commerce
- 🌐 **Catálogo de Productos** con búsqueda y filtros
- 🛒 **Carrito de Compras** persistente
- 🔐 **Autenticación de Clientes** (registro/login)
- 📦 **Proceso de Checkout** paso a paso
- 💳 **Múltiples Métodos de Pago** (Yape, Plin, Transferencia, Efectivo)
- 📱 **Diseño Responsive** (Mobile-first)
- 👤 **Panel de Cliente** con historial de pedidos
- 🔄 **Recuperación de Contraseña**

## 🛠️ Stack Tecnológico

### Backend
- **.NET 8.0** (ASP.NET Core Web API)
- **Entity Framework Core** (ORM)
- **MySQL** (Base de datos)
- **JWT** (Autenticación)
- **BCrypt** (Encriptación de contraseñas)

### Frontend
- **Angular 18** (Framework)
- **TypeScript**
- **Tailwind CSS** (Estilos)
- **Standalone Components**
- **Reactive Forms**
- **RxJS** (Programación reactiva)

### Base de Datos
- **MySQL 8.0+**
- Esquema unificado (Sistema Web + E-commerce)
- Datos de demostración incluidos

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- [.NET 8.0 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [Node.js 18+](https://nodejs.org/)
- [MySQL 8.0+](https://www.mysql.com/)
- [Angular CLI](https://angular.io/cli): `npm install -g @angular/cli`

## ⚙️ Instalación

### 1. Clonar el Repositorio
```bash
git clone <repository-url>
cd noblestep
```

### 2. Instalar Base de Datos

Ejecuta el script SQL ubicado en `database/BASE-DATOS-DEFINITIVA.sql`:

```bash
mysql -u root -p < database/BASE-DATOS-DEFINITIVA.sql
```

O desde MySQL:
```sql
source database/BASE-DATOS-DEFINITIVA.sql
```

Esto creará:
- Base de datos `noblestepdb`
- Todas las tablas necesarias
- Datos iniciales (usuarios, categorías, productos)
- Datos de demostración (ventas, compras)

### 3. Configurar Backend

```bash
cd backend
dotnet restore
```

Edita `appsettings.json` con tu configuración de MySQL:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=noblestepdb;User=root;Password=TU_PASSWORD;"
  },
  "JwtSettings": {
    "SecretKey": "tu-clave-secreta-muy-segura-minimo-32-caracteres",
    "Issuer": "NobleStepAPI",
    "Audience": "NobleStepClient",
    "ExpirationMinutes": 1440
  }
}
```

### 4. Configurar Frontend

```bash
cd frontend
npm install
```

## 🚀 Ejecución en Desarrollo

### Iniciar Backend (API)
```bash
cd backend
dotnet run
```
- API disponible en: `http://localhost:5000`
- Swagger UI: `http://localhost:5000/swagger`

### Iniciar Sistema Web (Admin)
```bash
cd frontend
ng serve
```
- Disponible en: `http://localhost:4200`

### Iniciar E-commerce (Tienda)
```bash
cd frontend
ng serve ecommerce --port 4201
```
- Disponible en: `http://localhost:4201`

## 👤 Credenciales por Defecto

### Panel Administrativo
- **URL**: `http://localhost:4200`
- **Usuario**: `admin`
- **Contraseña**: `admin123`

### E-commerce
- **URL**: `http://localhost:4201`
- Crea una cuenta nueva o usa una existente

## 📁 Estructura del Proyecto

```
noblestep/
├── backend/                      # API REST .NET 8
│   ├── Controllers/             # Endpoints de la API
│   ├── Models/                  # Entidades (Products, Sales, Orders, etc.)
│   ├── DTOs/                    # Data Transfer Objects
│   ├── Data/                    # DbContext y configuración EF
│   ├── Services/                # Lógica de negocio
│   ├── Helpers/                 # Utilidades (JWT, DateTime)
│   └── appsettings.json        # Configuración
│
├── frontend/                    # Workspace Angular
│   ├── src/                    # Sistema Web (Admin)
│   │   ├── app/
│   │   │   ├── dashboard/      # Dashboard principal
│   │   │   ├── products/       # Gestión de productos
│   │   │   ├── sales/          # Ventas
│   │   │   ├── purchases/      # Compras
│   │   │   ├── customers/      # Clientes
│   │   │   ├── suppliers/      # Proveedores
│   │   │   ├── reports/        # Reportes
│   │   │   ├── users/          # Usuarios
│   │   │   └── auth/           # Autenticación
│   │   └── environments/
│   │
│   └── projects/
│       └── ecommerce/          # E-commerce (Tienda)
│           ├── src/app/
│           │   ├── pages/      # Páginas (home, catalog, checkout)
│           │   ├── components/ # Componentes reutilizables
│           │   ├── services/   # Servicios (cart, shop, auth)
│           │   └── guards/     # Guards de autenticación
│           └── environments/
│
└── database/                    # Scripts SQL
    └── BASE-DATOS-DEFINITIVA.sql  # Script único con todo
```

## 📊 Base de Datos

### Tablas del Sistema Web
- `Users` - Usuarios administrativos
- `Categories` - Categorías de productos
- `Products` - Productos de calzado
- `Customers` - Clientes del sistema
- `Suppliers` - Proveedores
- `Sales` - Ventas realizadas
- `SaleDetails` - Detalles de ventas
- `Purchases` - Compras a proveedores
- `PurchaseDetails` - Detalles de compras

### Tablas del E-commerce
- `EcommerceCustomers` - Clientes de la tienda online
- `Orders` - Pedidos del e-commerce
- `OrderDetails` - Detalles de pedidos

## 🔐 Seguridad

- ✅ **JWT Authentication** para API
- ✅ **BCrypt** para hash de contraseñas
- ✅ **Guards** en rutas protegidas
- ✅ **Interceptors** para tokens
- ✅ **Validación** de formularios
- ✅ **CORS** configurado
- ✅ **SQL Injection** protection (EF Core)

## 🎨 Características Técnicas

### Backend
- API RESTful con controladores separados
- Entity Framework Core con Code First
- DTOs para transferencia de datos
- Servicios de autenticación y email
- Manejo de zona horaria (Perú)
- Validación de modelos

### Frontend
- Arquitectura modular
- Lazy loading de módulos
- Servicios reactivos con RxJS
- Guards de autenticación
- Interceptors HTTP
- Componentes standalone
- Tailwind CSS para estilos
- Responsive design

## 📦 Scripts Útiles

### Backend
```bash
# Restaurar dependencias
dotnet restore

# Ejecutar en desarrollo
dotnet run

# Compilar para producción
dotnet publish -c Release
```

### Frontend
```bash
# Instalar dependencias
npm install

# Servidor de desarrollo - Sistema Web
ng serve

# Servidor de desarrollo - E-commerce
ng serve ecommerce --port 4201

# Build para producción - Sistema Web
ng build --configuration production

# Build para producción - E-commerce
ng build ecommerce --configuration production
```

## 🌐 Despliegue

El sistema está listo para desplegarse en:
- **Backend**: Render, Railway, Fly.io, Azure
- **Frontend**: Vercel, Netlify, GitHub Pages
- **Base de Datos**: PlanetScale, Supabase, Railway

## 📝 Datos de Demostración

La base de datos incluye:
- ✅ 2 usuarios (admin, vendedor1)
- ✅ 4 categorías
- ✅ 24 productos variados
- ✅ 10 clientes
- ✅ 5 proveedores
- ✅ 15 ventas de ejemplo
- ✅ 10 compras de ejemplo

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 👨‍💻 Soporte

Para preguntas, problemas o sugerencias:
- Crear un **Issue** en el repositorio
- Contactar al equipo de desarrollo

---

**Desarrollado con ❤️ para la gestión eficiente de tiendas de calzado**
