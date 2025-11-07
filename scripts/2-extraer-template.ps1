# Script: Extraer Template YAML de Agente Base
# Descripción: Extrae el template del agente TemplateBase para usarlo como referencia

param(
    [Parameter(Mandatory=$false)]
    [string]$BotName = "TemplateBase",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "./templates/base-template.yaml"
)

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Extracción de Template YAML" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Crear directorio templates si no existe
$templatesDir = Split-Path -Path $OutputPath -Parent
if (-not (Test-Path $templatesDir)) {
    Write-Host "Creando directorio: $templatesDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $templatesDir -Force | Out-Null
}

# Listar agentes disponibles
Write-Host "Agentes disponibles en el entorno:" -ForegroundColor Cyan
pac copilot list

Write-Host ""
Write-Host "Buscando agente '$BotName'..." -ForegroundColor Cyan

# Obtener lista de agentes y buscar el que coincida
$copilotListOutput = pac copilot list --json 2>&1 | Out-String

if ($copilotListOutput -match '"DisplayName"\s*:\s*"TemplateBase"') {
    Write-Host "✓ Agente encontrado!" -ForegroundColor Green
    
    # Extraer el schema name o ID del output
    # Nota: Necesitaremos el schema name real del agente
    Write-Host ""
    Write-Host "NOTA: Necesitas el Schema Name del agente." -ForegroundColor Yellow
    Write-Host "Busca en la lista arriba el valor de 'UniqueName' o 'SchemaName'" -ForegroundColor Yellow
    Write-Host ""
    
    $schemaName = Read-Host "Ingresa el Schema Name del agente TemplateBase (ejemplo: cr123_templatebase)"
    
    if ([string]::IsNullOrWhiteSpace($schemaName)) {
        Write-Host "✗ Schema Name requerido. Abortando." -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    Write-Host "Extrayendo template del agente: $schemaName" -ForegroundColor Cyan
    Write-Host "Archivo de salida: $OutputPath" -ForegroundColor Gray
    Write-Host ""
    
    # Extraer template
    pac copilot extract-template `
        --bot $schemaName `
        --templateFileName $OutputPath `
        --overwrite `
        --templateName "RetailAgentTemplate" `
        --templateVersion "1.0.0"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✓ Template extraído exitosamente!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Archivo generado: $OutputPath" -ForegroundColor Green
        
        # Mostrar primeras líneas del archivo
        if (Test-Path $OutputPath) {
            Write-Host ""
            Write-Host "Vista previa del template:" -ForegroundColor Cyan
            Write-Host "----------------------------" -ForegroundColor Gray
            Get-Content $OutputPath -TotalCount 30
            Write-Host "..." -ForegroundColor Gray
            Write-Host ""
            
            $fileInfo = Get-Item $OutputPath
            Write-Host "Tamaño del archivo: $($fileInfo.Length) bytes" -ForegroundColor Gray
            Write-Host ""
            
            Write-Host "➡️  Siguiente paso:" -ForegroundColor Cyan
            Write-Host "   Revisa el archivo generado y ejecuta:" -ForegroundColor White
            Write-Host "   .\scripts\3-modificar-template.ps1" -ForegroundColor Yellow
        }
    } else {
        Write-Host ""
        Write-Host "✗ Error al extraer el template" -ForegroundColor Red
        Write-Host "Verifica que:" -ForegroundColor Yellow
        Write-Host "  - El agente está publicado" -ForegroundColor Yellow
        Write-Host "  - El Schema Name es correcto" -ForegroundColor Yellow
        Write-Host "  - Tienes permisos en el entorno" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "✗ No se encontró el agente '$BotName'" -ForegroundColor Red
    Write-Host ""
    Write-Host "Asegúrate de:" -ForegroundColor Yellow
    Write-Host "  1. Haber creado el agente TemplateBase" -ForegroundColor Yellow
    Write-Host "  2. Haberlo publicado" -ForegroundColor Yellow
    Write-Host "  3. Estar conectado al entorno correcto" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Ejecuta primero: .\scripts\1-crear-agente-base.md" -ForegroundColor Cyan
    exit 1
}
