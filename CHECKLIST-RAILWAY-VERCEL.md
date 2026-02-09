# ✅ Checklist Rápido - Railway + Vercel

## 📋 Preparación (5 minutos)

- [ ] Cuenta en Railway.app creada
- [ ] Cuenta en Vercel.com creada
- [ ] Código en GitHub
- [ ] Archivo `database/BASE-DATOS-DEFINITIVA.sql` listo

---

## 🗄️ RAILWAY - Base de Datos (5 min)

- [ ] Ir a https://railway.app
- [ ] Crear nuevo proyecto
- [ ] "Provision MySQL"
- [ ] Copiar credenciales (Variables tab)
- [ ] Crear cadena de conexión:
  ```
  Server=HOST;Port=PUERTO;Database=railway;User=root;Password=PASSWORD;
  ```
- [ ] Ir a "Data" → "Query"
- [ ] Pegar contenido de `BASE-DATOS-DEFINITIVA.sql`
- [ ] Ejecutar query
- [ ] Verificar: `SELECT * FROM Products LIMIT 5;`

**✅ Cadena guardada:** `________________________________`

---

## 🔧 RAILWAY - Backend API (10 min)

- [ ] En el mismo proyecto, "+ New"
- [ ] "GitHub Repo" → Seleccionar repositorio
- [ ] Ir a "Variables"
- [ ] Agregar `ConnectionStrings__DefaultConnection` (cadena de arriba)
- [ ] Agregar `JwtSettings__SecretKey` (mínimo 32 caracteres)
- [ ] Agregar `JwtSettings__Issuer` = NobleStepAPI
- [ ] Agregar `JwtSettings__Audience` = NobleStepClient
- [ ] Agregar `JwtSettings__ExpirationMinutes` = 1440
- [ ] Agregar `App__FrontendUrl` = http://localhost:4200
- [ ] Agregar `ASPNETCORE_ENVIRONMENT` = Production
- [ ] Ir a "Settings" → "Networking"
- [ ] "Generate Domain"
- [ ] Esperar deployment (5-8 min)
- [ ] Verificar: `https://TU-URL.up.railway.app/api/health`

**✅ URL Backend:** `https://________________________________`

---

## 🛍️ VERCEL - Ecommerce (7 min)

- [ ] Editar `frontend/projects/ecommerce/src/environments/environment.prod.ts`
- [ ] Cambiar `apiUrl` a URL de Railway
- [ ] `git add . && git commit -m "feat: Railway backend" && git push`
- [ ] Ir a https://vercel.com
- [ ] "Add New" → "Project"
- [ ] Importar repositorio
- [ ] Project Name: `noblestep-ecommerce`
- [ ] Build Command: `cd frontend && npm install && npm run build:ecommerce`
- [ ] Output Directory: `frontend/dist/ecommerce/browser`
- [ ] Deploy
- [ ] Esperar 3-5 min
- [ ] Verificar que carga

**✅ URL Ecommerce:** `https://________________________________`

---

## 👨‍💼 VERCEL - Admin (7 min)

- [ ] Editar `frontend/src/environments/environment.prod.ts`
- [ ] Cambiar `apiUrl` a URL de Railway
- [ ] `git add . && git commit -m "feat: Railway admin" && git push`
- [ ] En Vercel, "Add New" → "Project"
- [ ] Importar MISMO repositorio
- [ ] Project Name: `noblestep-admin`
- [ ] Build Command: `cd frontend && npm install && npm run build`
- [ ] Output Directory: `frontend/dist/browser`
- [ ] Deploy
- [ ] Esperar 3-5 min
- [ ] Verificar que carga

**✅ URL Admin:** `https://________________________________`

---

## 🔄 ACTUALIZAR CORS (2 min)

- [ ] Railway → noblestep-api → "Variables"
- [ ] Editar `App__FrontendUrl`
- [ ] Valor: `https://tu-ecommerce.vercel.app,https://tu-admin.vercel.app`
- [ ] Esperar redeploy (2-3 min)
- [ ] Verificar ecommerce carga productos
- [ ] Verificar admin funciona
- [ ] Sin errores de CORS en consola (F12)

---

## ✅ VERIFICACIÓN FINAL

### Backend
- [ ] `/api/health` responde OK
- [ ] `/swagger` abre correctamente

### Ecommerce
- [ ] Página carga
- [ ] Productos se muestran
- [ ] Carrito funciona
- [ ] Login/Registro funciona

### Admin
- [ ] Login funciona
- [ ] Dashboard muestra datos
- [ ] CRUD de productos funciona

---

## 🎉 ¡COMPLETADO!

**Tiempo total:** ~30 minutos  
**Costo:** $0/mes

**URLs Finales:**
```
Backend:   https://________________________________
Ecommerce: https://________________________________
Admin:     https://________________________________
```
