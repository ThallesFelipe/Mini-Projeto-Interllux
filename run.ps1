# Script para rodar o projeto - Intellux

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Iniciando Intellux Platform         " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Salvar diretório raiz
$projectRoot = $PWD.Path
$venvPath = Join-Path $projectRoot "venv"
$backendPath = Join-Path $projectRoot "backend"
$frontendPath = Join-Path $projectRoot "frontend"

# Verificar se .env existe
$envPath = Join-Path $backendPath ".env"
if (!(Test-Path $envPath)) {
    Write-Host "✗ Arquivo .env não encontrado em $envPath!" -ForegroundColor Red
    Write-Host "Execute primeiro: .\install.ps1" -ForegroundColor Yellow
    exit 1
}

# Verificar se venv existe
if (!(Test-Path $venvPath)) {
    Write-Host "✗ Ambiente virtual não encontrado em $venvPath!" -ForegroundColor Red
    Write-Host "Execute primeiro: .\install.ps1" -ForegroundColor Yellow
    exit 1
}

# Verificar se node_modules existe
$nodeModulesPath = Join-Path $frontendPath "node_modules"
if (!(Test-Path $nodeModulesPath)) {
    Write-Host "✗ Dependências do frontend não encontradas!" -ForegroundColor Red
    Write-Host "Execute primeiro: .\install.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "Iniciando servidores..." -ForegroundColor Yellow
Write-Host ""

# Iniciar Backend em nova janela
Write-Host "→ Abrindo Backend..." -ForegroundColor Gray

# Detectar localização do python no venv (caminho absoluto)
$pythonExe = Join-Path $venvPath "Scripts\python.exe"
$appPath = Join-Path $backendPath "app.py"

if (!(Test-Path $pythonExe)) {
    Write-Host "✗ Python não encontrado em $pythonExe" -ForegroundColor Red
    Write-Host "Execute: .\install.ps1" -ForegroundColor Yellow
    exit 1
}

Start-Process pwsh -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$backendPath'; Write-Host '🚀 Backend rodando em http://localhost:5000' -ForegroundColor Green; & '$pythonExe' '$appPath'"
)

# Aguardar 2 segundos
Start-Sleep -Seconds 2

# Iniciar Frontend em nova janela
Write-Host "→ Abrindo Frontend..." -ForegroundColor Gray
Start-Process pwsh -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$frontendPath'; Write-Host '🚀 Frontend rodando em http://localhost:3000' -ForegroundColor Green; npm run dev"
)

Start-Sleep -Seconds 1

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   ✓ SERVIDORES INICIADOS!              " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Acesse no navegador:" -ForegroundColor Cyan
Write-Host "  Frontend: http://localhost:3000" -ForegroundColor White
Write-Host "  Backend:  http://localhost:5000" -ForegroundColor White
Write-Host ""
Write-Host "Para parar os servidores:" -ForegroundColor Yellow
Write-Host "  Feche as janelas ou pressione Ctrl+C" -ForegroundColor White
Write-Host ""
