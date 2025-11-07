# Script: Modificar Template con Contenido del Agente Retail
# Descripción: Toma el template base y lo adapta con los topics del agente retail

param(
    [Parameter(Mandatory=$false)]
    [string]$BaseTemplate = "./templates/base-template.yaml",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputTemplate = "./templates/retail-agent-template.yaml"
)

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Modificación de Template" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que existe el template base
if (-not (Test-Path $BaseTemplate)) {
    Write-Host "✗ No se encontró el template base: $BaseTemplate" -ForegroundColor Red
    Write-Host ""
    Write-Host "Ejecuta primero: .\scripts\2-extraer-template.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "Template base encontrado: $BaseTemplate" -ForegroundColor Green
Write-Host ""

# Leer el template base
Write-Host "Leyendo template base..." -ForegroundColor Cyan
$templateContent = Get-Content $BaseTemplate -Raw

Write-Host "✓ Template cargado ($($templateContent.Length) caracteres)" -ForegroundColor Green
Write-Host ""

# Mostrar información sobre la estructura
Write-Host "ANÁLISIS DEL TEMPLATE BASE:" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Gray

# Contar líneas
$lineCount = ($templateContent -split "`n").Count
Write-Host "Total de líneas: $lineCount" -ForegroundColor Gray

# Buscar secciones clave
$sections = @(
    @{Name="templateName"; Pattern="templateName:"},
    @{Name="templateVersion"; Pattern="templateVersion:"},
    @{Name="topics"; Pattern="topics:"},
    @{Name="entities"; Pattern="entities:"},
    @{Name="variables"; Pattern="variables:"},
    @{Name="triggers"; Pattern="triggers:"},
    @{Name="actions"; Pattern="actions:"}
)

foreach ($section in $sections) {
    if ($templateContent -match $section.Pattern) {
        Write-Host "  ✓ Sección encontrada: $($section.Name)" -ForegroundColor Green
    } else {
        Write-Host "  - Sección no encontrada: $($section.Name)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "============================" -ForegroundColor Gray
Write-Host ""

# Por ahora, solo copiamos el template para análisis manual
Write-Host "Copiando template base a: $OutputTemplate" -ForegroundColor Cyan
Copy-Item $BaseTemplate $OutputTemplate -Force

Write-Host "✓ Template copiado" -ForegroundColor Green
Write-Host ""

# Mostrar guía de próximos pasos
Write-Host "PRÓXIMOS PASOS MANUALES:" -ForegroundColor Yellow
Write-Host "========================" -ForegroundColor Gray
Write-Host ""
Write-Host "1. Abre el archivo: $OutputTemplate" -ForegroundColor White
Write-Host ""
Write-Host "2. Revisa la estructura del template YAML extraído" -ForegroundColor White
Write-Host ""
Write-Host "3. Compara con nuestros archivos JSON en:" -ForegroundColor White
Write-Host "   - topics/*.topic.json" -ForegroundColor Gray
Write-Host "   - entities/*.entity.json" -ForegroundColor Gray
Write-Host "   - variables/global-variables.json" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Adapta el YAML agregando:" -ForegroundColor White
Write-Host "   - Topics del agente retail (9 topics)" -ForegroundColor Gray
Write-Host "   - Entities (ProductCategory, StoreLocation)" -ForegroundColor Gray
Write-Host "   - Variables globales" -ForegroundColor Gray
Write-Host ""
Write-Host "5. Una vez modificado, ejecuta:" -ForegroundColor White
Write-Host "   .\scripts\4-crear-agente-retail.ps1" -ForegroundColor Yellow
Write-Host ""

# Abrir archivo en VS Code si está disponible
Write-Host "¿Abrir template en VS Code? (S/N): " -ForegroundColor Cyan -NoNewline
$response = Read-Host

if ($response -eq 'S' -or $response -eq 's' -or $response -eq 'Y' -or $response -eq 'y') {
    Write-Host ""
    Write-Host "Abriendo en VS Code..." -ForegroundColor Cyan
    code $OutputTemplate
    
    # También abrir un topic JSON de referencia
    $sampleTopic = "./topics/greeting.topic.json"
    if (Test-Path $sampleTopic) {
        code $sampleTopic
        Write-Host "✓ Abriendo topic de referencia: $sampleTopic" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "NOTA: Este paso requiere edición manual porque el formato YAML" -ForegroundColor Yellow
Write-Host "      de Copilot Studio no está completamente documentado." -ForegroundColor Yellow
Write-Host "      El template extraído nos mostrará el formato correcto." -ForegroundColor Yellow
