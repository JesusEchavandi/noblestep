# ====================================================================
# SCRIPT PARA INICIAR EL SISTEMA NOBLESTEP COMPLETO
# ====================================================================
# Inicia Backend y Frontend correctamente
# ====================================================================

Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "  INICIANDO SISTEMA NOBLESTEP" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

# Limpiar procesos anteriores
Write-Host "1. Limpiando procesos anteriores..." -ForegroundColor Yellow
Get-Process | Where-Object { $_.ProcessName -eq "dotnet" -or $_.ProcessName -like "*NobleStep*" -or $_.ProcessName -eq "node" } | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Write-Host "   ✓ Procesos limpiados" -ForegroundColor Green

# Verificar base de datos
Write-Host "`n2. Verificando base de datos..." -ForegroundColor Yellow
try {
    $dbCheck = C:\xampp\mysql\bin\mysql.exe -u root noblestepdb -e "SELECT COUNT(*) as count FROM Users;" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Base de datos OK" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Problema con la base de datos" -ForegroundColor Red
        Write-Host "   Ejecuta: .\INSTALAR-BASE-DATOS-FINAL.ps1" -ForegroundColor Yellow
        exit
    }
} catch {
    Write-Host "   ✗ No se puede conectar a MySQL" -ForegroundColor Red
    exit
}

# Iniciar Backend
Write-Host "`n3. Iniciando Backend..." -ForegroundColor Yellow
Write-Host "   Abriendo nueva ventana para el backend..." -ForegroundColor Gray

$backendScript = @"
Write-Host 'BACKEND - NobleStep API' -ForegroundColor Cyan
Write-Host '========================' -ForegroundColor Cyan
Write-Host ''
Set-Location '$PWD\backend'
Write-Host 'Iniciando backend en puerto 5062...' -ForegroundColor Yellow
dotnet run
"@

$backendScript | Out-File -FilePath "tmp_backend_start.ps1" -Encoding UTF8
Start-Process powershell -ArgumentList "-NoExit", "-File", "$PWD\tmp_backend_start.ps1" -WindowStyle Normal

Write-Host "   ✓ Backend iniciándose en nueva ventana" -ForegroundColor Green
Write-Host "   ⏳ Esperando 10 segundos para que inicie..." -ForegroundColor Gray
Start-Sleep -Seconds 10

# Verificar que el backend responda
Write-Host "`n4. Verificando Backend..." -ForegroundColor Yellow
$backendReady = $false
$retries = 0
$maxRetries = 10

while (-not $backendReady -and $retries -lt $maxRetries) {
    try {
        $testResponse = Invoke-WebRequest -Uri "http://localhost:5062/api/auth/login" -Method POST -Body '{}' -ContentType "application/json" -TimeoutSec 2 -ErrorAction Stop
        $backendReady = $true
    } catch {
        if ($_.Exception.Response.StatusCode.value__ -eq 400 -or $_.Exception.Response.StatusCode.value__ -eq 401) {
            # 400 o 401 significa que el endpoint responde (aunque con error de validación)
            $backendReady = $true
        } else {
            $retries++
            Write-Host "   Intento $retries/$maxRetries..." -ForegroundColor Gray
            Start-Sleep -Seconds 2
        }
    }
}

if ($backendReady) {
    Write-Host "   ✓ Backend está respondiendo en http://localhost:5062" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Backend no responde aún. Revisa la ventana del backend" -ForegroundColor Yellow
}

# Iniciar Frontend
Write-Host "`n5. Iniciando Frontend..." -ForegroundColor Yellow
Write-Host "   Abriendo nueva ventana para el frontend..." -ForegroundColor Gray

$frontendScript = @"
Write-Host 'FRONTEND - NobleStep Web' -ForegroundColor Cyan
Write-Host '==========================' -ForegroundColor Cyan
Write-Host ''
Set-Location '$PWD\frontend'
Write-Host 'Iniciando frontend en puerto 4200...' -ForegroundColor Yellow
Write-Host 'Espera a ver: Compiled successfully!' -ForegroundColor Gray
Write-Host ''
npm start
"@

$frontendScript | Out-File -FilePath "tmp_frontend_start.ps1" -Encoding UTF8
Start-Process powershell -ArgumentList "-NoExit", "-File", "$PWD\tmp_frontend_start.ps1" -WindowStyle Normal

Write-Host "   ✓ Frontend iniciándose en nueva ventana" -ForegroundColor Green

# Resumen
Write-Host "`n=====================================================================" -ForegroundColor Green
Write-Host "  ✓ SISTEMA INICIADO" -ForegroundColor Green
Write-Host "=====================================================================" -ForegroundColor Green

Write-Host "`n📊 ESTADO DE LOS SERVICIOS:" -ForegroundColor Cyan
Write-Host "   Backend:  http://localhost:5062 (API + Swagger)" -ForegroundColor White
Write-Host "   Frontend: http://localhost:4200 (Angular)" -ForegroundColor White

Write-Host "`n🔑 CREDENCIALES:" -ForegroundColor Cyan
Write-Host "   Usuario:    admin" -ForegroundColor White
Write-Host "   Contraseña: admin123" -ForegroundColor White

Write-Host "`n📝 INSTRUCCIONES:" -ForegroundColor Cyan
Write-Host "   1. Espera 30-60 segundos a que el frontend compile" -ForegroundColor White
Write-Host "   2. Abre el navegador en: http://localhost:4200" -ForegroundColor White
Write-Host "   3. Inicia sesión con las credenciales de arriba" -ForegroundColor White
Write-Host "   4. El dashboard cargará automáticamente" -ForegroundColor White

Write-Host "`n⚠️  VENTANAS ABIERTAS:" -ForegroundColor Yellow
Write-Host "   - Ventana 1: Backend (dotnet run)" -ForegroundColor Gray
Write-Host "   - Ventana 2: Frontend (npm start)" -ForegroundColor Gray
Write-Host "   - Esta ventana: Control del sistema" -ForegroundColor Gray

Write-Host "`n💡 PARA DETENER EL SISTEMA:" -ForegroundColor Yellow
Write-Host "   Cierra las ventanas del Backend y Frontend" -ForegroundColor White

Write-Host "`n=====================================================================" -ForegroundColor Cyan
Write-Host "  Presiona cualquier tecla para cerrar esta ventana" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan

$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Limpiar archivos temporales
Remove-Item -Path "tmp_backend_start.ps1" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "tmp_frontend_start.ps1" -Force -ErrorAction SilentlyContinue
