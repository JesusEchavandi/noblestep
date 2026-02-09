# 📤 Subir Proyecto Limpio a GitHub

## Opción 1: Crear Nuevo Repositorio (Recomendado)

### Paso 1: Crear Repositorio en GitHub
1. Ve a https://github.com/new
2. Repository name: `noblestep`
3. Description: `Sistema de gestión de calzado con e-commerce - .NET 8 + Angular 18`
4. **NO** marques "Initialize with README" (ya tienes uno)
5. Click en **"Create repository"**

### Paso 2: Conectar y Subir
```bash
# Eliminar remote anterior (si existe)
git remote remove origin

# Agregar nuevo remote (reemplaza TU-USUARIO con tu usuario de GitHub)
git remote add origin https://github.com/TU-USUARIO/noblestep.git

# Verificar
git remote -v

# Push inicial
git push -u origin main
```

Si pide autenticación, usa **Personal Access Token** en lugar de contraseña:
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token
3. Marca: `repo` (full control)
4. Copia el token y úsalo como contraseña

---

## Opción 2: Usar Repositorio Existente

Si ya tienes un repositorio llamado `noblestep`:

```bash
# Verificar URL del remote
git remote -v

# Si la URL es incorrecta, actualizarla
git remote set-url origin https://github.com/TU-USUARIO/noblestep.git

# Push forzado (CUIDADO: sobrescribe el remoto)
git push -f origin main
```

---

## Opción 3: Renombrar Repositorio Existente

Si tienes `noblestep-fullstack` y quieres renombrarlo:

1. Ve a GitHub → Tu repositorio
2. Settings → Repository name
3. Cambia a `noblestep`
4. Click "Rename"

Luego:
```bash
git remote set-url origin https://github.com/TU-USUARIO/noblestep.git
git push origin main
```

---

## ✅ Verificar que Subió Correctamente

Después del push, verifica en GitHub:
- [ ] README.md se ve correctamente
- [ ] Carpetas `backend/`, `frontend/`, `database/` están presentes
- [ ] Archivos de configuración: `railway.json`, `vercel.json`, `nixpacks.toml`
- [ ] Guías: `DESPLIEGUE-RAILWAY-VERCEL.md`, `CHECKLIST-RAILWAY-VERCEL.md`

---

## 🔒 Archivo .gitignore

Tu proyecto ya tiene `.gitignore` configurado para NO subir:
- `node_modules/`
- `bin/`, `obj/` (.NET)
- `.env`
- Archivos de configuración local

---

## 📊 Resumen de lo que se Subió

### ✅ Incluido
- `backend/` - Código del API (.NET 8)
- `frontend/` - Admin + Ecommerce (Angular 18)
- `database/` - Script SQL
- `railway.json` - Config de Railway
- `nixpacks.toml` - Build config
- `vercel.json` - Config de Vercel
- `README.md` - Documentación limpia
- `DESPLIEGUE-RAILWAY-VERCEL.md` - Guía de despliegue
- `CHECKLIST-RAILWAY-VERCEL.md` - Checklist

### ❌ Excluido (Limpieza realizada)
- Archivos de Render, Netlify, Docker
- Scripts de Ngrok
- Documentación antigua y redundante
- Archivos temporales

---

## 🚀 Siguiente Paso

Una vez subido a GitHub:
1. Sigue la guía: `DESPLIEGUE-RAILWAY-VERCEL.md`
2. Despliega en Railway + Vercel
3. ¡Proyecto en producción!
