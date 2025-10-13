# Script simplificado de instalação - Intellux Project

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Intellux - Market Intelligence      " -ForegroundColor Cyan
Write-Host "   Instalação Simplificada             " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Python
Write-Host "[1/4] Verificando Python..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✓ Python encontrado: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Python não encontrado!" -ForegroundColor Red
    Write-Host "Instale Python 3.10+ de: https://www.python.org/downloads/" -ForegroundColor Yellow
    exit 1
}

# Verificar Node.js
Write-Host "[2/4] Verificando Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version 2>&1
    Write-Host "✓ Node.js encontrado: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Node.js não encontrado!" -ForegroundColor Red
    Write-Host "Instale Node.js de: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "[3/4] Configurando Backend..." -ForegroundColor Yellow

# Salvar diretório raiz
$projectRoot = $PWD.Path
$venvPath = Join-Path $projectRoot "venv"
$backendPath = Join-Path $projectRoot "backend"

Set-Location -Path $backendPath

# Criar venv na raiz do projeto se não existir
if (!(Test-Path $venvPath)) {
    Write-Host "  → Criando ambiente virtual na raiz..." -ForegroundColor Gray
    python -m venv $venvPath
}

# Instalar dependências
Write-Host "  → Instalando dependências Python..." -ForegroundColor Gray
$pythonExe = Join-Path $venvPath "Scripts\python.exe"
$pipExe = Join-Path $venvPath "Scripts\pip.exe"
$requirementsPath = Join-Path $backendPath "requirements.txt"

if (Test-Path $pythonExe) {
    & $pythonExe -m pip install --upgrade pip --quiet
    & $pipExe install -r $requirementsPath --quiet
} else {
    # Fallback: usar python global
    python -m pip install --user --upgrade pip --quiet
    python -m pip install --user -r $requirementsPath --quiet
}

# Criar .env se não existir
$envPath = Join-Path $backendPath ".env"
$envExamplePath = Join-Path $backendPath ".env.example"

if (!(Test-Path $envPath)) {
    Write-Host "  → Criando arquivo .env..." -ForegroundColor Gray
    Copy-Item $envExamplePath $envPath
    Write-Host ""
    Write-Host "  ⚠️  IMPORTANTE: Configure sua API Key!" -ForegroundColor Yellow
    Write-Host "  Edite o arquivo: $envPath" -ForegroundColor White
    Write-Host "  Obtenha sua chave em: https://makersuite.google.com/app/apikey" -ForegroundColor Cyan
    Write-Host ""
}

Write-Host "✓ Backend configurado!" -ForegroundColor Green
Set-Location -Path $projectRoot

Write-Host ""
Write-Host "[4/4] Configurando Frontend..." -ForegroundColor Yellow
$frontendPath = Join-Path $projectRoot "frontend"
Set-Location -Path $frontendPath

Write-Host "  → Instalando dependências Node.js..." -ForegroundColor Gray
npm install --silent

Write-Host "✓ Frontend configurado!" -ForegroundColor Green
Set-Location -Path $projectRoot

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   ✓ INSTALAÇÃO CONCLUÍDA!              " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Cyan
Write-Host "  1. Configure a API Key em: $envPath" -ForegroundColor White
Write-Host "  2. Execute: .\run.ps1" -ForegroundColor White
Write-Host ""
