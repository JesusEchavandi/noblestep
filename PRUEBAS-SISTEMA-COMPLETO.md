# 🧪 Guía de Pruebas del Sistema Completo

## Plan de Pruebas para Verificar Todas las Funcionalidades

---

## 📋 Preparación

### Antes de comenzar:
1. ✅ Base de datos creada e inicializada
2. ✅ Email configurado en `appsettings.json`
3. ✅ Backend corriendo en puerto 5000
4. ✅ Frontend Admin corriendo en puerto 4200
5. ✅ Frontend E-commerce corriendo en puerto 4201

### Iniciar todo el sistema:
```powershell
./INICIAR-SISTEMA-COMPLETO-CON-ECOMMERCE.ps1
```

---

## 🛍️ PRUEBAS DEL E-COMMERCE

### Prueba 1: Registro de Usuario
**Objetivo**: Verificar que los usuarios pueden crear cuenta

**Pasos**:
1. Ir a: http://localhost:4201
2. Clic en el icono de usuario (arriba derecha)
3. Clic en "Regístrate aquí"
4. Completar formulario:
   - Nombre: `Juan Pérez`
   - Email: `juan@test.com`
   - Teléfono: `999888777`
   - Contraseña: `123456`
   - Confirmar contraseña: `123456`
5. Clic en "Crear Cuenta"

**Resultado Esperado**:
- ✅ Mensaje de éxito
- ✅ Sesión iniciada automáticamente
- ✅ Icono de usuario cambia mostrando el nombre
- ✅ Menú desplegable con opciones "Mi Cuenta" y "Cerrar Sesión"

**Verificar en BD**:
```sql
SELECT * FROM EcommerceCustomers WHERE Email = 'juan@test.com';
```

---

### Prueba 2: Inicio de Sesión
**Objetivo**: Verificar que los usuarios pueden iniciar sesión

**Pasos**:
1. Si estás logueado, cerrar sesión
2. Clic en el icono de usuario
3. Ingresar:
   - Email: `juan@test.com`
   - Contraseña: `123456`
4. Clic en "Iniciar Sesión"

**Resultado Esperado**:
- ✅ Mensaje de éxito
- ✅ Redirección al home
- ✅ Nombre del usuario visible en el navbar

---

### Prueba 3: Recuperación de Contraseña
**Objetivo**: Verificar que funciona el reset de contraseña por email

**Pasos**:
1. En la pantalla de login, clic en "¿Olvidaste tu contraseña?"
2. Ingresar email: `juan@test.com`
3. Clic en "Enviar"
4. **Revisar el email** (puede tardar 5-10 segundos)
5. Abrir el email recibido
6. Clic en el enlace "Restablecer Contraseña"
7. Ingresar nueva contraseña: `nuevapass123`
8. Confirmar nueva contraseña: `nuevapass123`
9. Clic en "Restablecer Contraseña"

**Resultado Esperado**:
- ✅ Email recibido con enlace de recuperación
- ✅ Enlace redirige a página de reset
- ✅ Mensaje de éxito al cambiar contraseña
- ✅ Puede iniciar sesión con la nueva contraseña

**Verificar en BD**:
```sql
-- Después de solicitar reset:
SELECT PasswordResetToken, PasswordResetExpires FROM EcommerceCustomers WHERE Email = 'juan@test.com';

-- Después de completar reset:
-- PasswordResetToken debe ser NULL
```

---

### Prueba 4: Compra CON Sesión Iniciada
**Objetivo**: Verificar compra vinculada al usuario

**Pasos**:
1. Asegurarse de estar logueado como `juan@test.com`
2. Navegar al catálogo
3. Agregar 2-3 productos al carrito
4. Clic en el icono del carrito
5. Clic en "Proceder al Checkout"
6. Verificar que los datos están autocompletados:
   - Nombre, email, teléfono del perfil
7. Completar datos faltantes:
   - Dirección: `Av. Los Jardines 123`
   - Ciudad: `Lima`
   - Distrito: `San Isidro`
   - Referencia: `Al lado del parque`
8. Seleccionar método de pago: `Yape`
9. Seleccionar tipo de comprobante: `Boleta`
10. Clic en "Confirmar Pedido"

**Resultado Esperado**:
- ✅ Mensaje de éxito con número de pedido
- ✅ Email de confirmación recibido
- ✅ Carrito se vacía
- ✅ Stock de productos reducido

**Verificar en BD**:
```sql
-- Pedido creado con EcommerceCustomerId
SELECT * FROM Orders WHERE CustomerEmail = 'juan@test.com' ORDER BY CreatedAt DESC LIMIT 1;

-- Debe tener EcommerceCustomerId != NULL
SELECT EcommerceCustomerId FROM Orders WHERE CustomerEmail = 'juan@test.com' ORDER BY CreatedAt DESC LIMIT 1;

-- Detalles del pedido
SELECT * FROM OrderDetails WHERE OrderId = (SELECT Id FROM Orders WHERE CustomerEmail = 'juan@test.com' ORDER BY CreatedAt DESC LIMIT 1);
```

---

### Prueba 5: Compra SIN Sesión Iniciada
**Objetivo**: Verificar compra como invitado

**Pasos**:
1. **Cerrar sesión** (importante)
2. Navegar al catálogo
3. Agregar 2-3 productos al carrito
4. Clic en el carrito
5. Clic en "Proceder al Checkout"
6. Completar TODOS los datos manualmente:
   - Nombre: `María González`
   - Email: `maria@test.com`
   - Teléfono: `987654321`
   - Dirección: `Jr. Las Flores 456`
   - Ciudad: `Lima`
   - Distrito: `Miraflores`
   - DNI: `12345678`
7. Seleccionar método de pago: `Transferencia`
8. Seleccionar tipo de comprobante: `Factura`
9. Completar datos de factura:
   - Razón Social: `Empresa Test SAC`
   - RUC: `20123456789`
   - Dirección Fiscal: `Av. Principal 789`
10. Clic en "Confirmar Pedido"

**Resultado Esperado**:
- ✅ Pedido creado exitosamente
- ✅ Email de confirmación recibido en `maria@test.com`
- ✅ Carrito se vacía
- ✅ Stock reducido

**Verificar en BD**:
```sql
-- Pedido creado SIN EcommerceCustomerId
SELECT * FROM Orders WHERE CustomerEmail = 'maria@test.com' ORDER BY CreatedAt DESC LIMIT 1;

-- EcommerceCustomerId debe ser NULL
SELECT EcommerceCustomerId FROM Orders WHERE CustomerEmail = 'maria@test.com' ORDER BY CreatedAt DESC LIMIT 1;
```

---

### Prueba 6: Panel de Usuario - Ver Historial
**Objetivo**: Verificar que el usuario ve sus pedidos

**Pasos**:
1. Iniciar sesión como `juan@test.com`
2. Clic en el icono de usuario
3. Seleccionar "Mi Cuenta"
4. En la pestaña "Pedidos", verificar lista de pedidos

**Resultado Esperado**:
- ✅ Se muestra el pedido realizado en Prueba 4
- ✅ Número de pedido visible
- ✅ Estado del pedido visible
- ✅ Total visible
- ✅ Fecha visible
- ✅ Lista de productos comprados visible
- ✅ NO se muestra el pedido de María (Prueba 5)

---

### Prueba 7: Actualizar Perfil
**Objetivo**: Verificar actualización de datos del usuario

**Pasos**:
1. En "Mi Cuenta", ir a pestaña "Perfil"
2. Clic en "Editar Perfil"
3. Modificar:
   - Teléfono: `999111222`
   - Dirección: `Av. Nueva Dirección 999`
   - Ciudad: `Lima`
   - Distrito: `Surco`
   - DNI: `87654321`
4. Clic en "Guardar Cambios"

**Resultado Esperado**:
- ✅ Mensaje de éxito
- ✅ Datos actualizados visibles
- ✅ En próxima compra, datos se autocompletar con los nuevos valores

**Verificar en BD**:
```sql
SELECT * FROM EcommerceCustomers WHERE Email = 'juan@test.com';
```

---

## 👨‍💼 PRUEBAS DEL PANEL DE ADMINISTRACIÓN

### Prueba 8: Acceso al Panel de Pedidos
**Objetivo**: Verificar que el admin puede ver todos los pedidos

**Pasos**:
1. Ir a: http://localhost:4200
2. Iniciar sesión como administrador:
   - Email: `admin@noblestep.com`
   - Contraseña: la que configuraste
3. En el menú lateral, clic en "Pedidos E-commerce"

**Resultado Esperado**:
- ✅ Página carga correctamente
- ✅ Se muestran TODOS los pedidos (de Juan y María)
- ✅ Estadísticas visibles (total pedidos, total ventas)

---

### Prueba 9: Filtrar Pedidos
**Objetivo**: Verificar que los filtros funcionan

**Pasos**:
1. En el panel de pedidos
2. Probar filtro "Estado del Pedido":
   - Seleccionar "Pendiente"
   - ✅ Solo muestra pedidos pendientes
3. Probar filtro "Estado de Pago":
   - Seleccionar "Pendiente"
   - ✅ Solo muestra pedidos con pago pendiente

**Resultado Esperado**:
- ✅ Filtros funcionan correctamente
- ✅ Lista se actualiza automáticamente
- ✅ Estadísticas se actualizan según filtros

---

### Prueba 10: Ver Detalles de Pedido
**Objetivo**: Verificar que se ven todos los detalles

**Pasos**:
1. En la lista de pedidos, clic en "Ver Detalles" de cualquier pedido

**Resultado Esperado**:
- ✅ Modal o sección se expande
- ✅ Se muestra:
  - Información del cliente
  - Dirección de entrega
  - Lista de productos con cantidades
  - Subtotal, envío, total
  - Método de pago
  - Tipo de comprobante
  - Estados actuales

---

### Prueba 11: Actualizar Estado de Pedido
**Objetivo**: Verificar que el admin puede cambiar estados

**Pasos**:
1. En los detalles de un pedido
2. Cambiar "Estado del Pedido":
   - De "Pending" a "Processing"
3. Cambiar "Estado de Pago":
   - De "Pending" a "Confirmed"
4. Clic en "Actualizar Estado"

**Resultado Esperado**:
- ✅ Mensaje de éxito
- ✅ Estados actualizados visibles inmediatamente
- ✅ Si el usuario está logueado en el e-commerce, al recargar ve el nuevo estado

**Verificar en BD**:
```sql
SELECT OrderStatus, PaymentStatus FROM Orders WHERE Id = [ID_DEL_PEDIDO];
```

---

### Prueba 12: Cambiar Estado a "Enviado"
**Objetivo**: Verificar actualización de fechas

**Pasos**:
1. Actualizar un pedido a estado "Shipped"
2. Verificar que se actualiza la fecha de envío

**Verificar en BD**:
```sql
SELECT OrderStatus, ShippedDate FROM Orders WHERE Id = [ID_DEL_PEDIDO];
-- ShippedDate debe tener un valor
```

---

## 📊 VERIFICACIONES EN BASE DE DATOS

### Verificar Estructura Completa

```sql
-- Ver todos los clientes e-commerce registrados
SELECT Id, Email, FullName, Phone, IsActive, EmailVerified, CreatedAt 
FROM EcommerceCustomers;

-- Ver todos los pedidos (con y sin sesión)
SELECT 
    Id, 
    OrderNumber, 
    EcommerceCustomerId,
    CustomerFullName,
    CustomerEmail,
    Total,
    OrderStatus,
    PaymentStatus,
    OrderDate
FROM Orders
ORDER BY OrderDate DESC;

-- Ver pedidos CON sesión
SELECT * FROM Orders WHERE EcommerceCustomerId IS NOT NULL;

-- Ver pedidos SIN sesión (invitados)
SELECT * FROM Orders WHERE EcommerceCustomerId IS NULL;

-- Ver detalles de un pedido específico
SELECT 
    o.OrderNumber,
    od.ProductName,
    od.Quantity,
    od.UnitPrice,
    od.Subtotal
FROM Orders o
JOIN OrderDetails od ON o.Id = od.OrderId
WHERE o.Id = [ID_DEL_PEDIDO];

-- Verificar reducción de stock
SELECT Id, Name, Stock FROM Products WHERE Id IN ([IDS_DE_PRODUCTOS_COMPRADOS]);
```

---

## ✅ Checklist de Pruebas Completadas

### E-commerce (Frontend Cliente)
- [ ] Registro de usuario funciona
- [ ] Inicio de sesión funciona
- [ ] Recuperación de contraseña por email funciona
- [ ] Email de recuperación llega correctamente
- [ ] Compra con sesión funciona
- [ ] Compra sin sesión funciona
- [ ] Email de confirmación llega (con sesión)
- [ ] Email de confirmación llega (sin sesión)
- [ ] Historial de pedidos visible en "Mi Cuenta"
- [ ] Solo se ven los pedidos del usuario logueado
- [ ] Actualización de perfil funciona
- [ ] Datos actualizados se usan en próximas compras

### Panel de Administración (Frontend Admin)
- [ ] Acceso al panel funciona
- [ ] Se muestran todos los pedidos (con y sin sesión)
- [ ] Filtro por estado de pedido funciona
- [ ] Filtro por estado de pago funciona
- [ ] Ver detalles de pedido funciona
- [ ] Actualizar estado de pedido funciona
- [ ] Actualizar estado de pago funciona
- [ ] Estadísticas se muestran correctamente

### Base de Datos
- [ ] EcommerceCustomers se crea correctamente
- [ ] Contraseñas están hasheadas
- [ ] Orders con EcommerceCustomerId (con sesión)
- [ ] Orders sin EcommerceCustomerId (sin sesión)
- [ ] OrderDetails se crean correctamente
- [ ] Stock se reduce al hacer pedido
- [ ] Tokens de recuperación se guardan y expiran

### Sistema de Emails
- [ ] Email de recuperación se envía
- [ ] Email de confirmación se envía
- [ ] Emails llegan en tiempo razonable
- [ ] Formato de emails es correcto

---

## 🐛 Problemas Comunes y Soluciones

### Email no llega
1. Verifica configuración en `appsettings.json`
2. Verifica que sea contraseña de aplicación de Gmail
3. Revisa carpeta de spam
4. Revisa logs del backend

### No puedo ver mis pedidos
1. Verifica que hayas iniciado sesión
2. Solo verás pedidos realizados CON sesión
3. Los pedidos como invitado NO aparecen en "Mi Cuenta"

### Panel admin no muestra pedidos
1. Verifica que estés autenticado como admin
2. Verifica que haya pedidos en la BD
3. Revisa consola del navegador

### Error al actualizar estado
1. Verifica que el backend esté corriendo
2. Revisa logs del backend
3. Verifica token de autenticación

---

## 📝 Reporte de Pruebas

Después de completar todas las pruebas, documenta:

**Fecha de pruebas**: _______________

**Resultados**:
- ✅ Funcionalidades OK: _____ / 15
- ❌ Funcionalidades con problemas: _____
- 📝 Comentarios: _____________________

**Problemas encontrados**:
1. _________________________________
2. _________________________________
3. _________________________________

---

**¡Pruebas completadas! Sistema verificado.** ✅
