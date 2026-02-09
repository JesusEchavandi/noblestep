# ✅ Checklist de Despliegue - NobleStep

## 📋 Antes de Empezar

### Cuentas Necesarias
- [ ] Cuenta de GitHub (con repositorio del proyecto)
- [ ] Cuenta de Railway.app (para base de datos MySQL)
- [ ] Cuenta de Render.com (para backend API)
- [ ] Cuenta de Vercel.com (para frontends)

### Verificación Local
- [ ] Ejecutar: `.\VERIFICAR-ANTES-DESPLEGAR-CLOUD.ps1`
- [ ] Todos los errores corregidos
- [ ] Código subido a GitHub

---

## 🗄️ FASE 1: Base de Datos (Railway)

### Crear Proyecto
- [ ] Ir a [Railway.app](https://railway.app)
- [ ] Crear nuevo proyecto
- [ ] Seleccionar "Deploy MySQL"
- [ ] Esperar a que se cree (2-3 min)

### Obtener Credenciales
- [ ] Ir a pestaña "Variables"
- [ ] Copiar: `MYSQL_HOST`
- [ ] Copiar: `MYSQL_PORT`
- [ ] Copiar: `MYSQL_DATABASE`
- [ ] Copiar: `MYSQL_USER`
- [ ] Copiar: `MYSQL_PASSWORD`

### Crear Cadena de Conexión
```
Server=HOST;Port=PUERTO;Database=NOMBRE_BD;User=USUARIO;Password=CONTRASEÑA;
```
- [ ] Cadena de conexión creada
- [ ] Guardada en un lugar seguro

### Cargar Base de Datos
- [ ] Ir a pestaña "Data" → "Query"
- [ ] Abrir `database/BASE-DATOS-DEFINITIVA.sql`
- [ ] Copiar TODO el contenido
- [ ] Pegar y ejecutar en Railway
- [ ] Ver mensaje: "Query executed successfully"

### Verificar Datos
- [ ] Ejecutar: `SELECT * FROM Products LIMIT 5;`
- [ ] Verificar que hay datos
- [ ] Ejecutar: `SELECT * FROM Users;`
- [ ] Verificar usuario admin existe

---

## 🔧 FASE 2: Backend (Render)

### Crear Servicio
- [ ] Ir a [Render.com](https://render.com)
- [ ] Click "New +" → "Web Service"
- [ ] Conectar repositorio de GitHub
- [ ] Seleccionar repositorio NobleStep

### Configuración Básica
- [ ] Name: `noblestep-api`
- [ ] Region: Oregon (US West)
- [ ] Branch: `main`
- [ ] Runtime: Docker
- [ ] Plan: Free

### Variables de Entorno (IMPORTANTE)

Ir a "Environment" y agregar UNA POR UNA:

#### Conexión a Base de Datos
```
Key: ConnectionStrings__DefaultConnection
Value: [TU CADENA DE RAILWAY AQUÍ]
```
- [ ] Variable agregada

#### JWT Settings
```
Key: JwtSettings__SecretKey
Value: [GENERA UNA CLAVE SEGURA DE 32+ CARACTERES]
```
- [ ] Variable agregada

```
Key: JwtSettings__Issuer
Value: NobleStepAPI
```
- [ ] Variable agregada

```
Key: JwtSettings__Audience
Value: NobleStepClient
```
- [ ] Variable agregada

```
Key: JwtSettings__ExpirationMinutes
Value: 1440
```
- [ ] Variable agregada

#### CORS (Temporal)
```
Key: App__FrontendUrl
Value: http://localhost:4200,http://localhost:4201
```
- [ ] Variable agregada (actualizaremos después)

#### Entorno
```
Key: ASPNETCORE_ENVIRONMENT
Value: Production
```
- [ ] Variable agregada

### Desplegar
- [ ] Click "Create Web Service"
- [ ] Esperar build (5-10 minutos)
- [ ] Estado: "Live" ✅
- [ ] Copiar URL: `https://noblestep-api-XXXX.onrender.com`

### Verificar Backend
- [ ] Abrir: `https://TU-URL.onrender.com/api/health`
- [ ] Ver respuesta JSON exitosa
- [ ] Abrir: `https://TU-URL.onrender.com/swagger`
- [ ] Swagger UI carga correctamente

---

## 🛍️ FASE 3: Ecommerce Frontend (Vercel)

### Actualizar Configuración
Archivo: `frontend/projects/ecommerce/src/environments/environment.prod.ts`
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://TU-URL-DE-RENDER.onrender.com/api'
};
```
- [ ] Archivo actualizado
- [ ] Commit: `git commit -m "feat: Update ecommerce API URL"`
- [ ] Push: `git push origin main`

### Crear Proyecto en Vercel
- [ ] Ir a [Vercel.com](https://vercel.com)
- [ ] Click "Add New..." → "Project"
- [ ] Importar repositorio de GitHub
- [ ] Framework: Other
- [ ] Project Name: `noblestep-ecommerce`

### Configuración de Build
```
Root Directory: ./
Build Command: cd frontend && npm install && npm run build:ecommerce
Output Directory: frontend/dist/ecommerce/browser
```
- [ ] Configuración ingresada correctamente

### Desplegar
- [ ] Click "Deploy"
- [ ] Esperar build (3-5 minutos)
- [ ] Ver: "Congratulations!" 🎉
- [ ] Copiar URL: `https://noblestep-ecommerce.vercel.app`

### Verificar Ecommerce
- [ ] Abrir URL del ecommerce
- [ ] Página de inicio carga
- [ ] Productos se muestran
- [ ] Carrito funciona
- [ ] Puedes registrarte
- [ ] Puedes iniciar sesión

---

## 👨‍💼 FASE 4: Admin Frontend (Vercel)

### Actualizar Configuración
Archivo: `frontend/src/environments/environment.prod.ts`
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://TU-URL-DE-RENDER.onrender.com/api'
};
```
- [ ] Archivo actualizado
- [ ] Commit: `git commit -m "feat: Update admin API URL"`
- [ ] Push: `git push origin main`

### Crear Proyecto en Vercel
- [ ] En Vercel, click "Add New..." → "Project"
- [ ] Importar MISMO repositorio
- [ ] Framework: Other
- [ ] Project Name: `noblestep-admin`

### Configuración de Build
```
Root Directory: ./
Build Command: cd frontend && npm install && npm run build
Output Directory: frontend/dist/browser
```
- [ ] Configuración ingresada correctamente

### Desplegar
- [ ] Click "Deploy"
- [ ] Esperar build (3-5 minutos)
- [ ] Ver: "Congratulations!" 🎉
- [ ] Copiar URL: `https://noblestep-admin.vercel.app`

### Verificar Admin
- [ ] Abrir URL del admin
- [ ] Página de login carga
- [ ] Iniciar sesión con usuario admin
- [ ] Dashboard carga correctamente
- [ ] Puedes ver productos
- [ ] Puedes crear/editar productos

---

## 🔄 FASE 5: Actualizar CORS

### En Render
- [ ] Ir a tu servicio `noblestep-api`
- [ ] Click "Environment"
- [ ] Editar `App__FrontendUrl`
- [ ] Nuevo valor:
```
https://noblestep-ecommerce.vercel.app,https://noblestep-admin.vercel.app
```
- [ ] Click "Save Changes"
- [ ] Esperar redeploy (2-3 minutos)

### Verificar CORS
- [ ] Abrir ecommerce
- [ ] Verificar que productos cargan
- [ ] Abrir admin
- [ ] Verificar que dashboard carga
- [ ] No hay errores de CORS en consola (F12)

---

## ✅ VERIFICACIÓN FINAL

### Backend
- [ ] `https://TU-API.onrender.com/api/health` → OK
- [ ] `https://TU-API.onrender.com/swagger` → Abre correctamente
- [ ] No hay errores en logs de Render

### Ecommerce
- [ ] Página de inicio carga
- [ ] Productos se muestran
- [ ] Imágenes cargan
- [ ] Puedes agregar al carrito
- [ ] Puedes registrarte
- [ ] Puedes iniciar sesión
- [ ] Puedes ver tu perfil
- [ ] Checkout funciona

### Admin
- [ ] Login funciona
- [ ] Dashboard muestra estadísticas
- [ ] Lista de productos funciona
- [ ] Puedes crear producto
- [ ] Puedes editar producto
- [ ] Puedes eliminar producto
- [ ] Reportes funcionan
- [ ] Ventas funcionan
- [ ] Compras funcionan

---

## 📝 URLs Finales

Guarda estas URLs en un lugar seguro:

```
API Backend:     https://_____________________.onrender.com
Ecommerce:       https://_____________________.vercel.app
Admin:           https://_____________________.vercel.app
Railway DB:      https://railway.app (Panel de control)
```

---

## 🎉 ¡FELICITACIONES!

Tu sistema NobleStep está completamente desplegado en la nube:
- ✅ Base de datos en Railway
- ✅ Backend en Render
- ✅ Ecommerce en Vercel
- ✅ Admin en Vercel

**Costo mensual: $0 USD** (todos en planes gratuitos)

---

## 📞 Próximos Pasos Opcionales

- [ ] Configurar dominio personalizado
- [ ] Configurar email para recuperación de contraseñas
- [ ] Agregar productos reales
- [ ] Configurar métodos de pago
- [ ] Configurar SSL personalizado
- [ ] Configurar CDN para imágenes
- [ ] Habilitar backups automáticos en Railway
- [ ] Configurar monitoreo y alertas

---

## 🔒 Seguridad

- [ ] Cambiar JwtSettings__SecretKey por una clave única
- [ ] Usar contraseña fuerte en Railway
- [ ] Habilitar 2FA en todas las plataformas
- [ ] No compartir variables de entorno
- [ ] Revisar logs regularmente
- [ ] Actualizar dependencias mensualmente

---

**Fecha de despliegue:** ___________________

**Versión:** 1.0.0

**Desplegado por:** ___________________
