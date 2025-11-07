# Script: Crear Agente Retail desde Template
# Descripción: Crea el agente de retail completo usando el template modificado

param(
    [Parameter(Mandatory=$false)]
    [string]$TemplateFile = "./templates/retail-agent-template.yaml",
    
    [Parameter(Mandatory=$false)]
    [string]$SchemaName = "miemp_agenteRetail",
    
    [Parameter(Mandatory=$false)]
    [string]$DisplayName = "Agente de Retail - Asistente de Ventas",
    
    [Parameter(Mandatory=$false)]
    [string]$Solution = "MyRetailAgent"
)

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Creación de Agente Retail" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que existe el template
if (-not (Test-Path $TemplateFile)) {
    Write-Host "✗ No se encontró el template: $TemplateFile" -ForegroundColor Red
    Write-Host ""
    Write-Host "Ejecuta primero:" -ForegroundColor Yellow
    Write-Host "  1. .\scripts\2-extraer-template.ps1" -ForegroundColor Yellow
    Write-Host "  2. .\scripts\3-modificar-template.ps1" -ForegroundColor Yellow
    Write-Host "  3. Modifica manualmente el template YAML" -ForegroundColor Yellow
    exit 1
}

Write-Host "Configuración:" -ForegroundColor Cyan
Write-Host "  Template:     $TemplateFile" -ForegroundColor Gray
Write-Host "  Schema Name:  $SchemaName" -ForegroundColor Gray
Write-Host "  Display Name: $DisplayName" -ForegroundColor Gray
Write-Host "  Solution:     $Solution" -ForegroundColor Gray
Write-Host ""

# Mostrar preview del template
Write-Host "Vista previa del template:" -ForegroundColor Cyan
Write-Host "----------------------------" -ForegroundColor Gray
Get-Content $TemplateFile -TotalCount 20
Write-Host "..." -ForegroundColor Gray
Write-Host ""

# Confirmar antes de crear
Write-Host "¿Crear el agente con esta configuración? (S/N): " -ForegroundColor Yellow -NoNewline
$confirmation = Read-Host

if ($confirmation -ne 'S' -and $confirmation -ne 's' -and $confirmation -ne 'Y' -and $confirmation -ne 'y') {
    Write-Host ""
    Write-Host "Operación cancelada por el usuario." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Creando agente..." -ForegroundColor Cyan
Write-Host ""

# Crear el agente
pac copilot create `
    --schemaName $SchemaName `
    --templateFileName $TemplateFile `
    --displayName $DisplayName `
    --solution $Solution

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓ ¡Agente creado exitosamente!" -ForegroundColor Green
    Write-Host ""
    
    # Listar agentes
    Write-Host "Agentes en el entorno:" -ForegroundColor Cyan
    pac copilot list
    
    Write-Host ""
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host "  PRÓXIMOS PASOS" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Verificar el agente en Copilot Studio:" -ForegroundColor White
    Write-Host "   https://copilotstudio.microsoft.com" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Completar configuraciones faltantes (si es necesario)" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Publicar el agente:" -ForegroundColor White
    Write-Host "   pac copilot publish --bot $SchemaName" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "4. Exportar como solución:" -ForegroundColor White
    Write-Host "   .\scripts\export-solution.ps1" -ForegroundColor Yellow
    Write-Host ""
    
} else {
    Write-Host ""
    Write-Host "✗ Error al crear el agente" -ForegroundColor Red
    Write-Host ""
    Write-Host "Posibles causas:" -ForegroundColor Yellow
    Write-Host "  - El Schema Name ya existe" -ForegroundColor Yellow
    Write-Host "  - El formato del template YAML es incorrecto" -ForegroundColor Yellow
    Write-Host "  - La solución '$Solution' no existe" -ForegroundColor Yellow
    Write-Host "  - No tienes permisos suficientes" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Revisa el error arriba y corrige el template si es necesario." -ForegroundColor White
    exit 1
}
