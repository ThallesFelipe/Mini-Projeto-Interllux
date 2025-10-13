# Script de instalação e execução - Intellux Project
# Execute este script no PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Intellux - Market Intelligence      " -ForegroundColor Cyan
Write-Host "   Setup e Instalação                  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se Python está instalado
Write-Host "Verificando Python..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Python encontrado: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Python não encontrado. Por favor, instale Python 3.10+." -ForegroundColor Red
    exit 1
}

# Verificar se Node.js está instalado
Write-Host "Verificando Node.js..." -ForegroundColor Yellow
$nodeVersion = node --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Node.js encontrado: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Node.js não encontrado. Por favor, instale Node.js 16+." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Configurando Backend (Python/Flask)  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Salvar diretório raiz do projeto
$projectRoot = $PWD.Path

# Navegar para backend
Set-Location -Path (Join-Path $projectRoot "backend")

# Criar ambiente virtual na raiz do projeto se não existir
$venvPath = Join-Path $projectRoot "venv"
if (!(Test-Path $venvPath)) {
    Write-Host "Criando ambiente virtual Python na raiz do projeto..." -ForegroundColor Yellow
    python -m venv $venvPath
    Write-Host "✓ Ambiente virtual criado!" -ForegroundColor Green
} else {
    Write-Host "✓ Ambiente virtual já existe" -ForegroundColor Green
}

# Instalar dependências usando caminhos absolutos
Write-Host "Instalando dependências Python..." -ForegroundColor Yellow
$pythonExe = Join-Path $venvPath "Scripts\python.exe"
$pipExe = Join-Path $venvPath "Scripts\pip.exe"
$requirementsPath = Join-Path $PWD.Path "requirements.txt"

if (Test-Path $pythonExe) {
    & $pythonExe -m pip install --upgrade pip
    & $pipExe install -r $requirementsPath
} else {
    Write-Host "✗ Erro: python.exe não encontrado em $pythonExe" -ForegroundColor Red
    Write-Host "Tentando usar Python global..." -ForegroundColor Yellow
    python -m pip install --upgrade pip
    python -m pip install -r $requirementsPath
}

# Verificar se .env existe
if (!(Test-Path ".env")) {
    Write-Host ""
    Write-Host "⚠️  Arquivo .env não encontrado!" -ForegroundColor Yellow
    Write-Host "Copiando .env.example para .env..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host ""
    Write-Host "=====================================================" -ForegroundColor Red
    Write-Host "  IMPORTANTE: Configure sua GOOGLE_API_KEY no .env  " -ForegroundColor Red
    Write-Host "  1. Acesse: https://makersuite.google.com/app/apikey" -ForegroundColor Red
    Write-Host "  2. Crie uma chave API gratuita" -ForegroundColor Red
    Write-Host "  3. Cole no arquivo backend\.env" -ForegroundColor Red
    Write-Host "=====================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Pressione Enter depois de configurar a API key..." -ForegroundColor Yellow
    Read-Host
}

Write-Host "✓ Backend configurado com sucesso!" -ForegroundColor Green
Write-Host ""

# Voltar para raiz
Set-Location -Path $projectRoot

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Configurando Frontend (React)        " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Navegar para frontend
Set-Location -Path (Join-Path $projectRoot "frontend")

# Instalar dependências
Write-Host "Instalando dependências Node.js..." -ForegroundColor Yellow
npm install

Write-Host "✓ Frontend configurado com sucesso!" -ForegroundColor Green
Write-Host ""

# Voltar para raiz
Set-Location -Path $projectRoot

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   ✓ INSTALAÇÃO CONCLUÍDA!              " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Para iniciar o projeto, execute:" -ForegroundColor Cyan
Write-Host "  .\start.ps1" -ForegroundColor White
Write-Host ""
Write-Host "Ou manualmente em dois terminais:" -ForegroundColor Cyan
Write-Host "  Terminal 1 (Backend):" -ForegroundColor Yellow
Write-Host "    cd `"$projectRoot\backend`"" -ForegroundColor White
Write-Host "    & `"$venvPath\Scripts\Activate.ps1`"" -ForegroundColor White
Write-Host "    python app.py" -ForegroundColor White
Write-Host ""
Write-Host "  Terminal 2 (Frontend):" -ForegroundColor Yellow
Write-Host "    cd `"$projectRoot\frontend`"" -ForegroundColor White
Write-Host "    npm run dev" -ForegroundColor White
Write-Host ""
