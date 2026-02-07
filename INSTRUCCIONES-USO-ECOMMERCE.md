# 📖 INSTRUCCIONES DE USO - ECOMMERCE NOBLESTEP

## 🚀 INICIO RÁPIDO

### Opción 1: Script Automático (Recomendado)
```powershell
.\INICIAR-ECOMMERCE-MEJORADO.ps1
```

### Opción 2: Inicio Manual en 2 Terminales

**Terminal 1 - Backend:**
```powershell
cd backend
dotnet run --urls "http://localhost:5000"
```

**Terminal 2 - E-commerce:**
```powershell
cd frontend
npm run start:ecommerce
```

⏱️ **Tiempo de inicio:** 
- Backend: 10-20 segundos
- E-commerce: 30-60 segundos (primera compilación)

---

## 🌐 ACCESO AL SISTEMA

Una vez iniciado, acceder a:

| Servicio | URL | Descripción |
|----------|-----|-------------|
| **E-commerce** | http://localhost:4201 | Tienda online para clientes |
| **Backend API** | http://localhost:5000 | API REST |
| **Swagger UI** | http://localhost:5000/swagger | Documentación API |
| **Admin Panel** | http://localhost:4200 | Panel administrativo |

---

## 🛍️ FUNCIONALIDADES DEL ECOMMERCE

### 1. 🏠 Página de Inicio
- Ver productos destacados (últimos 8 agregados)
- Características de la tienda
- Acceso rápido al catálogo

### 2. 📦 Catálogo de Productos
**Filtros disponibles:**
- 🔍 Búsqueda por nombre/marca
- 📁 Filtro por categoría
- 💰 Rango de precio (min-max)

**Acciones:**
- Ver detalles del producto
- Agregar al carrito directamente

### 3. 🔍 Detalle de Producto
- Información completa del producto
- Stock disponible
- Selector de cantidad
- Validación de stock máximo
- Agregar al carrito

### 4. 🛒 Carrito de Compras
**Funciones:**
- Ver todos los productos agregados
- Modificar cantidades (+/-)
- Eliminar productos individuales
- Vaciar carrito completo
- Ver subtotales y total
- **Proceder al pago (WhatsApp)**

### 5. 📞 Contacto
**Formulario incluye:**
- Nombre completo
- Email
- Teléfono
- Mensaje
- Validación en tiempo real

---

## ✨ NUEVAS CARACTERÍSTICAS

### 🔔 Sistema de Notificaciones
Las notificaciones aparecen en la esquina superior derecha:

| Tipo | Color | Cuándo Aparece |
|------|-------|----------------|
| ✓ Success | Verde | Producto agregado, mensaje enviado |
| ✕ Error | Rojo | Error de red, operación fallida |
| ⚠ Warning | Naranja | Stock máximo, campos incompletos |
| ℹ Info | Azul | Información general |

**Características:**
- Auto-cierre en 3-5 segundos
- Cierre manual con botón X
- Apilamiento múltiple
- Animación suave

### 💬 Checkout por WhatsApp

Al hacer clic en "Proceder al Pago":
1. Se genera un mensaje automático con:
   - Lista completa de productos
   - Cantidades
   - Precios unitarios
   - Subtotales
   - Total general
2. Se abre WhatsApp Web o app móvil
3. El mensaje está listo para enviar

**Ejemplo de mensaje:**
```
¡Hola! Me gustaría realizar el siguiente pedido:

1. Zapatillas Nike Air
   Cantidad: 2
   Precio unitario: S/ 299.90
   Subtotal: S/ 599.80

2. Polo Deportivo Adidas
   Cantidad: 1
   Precio unitario: S/ 89.90
   Subtotal: S/ 89.90

*Total: S/ 689.70*

Por favor, confirmen la disponibilidad y los detalles de envío.
```

---

## 🎨 EXPERIENCIA DE USUARIO

### Diseño Responsive
- ✅ Desktop (1200px+)
- ✅ Tablet (768px - 1199px)
- ✅ Mobile (< 768px)

### Indicadores Visuales
- **Stock bajo:** Texto rojo cuando stock < 5
- **Sin stock:** Botón deshabilitado + texto "Sin Stock"
- **Loading:** Spinner durante cargas
- **Estados vacíos:** Mensajes claros cuando no hay datos

### Navegación
- **Navbar fija:** Siempre visible al hacer scroll
- **Contador carrito:** Muestra cantidad de items
- **Breadcrumbs:** Ubicación clara en el sitio
- **Footer:** Enlaces rápidos e información

---

## ⚙️ CONFIGURACIÓN

### 1️⃣ Número de WhatsApp

**Archivo:** `frontend/projects/ecommerce/src/app/pages/cart/cart.component.ts`

**Línea 63:**
```typescript
const phone = '51999999999'; // Cambiar por número real
```

**Formato del número:**
- Código de país: 51 (Perú)
- Sin espacios ni guiones
- Ejemplo: 51987654321

### 2️⃣ Base de Datos

Verificar que MySQL esté corriendo con la base de datos `noblestepdb`:

```powershell
# Verificar servicio MySQL
Get-Service -Name MySQL* | Format-Table -AutoSize

# Conectar a MySQL
mysql -u root -p

# Usar base de datos
USE noblestepdb;

# Ver productos disponibles
SELECT Id, Name, Price, Stock FROM products WHERE Stock > 0;
```

### 3️⃣ Información de Contacto

**Archivo:** `frontend/projects/ecommerce/src/app/components/footer/footer.component.ts`

Actualizar en líneas 28-30:
```typescript
<p>📧 info@noblestep.com</p>        // Email real
<p>📞 +51 999 999 999</p>           // Teléfono real
<p>📍 Lima, Perú</p>                // Dirección real
```

---

## 🔍 SOLUCIÓN DE PROBLEMAS

### Backend no inicia
```powershell
# Verificar puerto ocupado
Get-NetTCPConnection -LocalPort 5000

# Matar proceso si es necesario
Stop-Process -Id [PID] -Force

# Verificar .NET instalado
dotnet --version

# Debe ser 8.0 o superior
```

### E-commerce no compila
```powershell
# Limpiar cache de Angular
cd frontend
npm cache clean --force
rm -rf node_modules
rm -rf .angular/cache

# Reinstalar dependencias
npm install

# Intentar de nuevo
npm run start:ecommerce
```

### MySQL no conecta
```powershell
# Verificar conexión en appsettings.json
# backend/appsettings.json

"ConnectionStrings": {
  "DefaultConnection": "Server=localhost;Database=noblestepdb;User=root;Password=tu_password;"
}
```

### Productos no aparecen
```sql
-- Verificar productos con stock en MySQL
SELECT 
    p.Id, 
    p.Name, 
    p.Brand, 
    p.Price, 
    p.Stock,
    c.Name as CategoryName
FROM products p
LEFT JOIN categories c ON p.CategoryId = c.Id
WHERE p.Stock > 0;

-- Si no hay productos, agregar datos demo
INSERT INTO products (Brand, Name, Size, Price, Stock, CategoryId, CreatedAt, UpdatedAt)
VALUES 
('Nike', 'Zapatillas Air Max', 'Talla 42', 299.90, 15, 1, NOW(), NOW()),
('Adidas', 'Polo Deportivo', 'Talla M', 89.90, 25, 2, NOW(), NOW());
```

---

## 📱 PRUEBAS RECOMENDADAS

### Flujo Completo de Compra:
1. ✅ Abrir http://localhost:4201
2. ✅ Ver productos destacados en inicio
3. ✅ Navegar a "Catálogo"
4. ✅ Filtrar por categoría
5. ✅ Buscar producto específico
6. ✅ Ver detalle de producto
7. ✅ Agregar al carrito (verificar notificación)
8. ✅ Modificar cantidad en carrito
9. ✅ Proceder al pago
10. ✅ Verificar mensaje de WhatsApp generado

### Validaciones:
- ✅ Intentar agregar más productos del stock disponible
- ✅ Enviar formulario de contacto vacío
- ✅ Enviar email inválido en contacto
- ✅ Intentar acceder a producto sin stock

### Responsive:
- ✅ Abrir en pantalla completa
- ✅ Reducir ancho del navegador (F12 > Device Toolbar)
- ✅ Probar en móvil real
- ✅ Verificar que todo sea legible y usable

---

## 📊 MONITOREO

### Logs del Backend
```powershell
# En la terminal donde corre el backend verás:
[INFO] Consulta de contacto recibida - Nombre: Juan, Email: juan@email.com
[INFO] Productos obtenidos: 15 items
[ERROR] Error obteniendo producto 999: Producto no encontrado
```

### Consola del Navegador
```javascript
// Abrir con F12 > Console
// Verás logs como:
"Error loading products: 404"
"Product added to cart: {id: 1, name: 'Nike Air'}"
```

### Herramientas de Desarrollo
- **Network Tab:** Ver peticiones HTTP
- **Application Tab:** Ver localStorage (carrito)
- **Console Tab:** Ver errores JavaScript

---

## 🎯 PRÓXIMOS PASOS

1. **Cambiar número de WhatsApp** en `cart.component.ts`
2. **Actualizar información de contacto** en `footer.component.ts`
3. **Agregar productos reales** a la base de datos
4. **Probar flujo completo** de compra
5. **Compartir URL** con clientes/testers

---

## 📞 SOPORTE

Si encuentras problemas:

1. ✅ Revisar este documento
2. ✅ Verificar logs del backend
3. ✅ Abrir consola del navegador (F12)
4. ✅ Ver `CAMBIOS-ECOMMERCE-MEJORADO.md` para detalles técnicos
5. ✅ Verificar que MySQL esté corriendo
6. ✅ Confirmar que puertos 5000 y 4201 estén libres

---

## ✨ DISFRUTA TU NUEVA TIENDA ONLINE

El sistema está completamente funcional y listo para usar. 

**¡Mucho éxito con tus ventas!** 🎉

---

*Documento actualizado: 06/02/2026*
