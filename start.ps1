# Script para iniciar Backend e Frontend simultaneamente

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Iniciando Intellux Platform         " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Salvar diretório raiz
$projectRoot = $PWD.Path
$venvPath = Join-Path $projectRoot "venv"
$backendPath = Join-Path $projectRoot "backend"
$frontendPath = Join-Path $projectRoot "frontend"
$pythonExe = Join-Path $venvPath "Scripts\python.exe"
$appPath = Join-Path $backendPath "app.py"


Write-Host "Iniciando servidores..." -ForegroundColor Yellow
Write-Host ""

# Iniciar Backend em nova janela
Start-Process pwsh -ArgumentList "-NoExit", "-Command", "& {param(`$bp, `$pe, `$ap) Set-Location `$bp; Write-Host '🚀 Backend em http://localhost:5000' -ForegroundColor Green; & `$pe `$ap} -bp '$backendPath' -pe '$pythonExe' -ap '$appPath'"

# Aguardar 3 segundos
Start-Sleep -Seconds 3

# Iniciar Frontend em nova janela
Start-Process pwsh -ArgumentList "-NoExit", "-Command", "& {param(`$fp) Set-Location `$fp; Write-Host '🚀 Frontend em http://localhost:3000' -ForegroundColor Green; npm run dev} -fp '$frontendPath'"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   ✓ Servidores iniciados!              " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Backend:  http://localhost:5000" -ForegroundColor Cyan
Write-Host "Frontend: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pressione Ctrl+C nas janelas para parar os servidores." -ForegroundColor Yellow
Write-Host ""
