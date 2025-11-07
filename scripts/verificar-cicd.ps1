# verificar-cicd.ps1
# Script para verificar la configuración de CI/CD

Write-Host "🔍 Verificando configuración de CI/CD" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor DarkGray

$errores = 0
$advertencias = 0

# 1. Verificar archivos del pipeline
Write-Host "📁 Verificando archivos del pipeline..." -ForegroundColor Yellow

$pipelineFile = ".github\workflows\deploy-copilot-agent.yml"
if (Test-Path $pipelineFile) {
    Write-Host "   ✅ Pipeline encontrado: $pipelineFile" -ForegroundColor Green
} else {
    Write-Host "   ❌ Pipeline no encontrado: $pipelineFile" -ForegroundColor Red
    $errores++
}

# 2. Verificar estructura de carpetas
Write-Host "`n📂 Verificando estructura de carpetas..." -ForegroundColor Yellow

$carpetasRequeridas = @("solution", "templates", "scripts", ".github\workflows")
foreach ($carpeta in $carpetasRequeridas) {
    if (Test-Path $carpeta) {
        Write-Host "   ✅ Carpeta existe: $carpeta" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Carpeta no existe: $carpeta" -ForegroundColor Red
        $errores++
    }
}

# 3. Verificar si Git está configurado
Write-Host "`n🔧 Verificando configuración de Git..." -ForegroundColor Yellow

try {
    $gitRemote = git remote get-url origin 2>$null
    if ($gitRemote) {
        Write-Host "   ✅ Repositorio Git configurado: $gitRemote" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  No hay remote configurado" -ForegroundColor Yellow
        $advertencias++
    }
} catch {
    Write-Host "   ❌ Git no está instalado o configurado" -ForegroundColor Red
    $errores++
}

# 4. Verificar solución empaquetable
Write-Host "`n📦 Verificando que la solución se puede empaquetar..." -ForegroundColor Yellow

try {
    # Intentar empaquetar (dry-run simulado)
    if (Test-Path "solution\Other\Solution.xml") {
        Write-Host "   ✅ Solution.xml encontrado" -ForegroundColor Green
        
        # Leer el nombre de la solución
        [xml]$solutionXml = Get-Content "solution\Other\Solution.xml"
        $solutionName = $solutionXml.ImportExportXml.SolutionManifest.UniqueName
        Write-Host "   ✅ Solución: $solutionName" -ForegroundColor Green
    } else {
        Write-Host "   ❌ solution\Other\Solution.xml no encontrado" -ForegroundColor Red
        $errores++
    }
} catch {
    Write-Host "   ❌ Error al leer la solución" -ForegroundColor Red
    $errores++
}

# 5. Verificar Power Platform CLI
Write-Host "`n🔧 Verificando Power Platform CLI..." -ForegroundColor Yellow

try {
    $pacVersion = pac --version 2>$null
    if ($pacVersion) {
        Write-Host "   ✅ Power Platform CLI instalado" -ForegroundColor Green
        Write-Host "      $pacVersion" -ForegroundColor Gray
    } else {
        Write-Host "   ❌ Power Platform CLI no instalado" -ForegroundColor Red
        $errores++
    }
} catch {
    Write-Host "   ❌ Power Platform CLI no instalado" -ForegroundColor Red
    $errores++
}

# 6. Verificar Azure CLI (para crear Service Principal)
Write-Host "`n☁️  Verificando Azure CLI..." -ForegroundColor Yellow

try {
    $azVersion = az version --output json 2>$null | ConvertFrom-Json
    if ($azVersion) {
        Write-Host "   ✅ Azure CLI instalado: $($azVersion.'azure-cli')" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Azure CLI no instalado (necesario para crear Service Principal)" -ForegroundColor Yellow
        $advertencias++
    }
} catch {
    Write-Host "   ⚠️  Azure CLI no instalado (necesario para crear Service Principal)" -ForegroundColor Yellow
    $advertencias++
}

# 7. Verificar autenticación actual
Write-Host "`n🔐 Verificando autenticación en Power Platform..." -ForegroundColor Yellow

try {
    $authList = pac auth list 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Autenticación configurada" -ForegroundColor Green
        
        # Verificar ambiente activo
        $ambienteActivo = pac org who --json 2>$null | ConvertFrom-Json
        if ($ambienteActivo) {
            Write-Host "   ✅ Ambiente activo: $($ambienteActivo.FriendlyName)" -ForegroundColor Green
        }
    } else {
        Write-Host "   ⚠️  No hay autenticación configurada (solo necesario para pruebas locales)" -ForegroundColor Yellow
        $advertencias++
    }
} catch {
    Write-Host "   ⚠️  No hay autenticación configurada" -ForegroundColor Yellow
    $advertencias++
}

# 8. Verificar que hay commits recientes
Write-Host "`n📝 Verificando commits..." -ForegroundColor Yellow

try {
    $commits = git log --oneline -5 2>$null
    if ($commits) {
        Write-Host "   ✅ Commits encontrados:" -ForegroundColor Green
        $commits | ForEach-Object {
            Write-Host "      $_" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ⚠️  No hay commits" -ForegroundColor Yellow
        $advertencias++
    }
} catch {
    Write-Host "   ⚠️  Error al leer commits" -ForegroundColor Yellow
    $advertencias++
}

# 9. Verificar GitHub Actions habilitado
Write-Host "`n🚀 Verificando configuración de GitHub Actions..." -ForegroundColor Yellow

if (Test-Path ".github\workflows") {
    $workflows = Get-ChildItem ".github\workflows" -Filter "*.yml"
    if ($workflows.Count -gt 0) {
        Write-Host "   ✅ $($workflows.Count) workflow(s) encontrado(s):" -ForegroundColor Green
        foreach ($wf in $workflows) {
            Write-Host "      - $($wf.Name)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ⚠️  No hay workflows configurados" -ForegroundColor Yellow
        $advertencias++
    }
}

# Resumen
Write-Host "`n" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "📊 RESUMEN" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

if ($errores -eq 0 -and $advertencias -eq 0) {
    Write-Host "`n🎉 ¡Todo listo para CI/CD!" -ForegroundColor Green
    Write-Host "`n📋 Próximos pasos:" -ForegroundColor Cyan
    Write-Host "   1. Crea el Service Principal:" -ForegroundColor White
    Write-Host "      .\scripts\crear-service-principal.ps1" -ForegroundColor Gray
    Write-Host "   2. Configura los GitHub Secrets" -ForegroundColor White
    Write-Host "   3. Crea los GitHub Environments (development, test, production)" -ForegroundColor White
    Write-Host "   4. Haz push a main para activar el pipeline" -ForegroundColor White
} elseif ($errores -eq 0) {
    Write-Host "`n✅ Configuración básica OK" -ForegroundColor Green
    Write-Host "⚠️  $advertencias advertencia(s) encontrada(s)" -ForegroundColor Yellow
    Write-Host "`nPuedes continuar con la configuración de CI/CD" -ForegroundColor White
} else {
    Write-Host "`n❌ $errores error(es) encontrado(s)" -ForegroundColor Red
    Write-Host "⚠️  $advertencias advertencia(s) encontrada(s)" -ForegroundColor Yellow
    Write-Host "`nCorrige los errores antes de continuar" -ForegroundColor White
}

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "📚 DOCUMENTACIÓN" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n📖 Lee la documentación completa en: CI-CD.md" -ForegroundColor White
Write-Host "🔗 Power Platform Actions: https://github.com/microsoft/powerplatform-actions" -ForegroundColor Gray
Write-Host "🔗 GitHub Actions: https://docs.github.com/actions" -ForegroundColor Gray

Write-Host "`n"
