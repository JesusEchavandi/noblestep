# Guía de Implementación - Sistema de Autenticación y Pedidos E-commerce

## 📋 Resumen de Implementación

Se ha implementado un sistema completo de autenticación y gestión de pedidos para el e-commerce de NobleStep, que incluye:

### ✅ Funcionalidades Implementadas

#### 1. **Sistema de Autenticación de Clientes**
- ✅ Registro de nuevos clientes
- ✅ Login con email y contraseña
- ✅ Recuperación de contraseña vía email (Gmail)
- ✅ Tokens JWT para sesiones seguras
- ✅ Guard para proteger rutas privadas

#### 2. **Panel de Usuario**
- ✅ Historial de pedidos del cliente
- ✅ Detalles completos de cada pedido
- ✅ Edición de perfil (nombre, teléfono, dirección, etc.)
- ✅ Configuración de cuenta
- ✅ Cerrar sesión

#### 3. **Sistema de Pedidos**
- ✅ Creación de pedidos CON sesión iniciada
- ✅ Creación de pedidos SIN sesión iniciada (como invitado)
- ✅ Guardado en base de datos con toda la información
- ✅ Reducción automática de stock
- ✅ Cálculo de envío (gratis si compra >= S/ 100)
- ✅ Email de confirmación automático
- ✅ Soporte para múltiples métodos de pago (Yape, Tarjeta, Transferencia)
- ✅ Opciones de facturación (Boleta/Factura)

#### 4. **Panel de Administración**
- ✅ Vista completa de todos los pedidos del e-commerce
- ✅ Filtros por estado de pedido y estado de pago
- ✅ Actualización de estado de pedidos
- ✅ Confirmación de pagos
- ✅ Vista detallada de cada pedido
- ✅ Estadísticas de ventas totales
- ✅ Acceso exclusivo para administradores

---

## 🗄️ Base de Datos

### Nuevas Tablas Creadas

#### **EcommerceCustomers** - Clientes del e-commerce
```sql
- Id (PK)
- Email (Unique, para login)
- PasswordHash (Encriptada con BCrypt)
- FullName
- Phone, DocumentNumber, Address, City, District
- IsActive, EmailVerified
- PasswordResetToken, PasswordResetExpires
- CreatedAt, UpdatedAt
```

#### **Orders** - Pedidos del e-commerce
```sql
- Id (PK)
- EcommerceCustomerId (FK, nullable para invitados)
- OrderNumber (Unique, formato: ORD-YYYYMMDD-XXXXXXXX)
- Customer* (Información guardada del cliente)
- Subtotal, ShippingCost, Total
- PaymentMethod, PaymentDetails, PaymentStatus
- OrderStatus (Pending, Processing, Shipped, Delivered, Cancelled)
- InvoiceType, Company* (para facturas)
- OrderDate, ProcessedDate, ShippedDate, DeliveredDate
- CreatedAt, UpdatedAt
```

#### **OrderDetails** - Detalles de pedidos
```sql
- Id (PK)
- OrderId (FK)
- ProductId (FK)
- Product* (Snapshot del producto al momento del pedido)
- Quantity, UnitPrice, Subtotal
```

### Script de Instalación
Ejecutar: `database/create-ecommerce-tables.sql`

---

## 🔧 Configuración Requerida

### Backend - `appsettings.json`

```json
{
  "Email": {
    "FromEmail": "tu-email@gmail.com",
    "FromName": "NobleStep Shop",
    "SmtpHost": "smtp.gmail.com",
    "SmtpPort": "587",
    "SmtpUsername": "tu-email@gmail.com",
    "SmtpPassword": "tu-contraseña-de-aplicacion-gmail"
  },
  "App": {
    "FrontendUrl": "http://localhost:4201"
  }
}
```

### Configurar Gmail para Envío de Emails

1. Ve a tu cuenta de Google: https://myaccount.google.com/
2. Seguridad → Verificación en dos pasos (debe estar activada)
3. Contraseñas de aplicaciones → Crear nueva
4. Copia la contraseña generada (16 caracteres)
5. Pégala en `SmtpPassword` en `appsettings.json`

---

## 🚀 Nuevos Endpoints del Backend

### **Autenticación E-commerce** (`/api/ecommerce/auth`)

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/register` | Registrar nuevo cliente |
| POST | `/login` | Iniciar sesión |
| POST | `/forgot-password` | Solicitar recuperación |
| POST | `/reset-password` | Restablecer contraseña |
| GET | `/profile` | Obtener perfil (requiere auth) |
| PUT | `/profile` | Actualizar perfil (requiere auth) |

### **Pedidos E-commerce** (`/api/ecommerce/orders`)

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/` | Crear pedido (con/sin sesión) |
| GET | `/my-orders` | Mis pedidos (requiere auth) |
| GET | `/{id}` | Detalle de pedido |

### **Admin - Pedidos** (`/api/admin/ecommerce-orders`)

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/` | Listar todos los pedidos |
| PUT | `/{id}/status` | Actualizar estado |

---

## 🎨 Nuevas Rutas del Frontend E-commerce

| Ruta | Componente | Protegida | Descripción |
|------|------------|-----------|-------------|
| `/login` | LoginComponent | No | Login y Registro |
| `/reset-password` | ResetPasswordComponent | No | Restablecer contraseña |
| `/account` | AccountComponent | ✅ Sí | Panel de usuario |
| `/checkout` | CheckoutComponent | No | Modificado para guardar pedidos |

### Rutas del Sistema Admin

| Ruta | Componente | Descripción |
|------|------------|-------------|
| `/ecommerce-orders` | EcommerceOrdersComponent | Gestión de pedidos |

---

## 📦 Archivos Principales Creados/Modificados

### Backend
```
backend/
├── Models/
│   ├── EcommerceCustomer.cs          ✨ NUEVO
│   ├── Order.cs                      ✨ NUEVO
│   └── OrderDetail.cs                ✨ NUEVO
├── DTOs/
│   ├── EcommerceAuthDto.cs           ✨ NUEVO
│   └── OrderDto.cs                   ✨ NUEVO
├── Controllers/
│   ├── EcommerceAuthController.cs    ✨ NUEVO
│   ├── OrdersController.cs           ✨ NUEVO
│   └── AdminEcommerceOrdersController.cs ✨ NUEVO
├── Services/
│   └── EmailService.cs               ✨ NUEVO
├── Data/
│   └── AppDbContext.cs               📝 MODIFICADO
├── Program.cs                        📝 MODIFICADO
└── appsettings.json                  📝 MODIFICADO
```

### Frontend E-commerce
```
frontend/projects/ecommerce/src/app/
├── services/
│   ├── ecommerce-auth.service.ts     ✨ NUEVO
│   └── order.service.ts              ✨ NUEVO
├── guards/
│   └── ecommerce-auth.guard.ts       ✨ NUEVO
├── interceptors/
│   └── ecommerce-auth.interceptor.ts ✨ NUEVO
├── pages/
│   ├── login/
│   │   └── login.component.ts        ✨ NUEVO
│   ├── reset-password/
│   │   └── reset-password.component.ts ✨ NUEVO
│   ├── account/
│   │   ├── account.component.ts      ✨ NUEVO
│   │   ├── account.component.html    ✨ NUEVO
│   │   └── account.component.css     ✨ NUEVO
│   └── checkout/
│       └── checkout.component.ts     📝 MODIFICADO
├── components/
│   └── navbar/
│       └── navbar.component.ts       📝 MODIFICADO
├── app.config.ts                     📝 MODIFICADO
└── app.routes.ts                     📝 MODIFICADO
```

### Frontend Sistema Admin
```
frontend/src/app/
├── ecommerce-orders/
│   └── ecommerce-orders.component.ts ✨ NUEVO
├── layout/
│   └── main-layout.component.ts      📝 MODIFICADO
└── app.routes.ts                     📝 MODIFICADO
```

---

## 🧪 Flujo de Prueba Completo

### 1. **Preparar Base de Datos**
```bash
# Ejecutar script SQL
mysql -u root -p noblestepdb < database/create-ecommerce-tables.sql
```

### 2. **Configurar Email en Backend**
Editar `backend/appsettings.json` con tus credenciales de Gmail

### 3. **Iniciar Backend**
```bash
cd backend
dotnet run
# Debe correr en http://localhost:5000
```

### 4. **Iniciar Frontend E-commerce**
```bash
cd frontend
npm start -- --project ecommerce
# Debe correr en http://localhost:4201
```

### 5. **Iniciar Frontend Sistema Admin**
```bash
cd frontend
npm start
# Debe correr en http://localhost:4200
```

### 6. **Probar Registro de Cliente**
- Ir a: http://localhost:4201/login
- Click en "Regístrate aquí"
- Completar formulario
- Verificar que se crea la sesión

### 7. **Probar Recuperación de Contraseña**
- Click en "¿Olvidaste tu contraseña?"
- Ingresar email registrado
- Verificar que llega el email
- Click en el enlace del email
- Establecer nueva contraseña

### 8. **Probar Compra CON Sesión**
- Con sesión iniciada, agregar productos al carrito
- Ir a checkout
- Verificar que los datos se pre-llenan
- Completar y confirmar pedido
- Verificar redirección a `/account`
- Verificar que el pedido aparece en "Mis Pedidos"

### 9. **Probar Compra SIN Sesión (Invitado)**
- Cerrar sesión
- Agregar productos al carrito
- Ir a checkout
- Completar todos los datos manualmente
- Confirmar pedido
- Verificar que se guarda en la base de datos

### 10. **Probar Panel de Administración**
- Iniciar sesión en sistema admin (http://localhost:4200)
- Usuario: admin / Contraseña: admin123
- Ir a "Pedidos E-commerce" en el menú
- Verificar que aparecen los pedidos
- Cambiar estados de pedidos
- Confirmar pagos
- Ver detalles de pedidos

---

## 🔐 Seguridad Implementada

- ✅ Contraseñas encriptadas con BCrypt
- ✅ Tokens JWT con expiración (7 días)
- ✅ Guards para proteger rutas privadas
- ✅ Interceptor para agregar token automáticamente
- ✅ Validación de permisos en backend
- ✅ Tokens de recuperación con expiración (1 hora)
- ✅ Protección contra SQL injection (Entity Framework)

---

## 📧 Sistema de Emails

### Emails Automáticos Enviados

1. **Recuperación de Contraseña**
   - Se envía al solicitar "Olvidé mi contraseña"
   - Contiene enlace con token único
   - Expira en 1 hora

2. **Confirmación de Pedido**
   - Se envía al completar un pedido
   - Incluye número de pedido
   - Confirma recepción del pedido

---

## 🎯 Próximas Mejoras Sugeridas

- [ ] Email de verificación de cuenta
- [ ] Notificaciones de cambio de estado de pedido
- [ ] Sistema de calificación de productos
- [ ] Historial de direcciones de envío
- [ ] Lista de deseos
- [ ] Cupones de descuento
- [ ] Integración con pasarelas de pago reales
- [ ] Generación automática de comprobantes PDF
- [ ] Chat de soporte en tiempo real

---

## 🆘 Solución de Problemas

### Error: No se envían emails
- Verificar credenciales de Gmail en `appsettings.json`
- Verificar que la verificación en dos pasos esté activada
- Usar contraseña de aplicación, no la contraseña normal de Gmail
- Verificar conexión a internet

### Error: Token inválido
- El token de recuperación expira en 1 hora
- Solicitar nuevo token si expiró
- Verificar que el frontend apunte al backend correcto

### Error: No aparecen pedidos en admin
- Verificar que el usuario sea Administrator
- Verificar que el backend esté corriendo
- Revisar la consola del navegador para errores
- Verificar la URL de la API en el componente

### Error: Stock no se reduce
- Verificar que los productos existan en la base de datos
- Revisar logs del backend para errores
- Verificar que la transacción se complete correctamente

---

## 📊 Diagrama de Flujo

### Flujo de Compra CON Sesión
```
Usuario → Login → Navegar Catálogo → Agregar al Carrito → 
Checkout (datos pre-llenados) → Confirmar Pedido → 
Backend guarda pedido + reduce stock → Email confirmación → 
Usuario redirigido a "Mis Pedidos"
```

### Flujo de Compra SIN Sesión
```
Usuario → Navegar Catálogo → Agregar al Carrito → 
Checkout (llenar todos los datos) → Confirmar Pedido → 
Backend guarda pedido + reduce stock → Email confirmación → 
Usuario redirigido a Home
```

### Flujo de Recuperación de Contraseña
```
Usuario → "Olvidé mi contraseña" → Ingresa email → 
Backend genera token → Email con enlace → 
Usuario click enlace → Ingresa nueva contraseña → 
Backend actualiza contraseña → Login con nueva contraseña
```

---

## 🎉 ¡Sistema Completo y Funcional!

El sistema de autenticación y pedidos del e-commerce está completamente implementado y listo para usar. Todos los componentes están integrados y probados.

**Fecha de implementación:** Febrero 2026  
**Versión:** 1.0.0
