# =============================================
# Script: Recrear Repositorio GitHub Limpio
# =============================================
# IMPORTANTE: Ejecutar DESPUÉS de eliminar el repositorio en GitHub

Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         Recrear Repositorio GitHub Limpio                    ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verificación inicial
Write-Host "⚠️  IMPORTANTE: Antes de continuar, asegúrate de:" -ForegroundColor Yellow
Write-Host "   1. Haber eliminado el repositorio en GitHub" -ForegroundColor White
Write-Host "   2. Haber creado un nuevo repositorio vacío en GitHub" -ForegroundColor White
Write-Host "   3. Tener la URL del nuevo repositorio lista" -ForegroundColor White
Write-Host ""

$continue = Read-Host "¿Deseas continuar? (si/no)"
if ($continue -ne "si" -and $continue -ne "s" -and $continue -ne "yes") {
    Write-Host ""
    Write-Host "   Proceso cancelado." -ForegroundColor Yellow
    Write-Host ""
    exit
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Eliminar configuración Git local
Write-Host "1. Eliminando configuración Git local..." -ForegroundColor Yellow

if (Test-Path .git) {
    Remove-Item -Path .git -Recurse -Force
    Write-Host "   ✓ Carpeta .git eliminada" -ForegroundColor Green
} else {
    Write-Host "   ℹ No existe carpeta .git" -ForegroundColor Gray
}

Write-Host ""

# Paso 2: Inicializar Git
Write-Host "2. Inicializando Git..." -ForegroundColor Yellow
git init
Write-Host "   ✓ Git inicializado" -ForegroundColor Green
Write-Host ""

# Paso 3: Verificar archivos
Write-Host "3. Verificando archivos a incluir..." -ForegroundColor Yellow
Write-Host ""
Write-Host "   Archivos que se agregarán:" -ForegroundColor Gray
git status --short
Write-Host ""

$confirmFiles = Read-Host "¿Los archivos se ven correctos? (si/no)"
if ($confirmFiles -ne "si" -and $confirmFiles -ne "s" -and $confirmFiles -ne "yes") {
    Write-Host ""
    Write-Host "   Proceso cancelado. Revisa los archivos." -ForegroundColor Yellow
    Write-Host ""
    exit
}

Write-Host ""

# Paso 4: Agregar archivos
Write-Host "4. Agregando archivos al staging..." -ForegroundColor Yellow
git add .
Write-Host "   ✓ Archivos agregados" -ForegroundColor Green
Write-Host ""

# Paso 5: Commit inicial
Write-Host "5. Creando commit inicial..." -ForegroundColor Yellow
git commit -m "Initial commit: Sistema NobleStep completo y limpio

- Backend API .NET 8 con 14 controladores
- Frontend Angular 18 (Sistema Web + E-commerce)
- Base de datos MySQL unificada
- Configuración para despliegue en Render + Vercel
- Documentación completa de despliegue
"
Write-Host "   ✓ Commit creado" -ForegroundColor Green
Write-Host ""

# Paso 6: Configurar branch
Write-Host "6. Configurando branch principal..." -ForegroundColor Yellow
git branch -M main
Write-Host "   ✓ Branch 'main' configurado" -ForegroundColor Green
Write-Host ""

# Paso 7: Agregar remote
Write-Host "7. Conectando con GitHub..." -ForegroundColor Yellow
Write-Host ""
Write-Host "   Ingresa la URL de tu nuevo repositorio:" -ForegroundColor Cyan
Write-Host "   Ejemplo: https://github.com/TuUsuario/noblestep-fullstack.git" -ForegroundColor Gray
Write-Host ""
$repoUrl = Read-Host "   URL"

if ([string]::IsNullOrWhiteSpace($repoUrl)) {
    Write-Host ""
    Write-Host "   ✗ URL no proporcionada. Proceso cancelado." -ForegroundColor Red
    Write-Host ""
    exit
}

# Eliminar remote si existe
git remote remove origin 2>$null

# Agregar nuevo remote
git remote add origin $repoUrl
Write-Host "   ✓ Remote configurado: $repoUrl" -ForegroundColor Green
Write-Host ""

# Verificar remote
Write-Host "   Verificando conexión..." -ForegroundColor Gray
git remote -v
Write-Host ""

# Paso 8: Push
Write-Host "8. Subiendo archivos a GitHub..." -ForegroundColor Yellow
Write-Host ""
Write-Host "   Esto puede tardar unos segundos..." -ForegroundColor Gray
Write-Host ""

git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "   ✅ REPOSITORIO CREADO EXITOSAMENTE" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 RESUMEN:" -ForegroundColor Cyan
    Write-Host "   • Repositorio limpio creado" -ForegroundColor White
    Write-Host "   • 1 commit inicial con todos los archivos" -ForegroundColor White
    Write-Host "   • Branch 'main' configurado" -ForegroundColor White
    Write-Host "   • Subido a GitHub exitosamente" -ForegroundColor White
    Write-Host ""
    Write-Host "🔗 Ver en GitHub:" -ForegroundColor Cyan
    Write-Host "   $repoUrl" -ForegroundColor White
    Write-Host ""
    Write-Host "🚀 PRÓXIMOS PASOS:" -ForegroundColor Yellow
    Write-Host "   1. Verifica el repositorio en GitHub" -ForegroundColor White
    Write-Host "   2. Sigue la guía: DESPLEGAR-PASO-A-PASO.md" -ForegroundColor White
    Write-Host "   3. Configura Render y Vercel" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host "   ✗ ERROR AL SUBIR A GITHUB" -ForegroundColor Red
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host ""
    Write-Host "Posibles causas:" -ForegroundColor Yellow
    Write-Host "   • URL del repositorio incorrecta" -ForegroundColor White
    Write-Host "   • Problemas de autenticación" -ForegroundColor White
    Write-Host "   • Repositorio no está vacío en GitHub" -ForegroundColor White
    Write-Host ""
    Write-Host "Soluciones:" -ForegroundColor Cyan
    Write-Host "   1. Verifica la URL del repositorio" -ForegroundColor White
    Write-Host "   2. Configura tu GitHub Personal Access Token" -ForegroundColor White
    Write-Host "   3. Asegúrate de que el repo en GitHub esté vacío" -ForegroundColor White
    Write-Host ""
    Write-Host "Para más ayuda, consulta: RECREAR-REPOSITORIO-GITHUB.md" -ForegroundColor Gray
    Write-Host ""
}
