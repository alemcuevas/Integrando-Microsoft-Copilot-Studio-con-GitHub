# import-solution.ps1
# Script para importar la solución del agente de retail a Power Platform

param(
    [Parameter(Mandatory=$true, HelpMessage="URL del entorno destino (ej: https://test.crm.dynamics.com)")]
    [string]$EnvironmentUrl,
    
    [Parameter(Mandatory=$false, HelpMessage="Nombre de la solución a importar")]
    [string]$SolutionName = "AgenteRetailAsistente",
    
    [Parameter(Mandatory=$false, HelpMessage="Directorio donde está la solución")]
    [string]$SolutionPath = "./solution",
    
    [Parameter(Mandatory=$false, HelpMessage="Importar de forma asíncrona")]
    [switch]$Async = $true,
    
    [Parameter(Mandatory=$false, HelpMessage="Publicar cambios después de importar")]
    [switch]$PublishChanges = $true,
    
    [Parameter(Mandatory=$false, HelpMessage="Empaquetar desde fuente antes de importar")]
    [switch]$PackFromSource = $false
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

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

# Banner
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "  Importar Solución: $SolutionName" -ForegroundColor Magenta
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

# Determinar ruta del archivo ZIP
$zipPath = Join-Path $SolutionPath "$SolutionName.zip"
$sourcePath = Join-Path $SolutionPath $SolutionName

# Si se solicita empaquetar desde fuente
if ($PackFromSource) {
    if (-not (Test-Path $sourcePath)) {
        Write-Error-Custom "No se encuentra la carpeta de fuente: $sourcePath"
        exit 1
    }
    
    Write-Info "Empaquetando solución desde: $sourcePath"
    
    pac solution pack `
        --zipfile $zipPath `
        --folder $sourcePath `
        --processCanvasApps
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error-Custom "Error al empaquetar la solución"
        exit 1
    }
    Write-Success "Solución empaquetada"
}

# Verificar que existe el archivo ZIP
if (-not (Test-Path $zipPath)) {
    Write-Error-Custom "No se encuentra el archivo de solución: $zipPath"
    Write-Host ""
    Write-Host "Opciones:" -ForegroundColor Yellow
    Write-Host "  1. Usa -PackFromSource para empaquetar desde la fuente"
    Write-Host "  2. Verifica que el archivo ZIP exista en: $SolutionPath"
    exit 1
}

Write-Success "Archivo de solución encontrado: $zipPath"

# Autenticar
Write-Info "Autenticando en el entorno: $EnvironmentUrl"
pac auth create --url $EnvironmentUrl

if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Error en la autenticación"
    exit 1
}
Write-Success "Autenticación exitosa"

# Construir comando de importación
$importArgs = @(
    "solution", "import",
    "--path", $zipPath
)

if ($Async) {
    $importArgs += "--async"
}

if ($PublishChanges) {
    $importArgs += "--publish-changes"
}

# Importar solución
Write-Info "Importando solución..."
Write-Warning-Custom "Esto puede tardar varios minutos..."

& pac $importArgs

if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Error al importar la solución"
    Write-Host ""
    Write-Host "Causas comunes:" -ForegroundColor Yellow
    Write-Host "  • Dependencias faltantes"
    Write-Host "  • Permisos insuficientes"
    Write-Host "  • Solución ya existe"
    Write-Host "  • Conexiones no configuradas"
    exit 1
}

Write-Success "Importación iniciada correctamente"

# Si es asíncrona, mostrar mensaje
if ($Async) {
    Write-Host ""
    Write-Info "La importación se está ejecutando de forma asíncrona"
    Write-Host "Puedes verificar el progreso en:"
    Write-Host "  $EnvironmentUrl" -ForegroundColor Cyan
    Write-Host "  Soluciones > Historial de importación"
}

# Resumen
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ¡Importación Iniciada!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "Detalles:" -ForegroundColor Cyan
Write-Host "  📦 Solución:     $SolutionName" -ForegroundColor White
Write-Host "  🌐 Entorno:      $EnvironmentUrl" -ForegroundColor White
Write-Host "  ⚙️  Asíncrono:    $Async" -ForegroundColor White
Write-Host "  📢 Publicar:     $PublishChanges" -ForegroundColor White
Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Verificar que la importación se completó exitosamente"
Write-Host "  2. Configurar las conexiones necesarias en el bot"
Write-Host "  3. Probar el agente en Copilot Studio"
Write-Host "  4. Publicar el bot en los canales deseados"
Write-Host ""
