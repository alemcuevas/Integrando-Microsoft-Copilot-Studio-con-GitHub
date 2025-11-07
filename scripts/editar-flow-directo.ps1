# editar-flow-directo.ps1
# Script para editar el Cloud Flow directamente desde JSON

param(
    [string]$NuevoEmailDestino = "",
    [string]$NuevoMensaje = ""
)

Write-Host "🔧 Editor de Cloud Flow - EnviarEmailCotizacion" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor DarkGray

# Verificar si existe la carpeta solution/
$flowPath = "solution\Workflows\EnviarEmailCotizacion-ADD36A2B-9BBB-F011-BBD2-000D3A36E147.json"

if (-not (Test-Path $flowPath)) {
    Write-Host "❌ No se encuentra el flow en: $flowPath" -ForegroundColor Red
    Write-Host "`n💡 Ejecuta primero:" -ForegroundColor Yellow
    Write-Host "   .\scripts\export-solution.ps1" -ForegroundColor Gray
    Write-Host "   pac solution unpack --zipfile MyRetailAgent.zip --folder solution --allowWrite --allowDelete`n" -ForegroundColor Gray
    exit 1
}

# Leer el flow actual
Write-Host "📖 Leyendo flow actual..." -ForegroundColor Yellow
$flowContent = Get-Content $flowPath -Raw | ConvertFrom-Json

# Mostrar configuración actual
$currentEmail = $flowContent.properties.definition.actions.'Send_an_email_notification_(V3)'.inputs.parameters.'request/to'
$currentSubject = $flowContent.properties.definition.actions.'Send_an_email_notification_(V3)'.inputs.parameters.'request/subject'

Write-Host "✅ Flow cargado exitosamente`n" -ForegroundColor Green

Write-Host "📧 Configuración actual:" -ForegroundColor Cyan
Write-Host "   Email destino: $currentEmail" -ForegroundColor Gray
Write-Host "   Asunto: $currentSubject" -ForegroundColor Gray

Write-Host "`n" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "🎯 OPCIONES DE EDICIÓN" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n1️⃣  Cambiar email de destino" -ForegroundColor White
Write-Host "2️⃣  Cambiar mensaje de confirmación" -ForegroundColor White
Write-Host "3️⃣  Ver estructura completa del flow" -ForegroundColor White
Write-Host "4️⃣  Aplicar cambios y empaquetar" -ForegroundColor White
Write-Host "0️⃣  Salir`n" -ForegroundColor White

# Función para cambiar email
function Cambiar-Email {
    Write-Host "`n📧 Cambiar email de destino" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host "Actual: $currentEmail`n" -ForegroundColor Gray
    
    $nuevoEmail = Read-Host "Nuevo email (o Enter para cancelar)"
    
    if ($nuevoEmail -and $nuevoEmail -match "^[^@]+@[^@]+\.[^@]+$") {
        $flowContent.properties.definition.actions.'Send_an_email_notification_(V3)'.inputs.parameters.'request/to' = $nuevoEmail
        
        # Guardar cambios
        $flowContent | ConvertTo-Json -Depth 20 | Set-Content $flowPath -Encoding UTF8
        
        Write-Host "`n✅ Email actualizado a: $nuevoEmail" -ForegroundColor Green
        
        return $true
    } elseif ($nuevoEmail) {
        Write-Host "`n❌ Email inválido" -ForegroundColor Red
        return $false
    }
    
    Write-Host "`n⚠️  Operación cancelada" -ForegroundColor Yellow
    return $false
}

# Función para cambiar mensaje
function Cambiar-Mensaje {
    Write-Host "`n💬 Cambiar mensaje de confirmación" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    
    $mensajeActual = $flowContent.properties.definition.actions.'Respond_to_Copilot'.inputs.body.confirmationmessage
    Write-Host "Actual: $mensajeActual`n" -ForegroundColor Gray
    
    $nuevoMensaje = Read-Host "Nuevo mensaje (o Enter para cancelar)"
    
    if ($nuevoMensaje) {
        $flowContent.properties.definition.actions.'Respond_to_Copilot'.inputs.body.confirmationmessage = $nuevoMensaje
        
        # Guardar cambios
        $flowContent | ConvertTo-Json -Depth 20 | Set-Content $flowPath -Encoding UTF8
        
        Write-Host "`n✅ Mensaje actualizado a: $nuevoMensaje" -ForegroundColor Green
        
        return $true
    }
    
    Write-Host "`n⚠️  Operación cancelada" -ForegroundColor Yellow
    return $false
}

# Función para ver estructura
function Ver-Estructura {
    Write-Host "`n📋 Estructura del Flow" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    
    Write-Host "`n🔹 Inputs (Parámetros de entrada):" -ForegroundColor Yellow
    $flowContent.properties.definition.triggers.manual.inputs.schema.properties.PSObject.Properties | ForEach-Object {
        $param = $_.Value
        Write-Host "   • $($_.Name) - $($param.title) ($($param.description))" -ForegroundColor Gray
    }
    
    Write-Host "`n🔹 Actions (Acciones del flow):" -ForegroundColor Yellow
    $flowContent.properties.definition.actions.PSObject.Properties | ForEach-Object {
        Write-Host "   • $($_.Name) - Tipo: $($_.Value.type)" -ForegroundColor Gray
    }
    
    Write-Host "`n🔹 Outputs (Salidas):" -ForegroundColor Yellow
    $flowContent.properties.definition.actions.'Respond_to_Copilot'.inputs.body.PSObject.Properties | ForEach-Object {
        Write-Host "   • $($_.Name): $($_.Value)" -ForegroundColor Gray
    }
    
    Write-Host "`n📄 Archivo JSON completo en: $flowPath" -ForegroundColor Cyan
    Write-Host "`nPresiona Enter para continuar..."
    Read-Host
}

# Función para empaquetar y deployar
function Aplicar-Cambios {
    Write-Host "`n📦 Empaquetando y desplegando cambios..." -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    
    # 1. Empaquetar
    Write-Host "`n1️⃣  Empaquetando solución..." -ForegroundColor Yellow
    pac solution pack `
        --folder solution `
        --zipfile MyRetailAgent-updated.zip `
        --processCanvasApps
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "`n❌ Error al empaquetar la solución" -ForegroundColor Red
        return $false
    }
    
    # 2. Importar
    Write-Host "`n2️⃣  Importando solución actualizada..." -ForegroundColor Yellow
    pac solution import `
        --path MyRetailAgent-updated.zip `
        --force-overwrite
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "`n❌ Error al importar la solución" -ForegroundColor Red
        return $false
    }
    
    Write-Host "`n✅ Cambios aplicados exitosamente!" -ForegroundColor Green
    Write-Host "`n💡 No olvides hacer commit de los cambios:" -ForegroundColor Yellow
    Write-Host "   git add solution/" -ForegroundColor Gray
    Write-Host "   git commit -m 'feat: actualizar configuración de flow'" -ForegroundColor Gray
    Write-Host "   git push origin main" -ForegroundColor Gray
    
    return $true
}

# Menú interactivo
$cambiosRealizados = $false

while ($true) {
    $opcion = Read-Host "`nSelecciona una opción"
    
    switch ($opcion) {
        "1" {
            if (Cambiar-Email) {
                $cambiosRealizados = $true
            }
        }
        "2" {
            if (Cambiar-Mensaje) {
                $cambiosRealizados = $true
            }
        }
        "3" {
            Ver-Estructura
        }
        "4" {
            if ($cambiosRealizados) {
                Aplicar-Cambios
                break
            } else {
                Write-Host "`n⚠️  No hay cambios pendientes" -ForegroundColor Yellow
            }
        }
        "0" {
            if ($cambiosRealizados) {
                $confirmar = Read-Host "`n⚠️  Tienes cambios sin aplicar. ¿Salir de todos modos? (s/n)"
                if ($confirmar -eq "s") {
                    Write-Host "`n👋 Hasta luego!" -ForegroundColor Cyan
                    exit 0
                }
            } else {
                Write-Host "`n👋 Hasta luego!" -ForegroundColor Cyan
                exit 0
            }
        }
        default {
            Write-Host "`n❌ Opción inválida" -ForegroundColor Red
        }
    }
}
