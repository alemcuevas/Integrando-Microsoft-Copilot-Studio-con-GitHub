# export-solution.ps1
# Script para exportar la solución del agente de retail desde Power Platform

param(
    [Parameter(Mandatory=$true, HelpMessage="URL del entorno de Power Platform (ej: https://dev.crm.dynamics.com)")]
    [string]$EnvironmentUrl,
    
    [Parameter(Mandatory=$false, HelpMessage="Nombre de la solución a exportar")]
    [string]$SolutionName = "AgenteRetailAsistente",
    
    [Parameter(Mandatory=$false, HelpMessage="Exportar como solución administrada")]
    [switch]$Managed = $false,
    
    [Parameter(Mandatory=$false, HelpMessage="Directorio de salida")]
    [string]$OutputPath = "./solution"
)

# Colores para output
function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Cyan
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

# Banner
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "  Exportar Solución: $SolutionName" -ForegroundColor Magenta
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host ""

# Verificar que pac CLI esté instalado
Write-Info "Verificando Power Platform CLI..."
try {
    $pacVersion = pac --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Power Platform CLI encontrado: $pacVersion"
    }
} catch {
    Write-Error-Custom "Power Platform CLI no está instalado."
    Write-Host "Descárgalo desde: https://aka.ms/PowerPlatformCLI"
    exit 1
}

# Crear directorio de salida si no existe
if (-not (Test-Path $OutputPath)) {
    Write-Info "Creando directorio de salida: $OutputPath"
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    Write-Success "Directorio creado"
}

# Autenticar
Write-Info "Autenticando en el entorno: $EnvironmentUrl"
pac auth create --url $EnvironmentUrl

if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Error en la autenticación"
    exit 1
}
Write-Success "Autenticación exitosa"

# Exportar solución
$managedFlag = if ($Managed) { "true" } else { "false" }
$solutionType = if ($Managed) { "administrada" } else { "no administrada" }

Write-Info "Exportando solución $solutionType..."

$exportPath = Join-Path $OutputPath "$SolutionName.zip"

pac solution export `
    --name $SolutionName `
    --path $exportPath `
    --managed $managedFlag `
    --overwrite

if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Error al exportar la solución"
    exit 1
}
Write-Success "Solución exportada: $exportPath"

# Desempaquetar para control de versiones (solo si es no administrada)
if (-not $Managed) {
    Write-Info "Desempaquetando solución para control de versiones..."
    
    $unpackPath = Join-Path $OutputPath $SolutionName
    
    pac solution unpack `
        --zipfile $exportPath `
        --folder $unpackPath `
        --processCanvasApps `
        --allowDelete
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error-Custom "Error al desempaquetar la solución"
        exit 1
    }
    Write-Success "Solución desempaquetada en: $unpackPath"
}

# Resumen
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ¡Exportación Completada!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "Archivos generados:" -ForegroundColor Cyan
Write-Host "  📦 Solución: $exportPath" -ForegroundColor White
if (-not $Managed) {
    Write-Host "  📁 Fuente:   $unpackPath" -ForegroundColor White
}
Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Revisar los archivos exportados"
Write-Host "  2. Agregar a Git: git add $OutputPath"
Write-Host "  3. Commit: git commit -m 'Exportar solución v1.0'"
Write-Host "  4. Push: git push"
Write-Host ""
