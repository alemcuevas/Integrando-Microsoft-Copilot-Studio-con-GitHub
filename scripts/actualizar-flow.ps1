# actualizar-flow.ps1
# Script para actualizar un Cloud Flow desde la línea de comandos

param(
    [string]$FlowName = "EnviarEmailCotizacion"
)

Write-Host "🔄 Actualizando Cloud Flow desde la solución..." -ForegroundColor Cyan

# 1. Exportar la solución actual
Write-Host "`n📦 Paso 1: Exportando solución..." -ForegroundColor Yellow
$exportPath = "temp-flow-export"
New-Item -ItemType Directory -Force -Path $exportPath | Out-Null

pac solution export `
    --name "MyRetailAgent" `
    --path "$exportPath\MyRetailAgent.zip" `
    --managed false

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al exportar la solución" -ForegroundColor Red
    exit 1
}

# 2. Desempaquetar para ver el flow
Write-Host "`n📂 Paso 2: Desempaquetando solución..." -ForegroundColor Yellow
pac solution unpack `
    --zipfile "$exportPath\MyRetailAgent.zip" `
    --folder "$exportPath\unpacked" `
    --allowWrite `
    --allowDelete

# 3. Mostrar ubicación del flow
Write-Host "`n📍 Flow ubicado en:" -ForegroundColor Green
$flowFiles = Get-ChildItem -Path "$exportPath\unpacked\Workflows" -Filter "*$FlowName*" -Recurse
foreach ($file in $flowFiles) {
    Write-Host "   $($file.FullName)" -ForegroundColor Gray
}

Write-Host "`n" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "📝 CÓMO ACTUALIZAR EL FLOW:" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n🎯 OPCIÓN 1: Desde Power Automate (Recomendado)" -ForegroundColor White
Write-Host "   1. Abre: https://make.powerautomate.com" -ForegroundColor Gray
Write-Host "   2. My flows → EnviarEmailCotizacion" -ForegroundColor Gray
Write-Host "   3. Edit → Modificar acciones" -ForegroundColor Gray
Write-Host "   4. Save" -ForegroundColor Gray
Write-Host "   5. Vuelve aquí y ejecuta: .\scripts\export-solution.ps1" -ForegroundColor Gray

Write-Host "`n⚙️ OPCIÓN 2: Editar el archivo JSON directamente" -ForegroundColor White
Write-Host "   1. Edita los archivos en: $exportPath\unpacked\Workflows\" -ForegroundColor Gray
Write-Host "   2. Empaqueta la solución:" -ForegroundColor Gray
Write-Host "      pac solution pack --folder $exportPath\unpacked --zipfile MyRetailAgent.zip" -ForegroundColor DarkGray
Write-Host "   3. Importa la solución:" -ForegroundColor Gray
Write-Host "      pac solution import --path MyRetailAgent.zip" -ForegroundColor DarkGray

Write-Host "`n🔍 OPCIÓN 3: Ver definición del flow" -ForegroundColor White

# Buscar y mostrar el contenido del flow
$workflowFiles = Get-ChildItem -Path "$exportPath\unpacked\Workflows" -Filter "*.json" -Recurse
foreach ($wf in $workflowFiles) {
    if ($wf.Name -like "*$FlowName*") {
        Write-Host "`n   📄 Archivo: $($wf.Name)" -ForegroundColor Cyan
        $content = Get-Content $wf.FullName -Raw | ConvertFrom-Json
        
        Write-Host "   • Tipo: $($content.type)" -ForegroundColor Gray
        Write-Host "   • Estado: $($content.statecode)" -ForegroundColor Gray
        
        if ($content.clientdata) {
            $clientData = $content.clientdata | ConvertFrom-Json
            Write-Host "   • Propiedades:" -ForegroundColor Gray
            Write-Host "     - Definición disponible en el archivo JSON" -ForegroundColor DarkGray
        }
    }
}

Write-Host "`n" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "🚀 WORKFLOW RECOMENDADO:" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n1. Edita el flow en Power Automate UI (más fácil y seguro)" -ForegroundColor White
Write-Host "2. Exporta la solución:" -ForegroundColor White
Write-Host "   .\scripts\export-solution.ps1" -ForegroundColor Gray
Write-Host "3. Desempaqueta a 'solution/':" -ForegroundColor White
Write-Host "   pac solution unpack --zipfile MyRetailAgent.zip --folder solution --allowWrite --allowDelete" -ForegroundColor Gray
Write-Host "4. Commit a git:" -ForegroundColor White
Write-Host "   git add ." -ForegroundColor Gray
Write-Host "   git commit -m 'feat: actualizar flow EnviarEmailCotizacion'" -ForegroundColor Gray
Write-Host "   git push origin main" -ForegroundColor Gray

Write-Host "`n💡 TIP: Los flows se editan mejor desde la UI de Power Automate." -ForegroundColor Yellow
Write-Host "    El JSON es complejo y propenso a errores si se edita manualmente." -ForegroundColor Yellow

Write-Host "`n✨ Presiona cualquier tecla para abrir Power Automate..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

# Abrir Power Automate
Start-Process "https://make.powerautomate.com/environments/e6a705ce-a278-4500-96ec-ae709758249d/flows"

Write-Host "`n✅ Script completado. Los archivos están en: $exportPath" -ForegroundColor Green
