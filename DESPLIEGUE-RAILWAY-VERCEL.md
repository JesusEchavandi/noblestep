# 🚀 Despliegue NobleStep - Railway + Vercel

## 📋 Resumen Simple

```
Railway  = Base de Datos MySQL + Backend .NET API
Vercel   = Ecommerce Frontend + Admin Frontend
```

**Tiempo total: 30 minutos**  
**Costo: $0 USD/mes**

---

## 🎯 Arquitectura

```
┌─────────────────┐      ┌─────────────────┐
│   ECOMMERCE     │      │     ADMIN       │
│   (Vercel)      │      │   (Vercel)      │
└────────┬────────┘      └────────┬────────┘
         │                        │
         └───────────┬────────────┘
                     │
              ┌──────▼──────┐
              │ BACKEND API │
              │  (Railway)  │
              │  .NET 8     │
              └──────┬──────┘
                     │
              ┌──────▼──────┐
              │   MYSQL DB  │
              │  (Railway)  │
              └─────────────┘
```

---

## 🗄️ PASO 1: Railway - Base de Datos (5 minutos)

### 1.1 Crear Proyecto en Railway
1. Ve a **https://railway.app**
2. Click en **"Login"** → Usa GitHub
3. Click en **"New Project"**
4. Selecciona **"Provision MySQL"**
5. Espera 1-2 minutos

### 1.2 Obtener Credenciales de MySQL
1. Click en el servicio **MySQL** que se creó
2. Ve a la pestaña **"Variables"**
3. Verás estas variables automáticas:
   - `MYSQL_HOST`
   - `MYSQL_PORT`
   - `MYSQL_DATABASE` (usualmente "railway")
   - `MYSQL_USER` (usualmente "root")
   - `MYSQL_PASSWORD`
   - `MYSQL_URL` (cadena completa)

### 1.3 Crear Cadena de Conexión
Copia esta estructura y remplaza con tus valores:
```
Server=TU_MYSQL_HOST;Port=TU_MYSQL_PORT;Database=railway;User=root;Password=TU_MYSQL_PASSWORD;
```

**Ejemplo:**
```
Server=containers-us-west-45.railway.app;Port=6543;Database=railway;User=root;Password=AbC123XyZ;
```

💾 **Guarda esta cadena**, la necesitarás en el Paso 2.

### 1.4 Cargar la Base de Datos

**Opción A: Desde Railway (Más Fácil)**
1. En Railway, ve a tu servicio MySQL
2. Click en **"Data"** en el menú superior
3. Click en **"Query"**
4. Abre el archivo `database/BASE-DATOS-DEFINITIVA.sql` de tu proyecto
5. Copia **TODO** el contenido
6. Pégalo en el editor de Railway
7. Click en **"Run Query"** o presiona Ctrl+Enter
8. Deberías ver: "Query executed successfully"

**Opción B: Usando MySQL Workbench**
1. Descarga [MySQL Workbench](https://dev.mysql.com/downloads/workbench/)
2. Crea nueva conexión:
   - Hostname: `TU_MYSQL_HOST`
   - Port: `TU_MYSQL_PORT`
   - Username: `root`
   - Password: `TU_MYSQL_PASSWORD`
3. Importa el archivo `database/BASE-DATOS-DEFINITIVA.sql`

### 1.5 Verificar Datos
En Railway Query, ejecuta:
```sql
SELECT * FROM Products LIMIT 5;
```
Deberías ver productos. ✅

---

## 🔧 PASO 2: Railway - Backend API (10 minutos)

### 2.1 Agregar Backend al Mismo Proyecto
1. En Railway, dentro del **mismo proyecto** donde está MySQL
2. Click en **"+ New"** (botón superior derecho)
3. Selecciona **"GitHub Repo"**
4. Autoriza Railway a acceder a GitHub (si es primera vez)
5. Selecciona tu repositorio **NobleStep**
6. Railway detectará automáticamente que es .NET

### 2.2 Configurar Variables de Entorno

En el servicio del Backend:
1. Ve a la pestaña **"Variables"**
2. Click en **"+ New Variable"**
3. Agrega estas variables **UNA POR UNA**:

```bash
# 1. Conexión a Base de Datos (usa la cadena del Paso 1.3)
ConnectionStrings__DefaultConnection
Server=TU_MYSQL_HOST;Port=TU_MYSQL_PORT;Database=railway;User=root;Password=TU_MYSQL_PASSWORD;

# 2. JWT Settings (genera una clave segura única)
JwtSettings__SecretKey
MiClaveSecretaSuperSegura2024NobleStepProduction123456789

JwtSettings__Issuer
NobleStepAPI

JwtSettings__Audience
NobleStepClient

JwtSettings__ExpirationMinutes
1440

# 3. CORS (actualizaremos después)
App__FrontendUrl
http://localhost:4200,http://localhost:4201

# 4. Entorno
ASPNETCORE_ENVIRONMENT
Production
```

⚠️ **IMPORTANTE**: Para `JwtSettings__SecretKey`, genera tu propia clave única de al menos 32 caracteres.

### 2.3 Configurar Settings de Railway

1. Ve a la pestaña **"Settings"**
2. En **"Service Name"**, nómbralo: `noblestep-api`
3. En **"Root Directory"**, déjalo en `/` (raíz)
4. En **"Build Command"** (opcional): 
   ```
   dotnet publish backend/NobleStep.Api.csproj -c Release -o out
   ```
5. En **"Start Command"**:
   ```
   dotnet out/NobleStep.Api.dll
   ```

### 2.4 Generar Dominio Público

1. Ve a la pestaña **"Settings"**
2. Baja hasta **"Networking"**
3. Click en **"Generate Domain"**
4. Railway generará una URL como: `noblestep-api-production-XXXX.up.railway.app`
5. 💾 **Copia esta URL**, la necesitarás para los frontends

### 2.5 Desplegar

1. Railway desplegará automáticamente
2. Ve a la pestaña **"Deployments"**
3. Verás el progreso del build (5-8 minutos)
4. Cuando veas "Success" ✅, el backend está listo

### 2.6 Verificar Backend

Abre en el navegador:
```
https://TU-URL-RAILWAY.up.railway.app/api/health
```

Deberías ver un JSON con status "healthy". ✅

También puedes verificar Swagger:
```
https://TU-URL-RAILWAY.up.railway.app/swagger
```

---

## 🛍️ PASO 3: Vercel - Ecommerce (7 minutos)

### 3.1 Actualizar URL del API

Edita el archivo:
```
frontend/projects/ecommerce/src/environments/environment.prod.ts
```

Cambia a:
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://TU-URL-RAILWAY.up.railway.app/api'
};
```

### 3.2 Commit y Push
```bash
git add .
git commit -m "feat: Configure ecommerce for Railway backend"
git push origin main
```

### 3.3 Desplegar en Vercel

1. Ve a **https://vercel.com**
2. Login con GitHub
3. Click en **"Add New..."** → **"Project"**
4. Importa tu repositorio de GitHub
5. Configura:

**Framework Preset**: Other

**Project Name**: `noblestep-ecommerce`

**Root Directory**: `./` (déjalo en raíz)

**Build Command**:
```bash
cd frontend && npm install && npm run build:ecommerce
```

**Output Directory**:
```
frontend/dist/ecommerce/browser
```

**Install Command**: (déjalo por defecto)
```bash
npm install
```

6. Click en **"Deploy"**
7. Espera 3-5 minutos
8. Cuando veas "Congratulations!", copia la URL
9. 💾 URL ejemplo: `https://noblestep-ecommerce.vercel.app`

### 3.4 Verificar Ecommerce

1. Abre la URL de Vercel
2. La página de inicio debe cargar
3. Los productos deben mostrarse
4. Verifica que no hay errores en la consola (F12)

---

## 👨‍💼 PASO 4: Vercel - Admin (7 minutos)

### 4.1 Actualizar URL del API

Edita el archivo:
```
frontend/src/environments/environment.prod.ts
```

Cambia a:
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://TU-URL-RAILWAY.up.railway.app/api'
};
```

### 4.2 Commit y Push
```bash
git add .
git commit -m "feat: Configure admin for Railway backend"
git push origin main
```

### 4.3 Desplegar en Vercel

1. En Vercel, click en **"Add New..."** → **"Project"**
2. Importa el **MISMO repositorio**
3. Configura:

**Framework Preset**: Other

**Project Name**: `noblestep-admin`

**Root Directory**: `./`

**Build Command**:
```bash
cd frontend && npm install && npm run build
```

**Output Directory**:
```
frontend/dist/browser
```

4. Click en **"Deploy"**
5. Espera 3-5 minutos
6. Copia la URL
7. 💾 URL ejemplo: `https://noblestep-admin.vercel.app`

### 4.4 Verificar Admin

1. Abre la URL de Vercel
2. Deberías ver el login
3. Inicia sesión con el usuario admin de tu BD

---

## 🔄 PASO 5: Actualizar CORS en Railway (2 minutos)

### 5.1 Editar Variables en Railway

1. Ve a Railway → Tu proyecto → Servicio **noblestep-api**
2. Click en **"Variables"**
3. Busca `App__FrontendUrl`
4. Edita y cambia a:
```
https://noblestep-ecommerce.vercel.app,https://noblestep-admin.vercel.app
```
(Usa TUS URLs de Vercel, separadas por coma, sin espacios)

5. Railway redesplegará automáticamente (2-3 minutos)

### 5.2 Verificar

1. Abre el ecommerce
2. Verifica que los productos cargan
3. Abre el admin
4. Verifica que el dashboard funciona
5. No debería haber errores de CORS en la consola (F12)

---

## ✅ VERIFICACIÓN FINAL

### Backend (Railway)
- [ ] `https://tu-api.up.railway.app/api/health` → Responde OK
- [ ] `https://tu-api.up.railway.app/swagger` → Abre correctamente
- [ ] Logs en Railway sin errores críticos

### Base de Datos (Railway)
- [ ] Productos en la base de datos
- [ ] Usuarios creados
- [ ] Categorías cargadas

### Ecommerce (Vercel)
- [ ] Página carga correctamente
- [ ] Productos se muestran
- [ ] Carrito funciona
- [ ] Registro de usuario funciona
- [ ] Login funciona

### Admin (Vercel)
- [ ] Login funciona
- [ ] Dashboard carga con estadísticas
- [ ] Productos se listan
- [ ] Puedes crear/editar productos
- [ ] Reportes funcionan

---

## 📝 URLs Finales

Guarda estas URLs:

```
Backend API:  https://________________________.up.railway.app
Ecommerce:    https://________________________.vercel.app
Admin:        https://________________________.vercel.app
Railway DB:   Panel en https://railway.app
```

---

## 💰 Costos

| Servicio | Plan | Costo |
|----------|------|-------|
| Railway (DB + Backend) | Hobby (Gratis) | $0/mes* |
| Vercel (Ecommerce) | Hobby (Gratis) | $0/mes |
| Vercel (Admin) | Hobby (Gratis) | $0/mes |
| **TOTAL** | | **$0/mes** |

*Railway ofrece $5 de crédito gratis al mes, suficiente para este proyecto.

---

## 🔧 Solución de Problemas

### ❌ Backend no inicia en Railway
1. Ve a **"Deployments"** → Click en el deployment fallido
2. Revisa los **logs** para ver el error
3. Verifica que todas las variables de entorno estén configuradas
4. Verifica que la cadena de conexión sea correcta

### ❌ Error de CORS
1. Verifica `App__FrontendUrl` en Railway
2. Debe tener las URLs exactas de Vercel (sin barra final)
3. Las URLs deben estar separadas por coma sin espacios

### ❌ Frontend no carga datos
1. Abre DevTools (F12) → Console
2. Busca errores de red
3. Verifica que `environment.prod.ts` tenga la URL correcta de Railway
4. Verifica que el backend esté funcionando

### ❌ Railway "out of memory"
1. En Railway → Settings → Resources
2. Incrementa la memoria si es necesario (aún gratis hasta cierto límite)

---

## 🎉 ¡Felicitaciones!

Tu sistema NobleStep está desplegado en:
- ✅ Railway (Backend + Base de Datos)
- ✅ Vercel (Ecommerce + Admin)

**Todo por $0 USD/mes**

---

## 📞 Próximos Pasos Opcionales

1. **Dominio personalizado** en Vercel
2. **Configurar emails** para recuperación de contraseñas
3. **Monitoreo** usando Railway Analytics
4. **Backups** automáticos en Railway
5. **CDN** para imágenes

---

## 🔒 Seguridad

- ✅ Cambia `JwtSettings__SecretKey` por una clave única
- ✅ Usa contraseña fuerte en Railway
- ✅ Habilita 2FA en Railway y Vercel
- ✅ No compartas variables de entorno
- ✅ Revisa logs regularmente

---

**Fecha de creación:** 2026-02-09  
**Versión:** 1.0.0  
**Stack:** Railway + Vercel
