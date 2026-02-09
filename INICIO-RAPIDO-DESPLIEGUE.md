# 🚀 Inicio Rápido - Despliegue NobleStep

## ⚡ Guía Express (Para los que tienen prisa)

### 📦 Lo Que Vas a Desplegar

```
NobleStep = Ecommerce + Admin + Backend API + Base de Datos
            (Vercel)   (Vercel)  (Render)      (Railway)
```

### ⏱️ Tiempo Total: 45 minutos

---

## 🎯 Paso a Paso Ultra-Rápido

### 1️⃣ PUSH TUS CAMBIOS (1 min)
```bash
git push origin main
```

### 2️⃣ RAILWAY - Base de Datos (10 min)
1. Ir a → https://railway.app
2. "Start a New Project" → "Deploy MySQL"
3. Esperar 2 minutos
4. Copiar variables: `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_PASSWORD`
5. Ir a "Data" → "Query"
6. Pegar contenido de `database/BASE-DATOS-DEFINITIVA.sql`
7. Ejecutar
8. ✅ Crear cadena de conexión:
   ```
   Server=HOST;Port=PUERTO;Database=railway;User=root;Password=PASSWORD;
   ```

### 3️⃣ RENDER - Backend API (10 min)
1. Ir a → https://render.com
2. "New +" → "Web Service"
3. Conectar GitHub → Seleccionar tu repo
4. Configurar:
   - Name: `noblestep-api`
   - Runtime: **Docker**
   - Plan: **Free**
5. En "Environment", agregar:
   ```
   ConnectionStrings__DefaultConnection = [CADENA DE RAILWAY]
   JwtSettings__SecretKey = MinimoDe32CaracteresSecretosParaProduccion123
   JwtSettings__Issuer = NobleStepAPI
   JwtSettings__Audience = NobleStepClient
   JwtSettings__ExpirationMinutes = 1440
   App__FrontendUrl = http://localhost:4200
   ASPNETCORE_ENVIRONMENT = Production
   ```
6. "Create Web Service"
7. Esperar 5-10 minutos
8. ✅ Copiar URL: `https://noblestep-api-XXXX.onrender.com`

### 4️⃣ VERCEL - Ecommerce (10 min)
1. Editar `frontend/projects/ecommerce/src/environments/environment.prod.ts`:
   ```typescript
   export const environment = {
     production: true,
     apiUrl: 'https://TU-URL-DE-RENDER.onrender.com/api'
   };
   ```
2. Commit y push:
   ```bash
   git add .
   git commit -m "feat: Update ecommerce API URL"
   git push origin main
   ```
3. Ir a → https://vercel.com
4. "Add New..." → "Project"
5. Importar tu repo
6. Configurar:
   - Project Name: `noblestep-ecommerce`
   - Build Command: `cd frontend && npm install && npm run build:ecommerce`
   - Output Directory: `frontend/dist/ecommerce/browser`
7. "Deploy"
8. Esperar 3-5 minutos
9. ✅ Copiar URL: `https://noblestep-ecommerce.vercel.app`

### 5️⃣ VERCEL - Admin (10 min)
1. Editar `frontend/src/environments/environment.prod.ts`:
   ```typescript
   export const environment = {
     production: true,
     apiUrl: 'https://TU-URL-DE-RENDER.onrender.com/api'
   };
   ```
2. Commit y push:
   ```bash
   git add .
   git commit -m "feat: Update admin API URL"
   git push origin main
   ```
3. En Vercel, "Add New..." → "Project"
4. Importar el MISMO repo
5. Configurar:
   - Project Name: `noblestep-admin`
   - Build Command: `cd frontend && npm install && npm run build`
   - Output Directory: `frontend/dist/browser`
6. "Deploy"
7. Esperar 3-5 minutos
8. ✅ Copiar URL: `https://noblestep-admin.vercel.app`

### 6️⃣ ACTUALIZAR CORS (5 min)
1. Ir a Render → Tu servicio `noblestep-api`
2. "Environment"
3. Editar `App__FrontendUrl`:
   ```
   https://noblestep-ecommerce.vercel.app,https://noblestep-admin.vercel.app
   ```
4. "Save Changes"
5. Esperar redeploy (2-3 min)

### 7️⃣ VERIFICAR TODO (5 min)
- ✅ Backend: `https://tu-api.onrender.com/api/health`
- ✅ Ecommerce: `https://tu-ecommerce.vercel.app`
- ✅ Admin: `https://tu-admin.vercel.app`

---

## 🎉 ¡LISTO!

**URLs Finales:**
```
API:       https://________________.onrender.com
Ecommerce: https://________________.vercel.app  
Admin:     https://________________.vercel.app
```

**Costo:** $0 USD/mes

---

## 📚 Documentación Completa

Si necesitas más detalles, consulta:

| Archivo | Para Qué |
|---------|----------|
| `DESPLIEGUE-COMPLETO-CLOUD.md` | Guía detallada paso a paso |
| `CHECKLIST-DESPLIEGUE.md` | Lista verificable de tareas |
| `RESUMEN-PREPARACION-DESPLIEGUE.md` | Overview completo |
| `VERIFICAR-ANTES-DESPLEGAR-CLOUD.ps1` | Script de verificación |

---

## ⚠️ Problemas Comunes

### Backend tarda en responder
- Normal en plan Free de Render
- Primera petición: 30-60 segundos (está "despertando")

### Error de CORS
- Verificar `App__FrontendUrl` en Render
- Debe incluir URLs de Vercel (sin barra al final)

### Productos no cargan
- Abrir DevTools (F12) → Console
- Verificar URL del API en `environment.prod.ts`

---

## 🆘 ¿Atascado?

1. Ejecuta: `.\VERIFICAR-ANTES-DESPLEGAR-CLOUD.ps1`
2. Revisa logs en cada plataforma
3. Consulta `DESPLIEGUE-COMPLETO-CLOUD.md`

---

**¡A desplegar! 🚀**
