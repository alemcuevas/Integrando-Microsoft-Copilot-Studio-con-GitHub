# Script para preparar el proyecto para Source Control
# Ejecutar antes de conectar con Copilot Studio

Write-Host "🧹 Limpiando archivos temporales..." -ForegroundColor Cyan

# Eliminar carpetas temporales
$foldersToRemove = @(
    ".\temp-export",
    ".\solution-export"
)

foreach ($folder in $foldersToRemove) {
    if (Test-Path $folder) {
        Remove-Item -Path $folder -Recurse -Force
        Write-Host "✅ Eliminado: $folder" -ForegroundColor Green
    }
}

# Eliminar archivos .zip
$zipFiles = Get-ChildItem -Path . -Filter "*.zip" -Recurse
foreach ($zip in $zipFiles) {
    Remove-Item -Path $zip.FullName -Force
    Write-Host "✅ Eliminado: $($zip.Name)" -ForegroundColor Green
}

Write-Host "`n📦 Verificando estructura de la solución..." -ForegroundColor Cyan

# Verificar que existe la carpeta solution/
if (Test-Path ".\solution") {
    $botComponents = Get-ChildItem -Path ".\solution\botcomponents\" -Directory
    $workflows = Get-ChildItem -Path ".\solution\Workflows\" -File
    
    Write-Host "✅ Solución encontrada:" -ForegroundColor Green
    Write-Host "   - Bot components: $($botComponents.Count)" -ForegroundColor White
    Write-Host "   - Workflows: $($workflows.Count)" -ForegroundColor White
} else {
    Write-Host "❌ Carpeta solution/ no encontrada" -ForegroundColor Red
    Write-Host "   Ejecuta primero: pac solution unpack..." -ForegroundColor Yellow
    exit 1
}

Write-Host "`n📝 Verificando archivos de documentación..." -ForegroundColor Cyan

$requiredDocs = @(
    "README.md",
    "SOURCE-CONTROL.md",
    ".gitignore"
)

$missingDocs = @()
foreach ($doc in $requiredDocs) {
    if (Test-Path $doc) {
        Write-Host "✅ $doc" -ForegroundColor Green
    } else {
        Write-Host "❌ $doc faltante" -ForegroundColor Red
        $missingDocs += $doc
    }
}

if ($missingDocs.Count -gt 0) {
    Write-Host "`n⚠️  Archivos faltantes: $($missingDocs -join ', ')" -ForegroundColor Yellow
}

Write-Host "`n🔍 Estado de Git..." -ForegroundColor Cyan
git status --short

Write-Host "`n✨ Preparación completada" -ForegroundColor Green
Write-Host "`n📋 Próximos pasos:" -ForegroundColor Cyan
Write-Host "   1. Revisar cambios: git status" -ForegroundColor White
Write-Host "   2. Agregar archivos: git add ." -ForegroundColor White
Write-Host "   3. Commit: git commit -m 'feat: preparar para source control'" -ForegroundColor White
Write-Host "   4. Push: git push origin main" -ForegroundColor White
Write-Host "   5. Conectar Copilot Studio con GitHub (ver SOURCE-CONTROL.md)" -ForegroundColor White
