# 🔄 Guía: Recrear Repositorio GitHub Limpio

Esta guía te ayudará a eliminar el repositorio actual y crear uno nuevo desde cero con los archivos limpios.

---

## 📋 PARTE 1: Eliminar Repositorio Actual en GitHub

### Paso 1.1: Acceder al Repositorio
1. Ve a: https://github.com/JesusEchavandi/noblestep-fullstack
2. Inicia sesión si es necesario

### Paso 1.2: Ir a Settings
1. En la página del repositorio, busca las pestañas en la parte superior
2. Click en **"Settings"** (última pestaña a la derecha)

### Paso 1.3: Eliminar el Repositorio
1. Baja hasta el final de la página
2. Encontrarás la sección **"Danger Zone"** (zona roja)
3. Click en **"Delete this repository"**
4. GitHub te pedirá confirmación
5. Escribe exactamente: `JesusEchavandi/noblestep-fullstack`
6. Click en **"I understand the consequences, delete this repository"**

✅ **Repositorio eliminado**

---

## 📋 PARTE 2: Limpiar Configuración Git Local

### Paso 2.1: Eliminar Configuración Git Actual

Ejecuta estos comandos en PowerShell desde la carpeta del proyecto:

```powershell
# Eliminar carpeta .git (historial completo)
Remove-Item -Path .git -Recurse -Force

# Verificar que se eliminó
if (!(Test-Path .git)) {
    Write-Host "✓ Configuración Git eliminada" -ForegroundColor Green
} else {
    Write-Host "✗ Error al eliminar .git" -ForegroundColor Red
}
```

---

## 📋 PARTE 3: Crear Nuevo Repositorio en GitHub

### Paso 3.1: Crear Repositorio Nuevo

1. Ve a: https://github.com/new
2. Configurar:
   - **Repository name**: `noblestep-fullstack`
   - **Description**: `Sistema de Gestión de Calzado - NobleStep (Sistema Web + E-commerce)`
   - **Visibility**: Public o Private (tu elección)
   - **❌ NO marques**: "Add a README file"
   - **❌ NO marques**: "Add .gitignore"
   - **❌ NO marques**: "Choose a license"
3. Click en **"Create repository"**

### Paso 3.2: Copiar URL del Repositorio

GitHub te mostrará una página con instrucciones. **Copia la URL**:
```
https://github.com/JesusEchavandi/noblestep-fullstack.git
```

---

## 📋 PARTE 4: Inicializar Git Local y Subir Archivos Limpios

### Paso 4.1: Inicializar Git

```powershell
# Inicializar repositorio Git
git init

# Verificar
git status
```

### Paso 4.2: Agregar Todos los Archivos Limpios

```powershell
# Agregar todos los archivos
git add .

# Ver qué se agregará
git status
```

Deberías ver solo los archivos limpios:
- ✅ backend/
- ✅ frontend/
- ✅ database/
- ✅ Archivos de configuración (Dockerfile, render.yaml, etc.)
- ✅ Guías de despliegue
- ✅ README.md
- ❌ NO verás archivos temporales o .md antiguos

### Paso 4.3: Hacer el Primer Commit

```powershell
# Commit inicial con todos los archivos limpios
git commit -m "Initial commit: Sistema NobleStep completo y limpio

- Backend API .NET 8 con 14 controladores
- Frontend Angular 18 (Sistema Web + E-commerce)
- Base de datos MySQL unificada
- Configuración para despliegue en Render + Vercel
- Documentación completa de despliegue
"
```

### Paso 4.4: Configurar Branch Principal

```powershell
# Renombrar branch a 'main' (si es necesario)
git branch -M main
```

### Paso 4.5: Conectar con GitHub

```powershell
# Agregar remote (reemplaza con tu URL)
git remote add origin https://github.com/JesusEchavandi/noblestep-fullstack.git

# Verificar
git remote -v
```

### Paso 4.6: Subir a GitHub

```powershell
# Push inicial
git push -u origin main
```

---

## ✅ VERIFICACIÓN FINAL

### Verificar en GitHub

1. Ve a: https://github.com/JesusEchavandi/noblestep-fullstack
2. Deberías ver:
   - ✅ README.md con documentación profesional
   - ✅ Carpetas: backend, frontend, database
   - ✅ Archivos de configuración: Dockerfile, render.yaml, vercel.json
   - ✅ Guías de despliegue
   - ✅ 1 commit inicial
   - ❌ Sin archivos .md temporales
   - ❌ Sin scripts .ps1 de prueba

### Verificar Estructura

El repositorio debe mostrar:

```
noblestep-fullstack/
├── backend/
├── frontend/
├── database/
├── Dockerfile
├── render.yaml
├── vercel.json
├── .gitignore
├── README.md
├── DESPLEGAR-PASO-A-PASO.md
├── GUIA-DESPLIEGUE-COMPLETA.md
├── RESUMEN-DESPLIEGUE.md
├── INICIAR-NGROK.ps1
├── CONFIGURAR-MYSQL-NGROK.sql
└── VARIABLES-ENTORNO-RENDER.txt
```

---

## 🚀 SIGUIENTES PASOS

Una vez que el repositorio esté limpio en GitHub:

1. **Continuar con el despliegue**:
   - Seguir: `DESPLEGAR-PASO-A-PASO.md`

2. **Configurar Render**:
   - Conectar el nuevo repositorio
   - Configurar variables de entorno

3. **Configurar Vercel**:
   - Importar el nuevo repositorio
   - Deploy automático

---

## 🆘 Solución de Problemas

### Error: "remote origin already exists"
```powershell
# Eliminar remote actual
git remote remove origin

# Agregar nuevamente
git remote add origin https://github.com/JesusEchavandi/noblestep-fullstack.git
```

### Error: "failed to push some refs"
```powershell
# Forzar push (solo si es un repositorio nuevo)
git push -u origin main --force
```

### Error: "Permission denied"
```powershell
# Verificar credenciales de GitHub
# Puede que necesites configurar un Personal Access Token
# Ve a: Settings → Developer settings → Personal access tokens
```

---

## 📝 Script Automatizado (Opcional)

Si prefieres, aquí está el script completo:

```powershell
# SCRIPT: Recrear repositorio limpio
# Ejecutar DESPUÉS de eliminar el repo en GitHub

# 1. Limpiar Git local
Remove-Item -Path .git -Recurse -Force -ErrorAction SilentlyContinue

# 2. Inicializar
git init

# 3. Agregar archivos
git add .

# 4. Commit
git commit -m "Initial commit: Sistema NobleStep completo y limpio"

# 5. Configurar branch
git branch -M main

# 6. Conectar con GitHub (reemplaza con tu URL)
git remote add origin https://github.com/JesusEchavandi/noblestep-fullstack.git

# 7. Push
git push -u origin main

Write-Host "✓ Repositorio recreado exitosamente" -ForegroundColor Green
```

---

## ⏱️ Tiempo Estimado

- **Eliminar repo en GitHub**: 2 minutos
- **Limpiar y configurar local**: 3 minutos
- **Crear nuevo repo y push**: 5 minutos
- **Total**: ~10 minutos

---

## 🎯 Resultado Final

Tendrás un repositorio completamente limpio:
- ✅ Solo archivos necesarios
- ✅ Historial limpio (1 commit inicial)
- ✅ Listo para despliegue
- ✅ Documentación profesional
- ✅ Sin archivos temporales
