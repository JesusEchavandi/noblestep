# Script para iniciar Sistema Completo: Admin + E-Commerce
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Iniciando Sistema Completo" -ForegroundColor Cyan
Write-Host "  Admin Panel + E-Commerce" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Iniciar Backend
Write-Host "1. Iniciando Backend (puerto 5000)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd backend; dotnet run"
Start-Sleep -Seconds 8

# Iniciar Admin Frontend
Write-Host "2. Iniciando Admin Panel (puerto 4200)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd frontend; npm start"
Start-Sleep -Seconds 5

# Iniciar E-Commerce
Write-Host "3. Iniciando E-Commerce (puerto 4300)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd frontend; npm run ng serve -- --project=ecommerce --port=4300"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Todos los servicios iniciados!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Accede a:" -ForegroundColor Cyan
Write-Host "  📊 Admin Panel: http://localhost:4200" -ForegroundColor White
Write-Host "      Usuario: admin / Contraseña: admin123" -ForegroundColor Gray
Write-Host ""
Write-Host "  🛒 E-Commerce: http://localhost:4300" -ForegroundColor White
Write-Host "      Catálogo público para clientes" -ForegroundColor Gray
Write-Host ""
Write-Host "  🔧 Backend API: http://localhost:5000" -ForegroundColor White
Write-Host ""
Write-Host "Nota: Espera unos segundos mientras se compilan los proyectos..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
