# ============================================
# Script de inicio del Sistema NobleStep
# Sistema completamente en ESPAÑOL
# ============================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Sistema NobleStep - Inicio Automático" -ForegroundColor Cyan
Write-Host "   Estructura en Español" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar MySQL
Write-Host "1. Verificando MySQL..." -ForegroundColor Yellow
$mysqlRunning = netstat -ano | findstr ":3306"
if ($mysqlRunning) {
    Write-Host "   ✓ MySQL está corriendo en puerto 3306" -ForegroundColor Green
} else {
    Write-Host "   ✗ MySQL NO está corriendo" -ForegroundColor Red
    Write-Host "   Por favor inicia MySQL antes de continuar" -ForegroundColor Yellow
    exit
}

Write-Host ""

# Iniciar Backend
Write-Host "2. Iniciando Backend (API)..." -ForegroundColor Yellow
$backendRunning = netstat -ano | findstr ":5062"
if ($backendRunning) {
    Write-Host "   ✓ Backend ya está corriendo en puerto 5062" -ForegroundColor Green
} else {
    Write-Host "   Iniciando backend en segundo plano..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd backend; Write-Host 'Backend NobleStep API' -ForegroundColor Cyan; dotnet run --project NobleStep.Api.csproj"
    Start-Sleep -Seconds 5
    Write-Host "   ✓ Backend iniciado en http://localhost:5062" -ForegroundColor Green
}

Write-Host ""

# Iniciar Frontend
Write-Host "3. Iniciando Frontend (Angular)..." -ForegroundColor Yellow
$frontendRunning = netstat -ano | findstr ":4200"
if ($frontendRunning) {
    Write-Host "   ✓ Frontend ya está corriendo en puerto 4200" -ForegroundColor Green
} else {
    Write-Host "   Iniciando frontend en segundo plano..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd frontend; Write-Host 'Frontend NobleStep Web' -ForegroundColor Cyan; npm start"
    Write-Host "   ✓ Frontend iniciándose en http://localhost:4200" -ForegroundColor Green
    Write-Host "   (Puede tardar 15-30 segundos en estar disponible)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   ✓ Sistema iniciado correctamente" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Accesos:" -ForegroundColor Cyan
Write-Host "  • Frontend: http://localhost:4200" -ForegroundColor White
Write-Host "  • Backend API: http://localhost:5062" -ForegroundColor White
Write-Host ""
Write-Host "Credenciales:" -ForegroundColor Cyan
Write-Host "  • Usuario: admin" -ForegroundColor White
Write-Host "  • Contraseña: admin123" -ForegroundColor White
Write-Host ""
Write-Host "Presiona cualquier tecla para cerrar..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
