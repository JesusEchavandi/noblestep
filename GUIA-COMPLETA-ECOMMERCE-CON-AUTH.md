# 🛒 Guía Completa del E-commerce con Autenticación y Panel de Administración

## 📋 Índice
1. [Funcionalidades Implementadas](#funcionalidades-implementadas)
2. [Configuración de Email (Gmail)](#configuración-de-email-gmail)
3. [Estructura del Sistema](#estructura-del-sistema)
4. [Flujos de Usuario](#flujos-de-usuario)
5. [Panel de Administración](#panel-de-administración)
6. [Guía de Uso](#guía-de-uso)

---

## ✅ Funcionalidades Implementadas

### 🔐 Sistema de Autenticación Completo
- ✅ **Registro de usuarios** con email y contraseña
- ✅ **Inicio de sesión** con validación de credenciales
- ✅ **Recuperación de contraseña vía email** (Gmail)
- ✅ **Panel único de usuario** con historial de pedidos
- ✅ **Actualización de perfil** (nombre, teléfono, dirección, etc.)
- ✅ **Gestión de sesión** con JWT tokens

### 🛍️ Sistema de Pedidos
- ✅ **Compras CON sesión iniciada** (vinculadas al usuario)
- ✅ **Compras SIN sesión iniciada** (como invitado)
- ✅ **Historial de pedidos** en el panel de usuario
- ✅ **Confirmación por email** al realizar pedido
- ✅ **Diferentes métodos de pago** (Yape, Tarjeta, Transferencia)
- ✅ **Boleta o Factura** con datos de empresa

### 👨‍💼 Panel de Administración
- ✅ **Vista de todos los pedidos** del e-commerce
- ✅ **Filtros por estado** de pedido y pago
- ✅ **Actualización de estados** de pedidos
- ✅ **Detalles completos** de cada pedido
- ✅ **Estadísticas de ventas** en tiempo real
- ✅ **Acceso exclusivo** para administradores del sistema

---

## 📧 Configuración de Email (Gmail)

### Paso 1: Obtener Contraseña de Aplicación de Gmail

1. **Ir a tu cuenta de Google**:
   - Ve a https://myaccount.google.com/

2. **Activar verificación en 2 pasos** (si no está activa):
   - Seguridad → Verificación en 2 pasos → Activar

3. **Crear Contraseña de Aplicación**:
   - Seguridad → Contraseñas de aplicaciones
   - Selecciona "Correo" y "Windows Computer"
   - Google generará una contraseña de 16 caracteres
   - **Guarda esta contraseña** (solo se muestra una vez)

### Paso 2: Configurar en el Backend

Edita el archivo `backend/appsettings.json`:

```json
{
  "Email": {
    "FromEmail": "tuCorreo@gmail.com",
    "FromName": "NobleStep Shop",
    "SmtpHost": "smtp.gmail.com",
    "SmtpPort": "587",
    "SmtpUsername": "tuCorreo@gmail.com",
    "SmtpPassword": "xxxx xxxx xxxx xxxx"
  },
  "App": {
    "FrontendUrl": "http://localhost:4201"
  }
}
```

**⚠️ Importante:**
- Reemplaza `tuCorreo@gmail.com` con tu email real
- Reemplaza `xxxx xxxx xxxx xxxx` con la contraseña de aplicación de Gmail
- **NO uses tu contraseña normal de Gmail**
- Mantén este archivo seguro y no lo subas a repositorios públicos

### Paso 3: Probar el Envío de Emails

El sistema enviará emails automáticamente en dos casos:
1. **Recuperación de contraseña**: Cuando un usuario solicite restablecer su contraseña
2. **Confirmación de pedido**: Cuando se realice una compra

---

## 🏗️ Estructura del Sistema

### Backend (API)

```
backend/
├── Controllers/
│   ├── EcommerceAuthController.cs      # Autenticación e-commerce
│   ├── OrdersController.cs             # Gestión de pedidos
│   └── AdminEcommerceOrdersController.cs # Admin: ver todos los pedidos
├── Models/
│   ├── EcommerceCustomer.cs           # Modelo de cliente
│   ├── Order.cs                        # Modelo de pedido
│   └── OrderDetail.cs                  # Detalle de productos
├── Services/
│   └── EmailService.cs                 # Servicio de envío de emails
└── DTOs/
    ├── EcommerceAuthDto.cs            # DTOs de autenticación
    └── OrderDto.cs                     # DTOs de pedidos
```

### Frontend E-commerce

```
frontend/projects/ecommerce/src/app/
├── pages/
│   ├── login/                         # Login y registro
│   ├── reset-password/                # Restablecer contraseña
│   ├── account/                       # Panel de usuario
│   ├── checkout/                      # Finalizar compra
│   └── ...
├── services/
│   ├── ecommerce-auth.service.ts     # Servicio de autenticación
│   └── order.service.ts              # Servicio de pedidos
└── guards/
    └── ecommerce-auth.guard.ts       # Protección de rutas
```

### Frontend Admin

```
frontend/src/app/
└── ecommerce-orders/
    └── ecommerce-orders.component.ts  # Panel admin de pedidos
```

---

## 👤 Flujos de Usuario

### Flujo 1: Compra como Invitado (Sin Sesión)

```
1. Usuario navega el catálogo
2. Agrega productos al carrito
3. Va al checkout
4. Completa formulario con:
   - Nombre, email, teléfono
   - Dirección de entrega
   - Método de pago
   - Tipo de comprobante
5. Confirma pedido
6. Recibe email de confirmación
7. Pedido se guarda en la BD (sin EcommerceCustomerId)
```

### Flujo 2: Compra con Sesión Iniciada

```
1. Usuario hace login/registro
2. Navega el catálogo
3. Agrega productos al carrito
4. Va al checkout
5. Sistema autocompleta datos del perfil
6. Confirma pedido
7. Recibe email de confirmación
8. Pedido se guarda vinculado al usuario
9. Puede ver el pedido en "Mi Cuenta"
```

### Flujo 3: Recuperación de Contraseña

```
1. Usuario hace clic en "¿Olvidaste tu contraseña?"
2. Ingresa su email
3. Sistema envía email con token
4. Usuario hace clic en el enlace del email
5. Ingresa nueva contraseña
6. Sistema actualiza contraseña
7. Usuario puede iniciar sesión con nueva contraseña
```

### Flujo 4: Panel de Usuario

```
1. Usuario inicia sesión
2. Va a "Mi Cuenta"
3. Puede ver:
   - Historial de pedidos
   - Estado de cada pedido
   - Detalles de productos comprados
   - Información de entrega
4. Puede editar su perfil:
   - Nombre, teléfono
   - Dirección, ciudad, distrito
   - Número de documento
```

---

## 👨‍💼 Panel de Administración

### Acceso al Panel

**URL**: http://localhost:4200/ecommerce-orders

**Requisitos**: 
- Iniciar sesión como administrador en el sistema web
- El panel aparece en el menú lateral como "Pedidos E-commerce"

### Funcionalidades del Panel Admin

#### 1. Vista de Todos los Pedidos
- Muestra **todos los pedidos** del e-commerce (con y sin sesión)
- Información visible:
  - Número de pedido
  - Cliente (nombre, email, teléfono)
  - Fecha del pedido
  - Total
  - Estado de pago
  - Estado del pedido

#### 2. Filtros Disponibles
- **Por Estado del Pedido**:
  - Pending (Pendiente)
  - Processing (Procesando)
  - Shipped (Enviado)
  - Delivered (Entregado)
  - Cancelled (Cancelado)

- **Por Estado de Pago**:
  - Pending (Pendiente)
  - Confirmed (Confirmado)
  - Rejected (Rechazado)

#### 3. Acciones Disponibles
- ✅ Ver detalles completos del pedido
- ✅ Actualizar estado del pedido
- ✅ Actualizar estado de pago
- ✅ Ver productos comprados
- ✅ Ver información de cliente y entrega

#### 4. Estadísticas
- Total de pedidos
- Total de ventas (suma de todos los pedidos)

### Endpoints del Backend

```
GET  /api/admin/ecommerce-orders
     - Obtiene todos los pedidos
     - Filtros: ?status=Pending&paymentStatus=Confirmed

PUT  /api/admin/ecommerce-orders/{id}/status
     - Actualiza estado del pedido
     - Body: { "orderStatus": "Shipped", "paymentStatus": "Confirmed" }
```

---

## 📖 Guía de Uso

### Para el Cliente (E-commerce)

#### Registrarse y Crear Cuenta

1. **Ir al E-commerce**: http://localhost:4201
2. **Hacer clic en el icono de usuario** (arriba derecha)
3. **Seleccionar "Regístrate aquí"**
4. **Completar formulario**:
   - Nombre completo
   - Email
   - Teléfono (opcional)
   - Contraseña
5. **Hacer clic en "Crear Cuenta"**
6. ✅ **Se crea la cuenta y se inicia sesión automáticamente**

#### Iniciar Sesión

1. **Hacer clic en el icono de usuario**
2. **Ingresar email y contraseña**
3. **Hacer clic en "Iniciar Sesión"**
4. ✅ **Sesión iniciada**

#### Recuperar Contraseña

1. **En la pantalla de login**
2. **Hacer clic en "¿Olvidaste tu contraseña?"**
3. **Ingresar tu email**
4. **Revisar tu correo** (puede tardar unos segundos)
5. **Hacer clic en el enlace del email**
6. **Ingresar nueva contraseña**
7. ✅ **Contraseña actualizada**

#### Realizar una Compra

**Con Sesión**:
1. Navegar el catálogo
2. Agregar productos al carrito
3. Ir al checkout
4. Datos se autocompletar desde el perfil
5. Seleccionar método de pago
6. Confirmar pedido
7. ✅ Ver pedido en "Mi Cuenta"

**Sin Sesión**:
1. Navegar el catálogo
2. Agregar productos al carrito
3. Ir al checkout
4. Completar todos los datos manualmente
5. Seleccionar método de pago
6. Confirmar pedido
7. ✅ Recibir confirmación por email

#### Ver Historial de Pedidos

1. **Iniciar sesión**
2. **Hacer clic en el icono de usuario**
3. **Ir a "Mi Cuenta"**
4. **Ver en la pestaña "Pedidos"**:
   - Todos tus pedidos
   - Estado actual
   - Productos comprados
   - Información de entrega

#### Actualizar Perfil

1. **Ir a "Mi Cuenta"**
2. **Pestaña "Perfil"**
3. **Hacer clic en "Editar Perfil"**
4. **Actualizar información**:
   - Nombre
   - Teléfono
   - Dirección, ciudad, distrito
   - Número de documento
5. **Guardar cambios**

### Para el Administrador

#### Acceder al Panel de Pedidos

1. **Iniciar sesión en el sistema web**: http://localhost:4200
2. **En el menú lateral** → **"Pedidos E-commerce"**
3. ✅ **Ver todos los pedidos del e-commerce**

#### Filtrar Pedidos

1. **Usar los selectores de filtros**:
   - Estado del Pedido
   - Estado de Pago
2. ✅ **La lista se actualiza automáticamente**

#### Ver Detalles de un Pedido

1. **Hacer clic en "Ver Detalles"** en cualquier pedido
2. **Se muestra**:
   - Información del cliente
   - Dirección de entrega
   - Productos comprados (con cantidades y precios)
   - Subtotal, envío, total
   - Método de pago y tipo de comprobante
   - Estados actuales

#### Actualizar Estado de un Pedido

1. **En el detalle del pedido**
2. **Cambiar el estado del pedido**:
   - Pending → Processing → Shipped → Delivered
   - O → Cancelled
3. **Cambiar estado de pago** (si es necesario):
   - Pending → Confirmed / Rejected
4. **Hacer clic en "Actualizar Estado"**
5. ✅ **Estado actualizado en la base de datos**

---

## 🗄️ Base de Datos

### Tablas Principales

#### `EcommerceCustomers`
- Almacena usuarios registrados del e-commerce
- Incluye email, contraseña hasheada, datos personales
- Tokens de recuperación de contraseña

#### `Orders`
- Almacena todos los pedidos (con y sin sesión)
- `EcommerceCustomerId` puede ser NULL (compras sin sesión)
- Información completa del cliente y entrega
- Estados de pedido y pago

#### `OrderDetails`
- Detalles de cada producto en el pedido
- Snapshot del producto al momento de la compra
- Cantidades, precios unitarios, subtotales

---

## 🔒 Seguridad Implementada

### Autenticación
- ✅ Contraseñas hasheadas con BCrypt
- ✅ JWT tokens para sesiones
- ✅ Tokens de recuperación de contraseña con expiración (1 hora)
- ✅ Validación de email y contraseña
- ✅ Guards para proteger rutas

### Autorización
- ✅ Solo usuarios autenticados pueden ver "Mi Cuenta"
- ✅ Solo administradores pueden acceder al panel de pedidos
- ✅ Los usuarios solo pueden ver sus propios pedidos

### Datos Sensibles
- ✅ Contraseñas nunca se almacenan en texto plano
- ✅ Tokens de recuperación se invalidan después de usar
- ✅ Configuración de email no se expone al cliente

---

## 🚀 Iniciar el Sistema Completo

### Opción 1: Script Automático

```powershell
./INICIAR-SISTEMA-COMPLETO-CON-ECOMMERCE.ps1
```

Este script inicia:
- Backend API (puerto 5000)
- Frontend Admin (puerto 4200)
- Frontend E-commerce (puerto 4201)

### Opción 2: Manual

**Terminal 1 - Backend**:
```powershell
cd backend
dotnet run
```

**Terminal 2 - Frontend Admin**:
```powershell
cd frontend
npm start
```

**Terminal 3 - Frontend E-commerce**:
```powershell
cd frontend
npm run start:ecommerce
```

---

## 🧪 Probar el Sistema

### 1. Configurar Email
```json
// backend/appsettings.json
{
  "Email": {
    "FromEmail": "tuCorreo@gmail.com",
    "SmtpPassword": "tu-contraseña-de-aplicacion"
  }
}
```

### 2. Iniciar el sistema
```powershell
./INICIAR-SISTEMA-COMPLETO-CON-ECOMMERCE.ps1
```

### 3. Probar E-commerce (Puerto 4201)

**Test 1: Registro**
- Ir a http://localhost:4201
- Clic en icono de usuario
- Registrarse con email y contraseña
- ✅ Verificar que se crea la cuenta

**Test 2: Recuperación de Contraseña**
- Clic en "¿Olvidaste tu contraseña?"
- Ingresar email
- ✅ Verificar que llega el email
- Clic en enlace
- Cambiar contraseña
- ✅ Verificar que puede iniciar sesión

**Test 3: Compra con Sesión**
- Iniciar sesión
- Agregar productos al carrito
- Ir al checkout
- Confirmar pedido
- ✅ Verificar email de confirmación
- ✅ Ver pedido en "Mi Cuenta"

**Test 4: Compra sin Sesión**
- Cerrar sesión
- Agregar productos al carrito
- Ir al checkout
- Completar datos manualmente
- Confirmar pedido
- ✅ Verificar email de confirmación

### 4. Probar Panel Admin (Puerto 4200)

**Test 1: Ver Pedidos**
- Iniciar sesión como admin
- Ir a "Pedidos E-commerce"
- ✅ Ver todos los pedidos

**Test 2: Filtrar Pedidos**
- Usar filtros de estado
- ✅ Verificar que filtra correctamente

**Test 3: Actualizar Estado**
- Abrir detalles de un pedido
- Cambiar estado
- ✅ Verificar que se actualiza

---

## 📝 Notas Importantes

### Pedidos con y sin Sesión
- **Con sesión**: El campo `EcommerceCustomerId` tiene un valor, vinculando el pedido al usuario
- **Sin sesión**: El campo `EcommerceCustomerId` es NULL, pero se guardan todos los datos del cliente

### Emails
- Los emails pueden tardar unos segundos en llegar
- Revisa la carpeta de spam si no llegan
- Verifica que la configuración de Gmail sea correcta

### Seguridad
- No subas `appsettings.json` con credenciales reales a repositorios públicos
- Usa variables de entorno en producción
- Cambia la clave JWT en producción

---

## 🆘 Solución de Problemas

### No llegan los emails
1. Verifica que la contraseña de aplicación sea correcta
2. Verifica que la verificación en 2 pasos esté activa
3. Revisa los logs del backend para ver errores
4. Verifica la carpeta de spam

### Error al crear pedido
1. Verifica que el backend esté corriendo
2. Verifica que haya stock disponible
3. Revisa la consola del navegador para ver errores
4. Verifica los logs del backend

### No puedo iniciar sesión
1. Verifica que el email y contraseña sean correctos
2. Usa la opción "Recuperar contraseña" si olvidaste tu contraseña
3. Verifica que el backend esté corriendo

### Panel de admin no muestra pedidos
1. Verifica que estés autenticado como administrador
2. Verifica que haya pedidos en la base de datos
3. Revisa la consola del navegador para ver errores

---

## ✅ Checklist de Funcionalidades

- ✅ Registro de usuarios
- ✅ Inicio de sesión
- ✅ Recuperación de contraseña por email
- ✅ Panel de usuario con historial
- ✅ Actualización de perfil
- ✅ Compras con sesión (vinculadas al usuario)
- ✅ Compras sin sesión (como invitado)
- ✅ Email de confirmación de pedido
- ✅ Panel de administración para ver todos los pedidos
- ✅ Filtros de pedidos por estado
- ✅ Actualización de estados de pedidos
- ✅ Diferentes métodos de pago
- ✅ Boleta/Factura
- ✅ Gestión de stock automática

---

## 📧 Contacto y Soporte

Si tienes alguna duda o problema:
1. Revisa esta guía completa
2. Verifica los logs del backend
3. Revisa la consola del navegador
4. Verifica la configuración de email

---

**¡Sistema completo y funcionando! 🎉**
