# 🚀 Despliegue Completo NobleStep - Todo en la Nube

## 📋 Resumen del Despliegue

Vamos a desplegar:
- ✅ **Base de Datos**: MySQL en Railway (gratis)
- ✅ **Backend API**: .NET 8 en Render (gratis)
- ✅ **Ecommerce**: Angular en Vercel (gratis)
- ✅ **Admin**: Angular en Vercel (gratis)

**Tiempo estimado**: 30-45 minutos

---

## 🗄️ PASO 1: Configurar Base de Datos en Railway (10 minutos)

### 1.1 Crear Cuenta y Proyecto
1. Ve a [Railway.app](https://railway.app)
2. Click en **"Start a New Project"**
3. Selecciona **"Deploy MySQL"**
4. Espera a que se cree (2-3 minutos)

### 1.2 Obtener Credenciales
1. En Railway, click en tu servicio MySQL
2. Ve a la pestaña **"Variables"**
3. Copia estas variables:
   - `MYSQL_HOST`
   - `MYSQL_PORT`
   - `MYSQL_DATABASE`
   - `MYSQL_USER`
   - `MYSQL_PASSWORD`
   - `MYSQL_ROOT_PASSWORD`

### 1.3 Crear la Cadena de Conexión
Combina las variables así:
```
Server=MYSQL_HOST;Port=MYSQL_PORT;Database=MYSQL_DATABASE;User=MYSQL_USER;Password=MYSQL_PASSWORD;
```

**Ejemplo:**
```
Server=containers-us-west-123.railway.app;Port=6789;Database=railway;User=root;Password=abc123xyz;
```

### 1.4 Cargar la Base de Datos
1. En Railway, ve a la pestaña **"Data"**
2. Click en **"Query"**
3. Abre el archivo `database/BASE-DATOS-DEFINITIVA.sql`
4. Copia TODO el contenido del archivo
5. Pégalo en el query de Railway
6. Click en **"Execute"**
7. ✅ Deberías ver: "Query executed successfully"

**Alternativa usando MySQL Workbench:**
1. Descarga [MySQL Workbench](https://dev.mysql.com/downloads/workbench/)
2. Crea nueva conexión con los datos de Railway
3. Importa el archivo `BASE-DATOS-DEFINITIVA.sql`

---

## 🔧 PASO 2: Desplegar Backend en Render (10 minutos)

### 2.1 Crear Servicio en Render
1. Ve a [Render.com](https://render.com)
2. Click en **"New +"** → **"Web Service"**
3. Conecta tu repositorio de GitHub
4. Selecciona el repositorio de NobleStep

### 2.2 Configurar el Servicio
**Configuración básica:**
- **Name**: `noblestep-api`
- **Region**: Oregon (US West) - más cercano a Latam
- **Branch**: `main`
- **Runtime**: Docker
- **Plan**: Free

### 2.3 Configurar Variables de Entorno
En Render, ve a **"Environment"** y agrega estas variables:

```bash
# 1. Base de Datos (usa tu cadena de Railway)
ConnectionStrings__DefaultConnection
Server=TU_RAILWAY_HOST;Port=TU_RAILWAY_PORT;Database=railway;User=root;Password=TU_RAILWAY_PASSWORD;

# 2. JWT Settings (genera una clave segura)
JwtSettings__SecretKey
TuClaveSecretaSuperSeguraDeAlMenos32CaracteresParaProduccion2024

JwtSettings__Issuer
NobleStepAPI

JwtSettings__Audience
NobleStepClient

JwtSettings__ExpirationMinutes
1440

# 3. CORS (actualizaremos esto después)
App__FrontendUrl
https://noblestep-ecommerce.vercel.app

# 4. Entorno
ASPNETCORE_ENVIRONMENT
Production

# 5. Email (opcional - para recuperación de contraseñas)
Email__SmtpHost
smtp.gmail.com

Email__SmtpPort
587

Email__SmtpUsername
tu-email@gmail.com

Email__SmtpPassword
tu-app-password

Email__FromEmail
tu-email@gmail.com

Email__FromName
NobleStep Shop
```

### 2.4 Configurar Dockerfile
**IMPORTANTE**: Verifica que el `Dockerfile` en la raíz esté así:

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["backend/NobleStep.Api.csproj", "backend/"]
RUN dotnet restore "backend/NobleStep.Api.csproj"
COPY backend/ backend/
WORKDIR "/src/backend"
RUN dotnet build "NobleStep.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NobleStep.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NobleStep.Api.dll"]
```

### 2.5 Desplegar
1. Click en **"Create Web Service"**
2. Render comenzará a construir automáticamente
3. ⏱️ Espera 5-10 minutos
4. ✅ Cuando veas "Live", copia la URL: `https://noblestep-api.onrender.com`

### 2.6 Verificar el Backend
1. Abre en el navegador: `https://noblestep-api.onrender.com/api/health`
2. Deberías ver un mensaje de éxito o un JSON

---

## 🛍️ PASO 3: Desplegar Ecommerce en Vercel (5 minutos)

### 3.1 Actualizar URL del API
**Archivo**: `frontend/projects/ecommerce/src/environments/environment.prod.ts`

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://noblestep-api.onrender.com/api'  // ← Tu URL de Render
};
```

### 3.2 Commit y Push
```bash
git add .
git commit -m "feat: Update API URL for production"
git push origin main
```

### 3.3 Desplegar en Vercel
1. Ve a [Vercel.com](https://vercel.com)
2. Click en **"Add New..."** → **"Project"**
3. Importa tu repositorio de GitHub
4. **Framework Preset**: Other
5. **Root Directory**: Déjalo en `/` (raíz)
6. **Build Command**:
   ```
   cd frontend && npm install && npm run build:ecommerce
   ```
7. **Output Directory**:
   ```
   frontend/dist/ecommerce/browser
   ```
8. Click en **"Deploy"**
9. ⏱️ Espera 3-5 minutos
10. ✅ Copia la URL: `https://noblestep-ecommerce.vercel.app`

### 3.4 Configurar Dominio Personalizado (Opcional)
1. En Vercel, ve a **"Settings"** → **"Domains"**
2. Agrega tu dominio personalizado
3. Sigue las instrucciones de Vercel para configurar DNS

---

## 👨‍💼 PASO 4: Desplegar Admin en Vercel (5 minutos)

### 4.1 Actualizar URL del API
**Archivo**: `frontend/src/environments/environment.prod.ts`

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://noblestep-api.onrender.com/api'  // ← Tu URL de Render
};
```

### 4.2 Commit y Push
```bash
git add .
git commit -m "feat: Update Admin API URL for production"
git push origin main
```

### 4.3 Crear Nuevo Proyecto en Vercel
1. En Vercel, click en **"Add New..."** → **"Project"**
2. Importa el **mismo repositorio** de GitHub
3. **Framework Preset**: Other
4. **Project Name**: `noblestep-admin`
5. **Root Directory**: `/`
6. **Build Command**:
   ```
   cd frontend && npm install && npm run build
   ```
7. **Output Directory**:
   ```
   frontend/dist/browser
   ```
8. Click en **"Deploy"**
9. ⏱️ Espera 3-5 minutos
10. ✅ Copia la URL: `https://noblestep-admin.vercel.app`

---

## 🔄 PASO 5: Actualizar CORS en el Backend (5 minutos)

### 5.1 Actualizar Variable de Entorno en Render
1. Ve a Render.com → Tu servicio `noblestep-api`
2. Click en **"Environment"**
3. Encuentra `App__FrontendUrl`
4. Actualiza con tus URLs de Vercel (separadas por coma):
   ```
   https://noblestep-ecommerce.vercel.app,https://noblestep-admin.vercel.app
   ```
5. Click en **"Save Changes"**
6. Render hará redeploy automáticamente (2-3 minutos)

### 5.2 Verificar CORS
Abre tu ecommerce y verifica que se conecte correctamente al API.

---

## ✅ PASO 6: Verificación Final (5 minutos)

### 6.1 Verificar Backend
- [ ] Accede a: `https://noblestep-api.onrender.com/api/health`
- [ ] Respuesta exitosa

### 6.2 Verificar Ecommerce
- [ ] Accede a: `https://noblestep-ecommerce.vercel.app`
- [ ] Página de inicio carga correctamente
- [ ] Los productos se muestran
- [ ] El carrito funciona
- [ ] Puedes crear una cuenta
- [ ] Puedes iniciar sesión

### 6.3 Verificar Admin
- [ ] Accede a: `https://noblestep-admin.vercel.app`
- [ ] Página de login carga
- [ ] Puedes iniciar sesión con:
  - Usuario: `admin` (o el que configuraste)
  - Contraseña: (la de tu BD)
- [ ] Dashboard carga correctamente
- [ ] Puedes ver productos, categorías, etc.

---

## 📝 URLs Finales

Guarda estas URLs:

| Componente | URL |
|------------|-----|
| **API Backend** | `https://noblestep-api.onrender.com` |
| **Ecommerce** | `https://noblestep-ecommerce.vercel.app` |
| **Admin** | `https://noblestep-admin.vercel.app` |
| **Base de Datos** | (Panel de Railway) |

---

## 🔧 Comandos Útiles

### Ver logs del Backend en Render
```bash
# En Render Dashboard → Logs
# O usando Render CLI:
render logs -s noblestep-api
```

### Redesplegar el Backend
```bash
# En Render Dashboard → Manual Deploy
# O usando Git:
git commit --allow-empty -m "redeploy"
git push origin main
```

### Redesplegar Frontend
```bash
# Los cambios se despliegan automáticamente con cada push
git add .
git commit -m "update: Changes description"
git push origin main
```

---

## 🐛 Solución de Problemas

### ❌ Backend no inicia
1. Verifica logs en Render
2. Revisa que la cadena de conexión de Railway sea correcta
3. Verifica que todas las variables de entorno estén configuradas

### ❌ Frontend no carga productos
1. Abre Developer Tools (F12) → Console
2. Verifica errores de CORS
3. Revisa que `environment.prod.ts` tenga la URL correcta del API
4. Verifica que `App__FrontendUrl` en Render incluya la URL del frontend

### ❌ Error 502 en Render
- Render en plan gratis "duerme" después de 15 minutos de inactividad
- La primera petición tardará 30-60 segundos en despertar
- Esto es normal en plan Free

### ❌ Base de datos no conecta
1. Verifica credenciales en Railway
2. Asegúrate de que Railway permita conexiones externas
3. Revisa que la cadena de conexión esté correcta

---

## 🎉 ¡Listo!

Tu sistema NobleStep está completamente desplegado en la nube:
- ✅ Base de datos MySQL en Railway
- ✅ Backend API en Render
- ✅ Ecommerce en Vercel
- ✅ Admin en Vercel

**Costo mensual**: $0 USD (todos los planes gratuitos)

---

## 📞 Próximos Pasos

1. **Configurar dominio personalizado** en Vercel
2. **Configurar emails** para recuperación de contraseñas
3. **Agregar productos** desde el panel admin
4. **Probar el flujo completo** de compra
5. **Configurar métodos de pago** (Yape, PayPal, etc.)

---

## 🔐 Seguridad

**IMPORTANTE**:
- ✅ Cambia el `JwtSettings__SecretKey` por una clave única
- ✅ Usa contraseñas fuertes en Railway
- ✅ No compartas tus variables de entorno
- ✅ Habilita 2FA en Render, Vercel y Railway
- ✅ Revisa los logs regularmente

