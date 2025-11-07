# crear-service-principal.ps1
# Script para crear Service Principal para CI/CD con GitHub Actions

Write-Host "🔐 Creando Service Principal para CI/CD" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor DarkGray

# Verificar si Azure CLI está instalado
try {
    $azVersion = az version --output json | ConvertFrom-Json
    Write-Host "✅ Azure CLI instalado: $($azVersion.'azure-cli')" -ForegroundColor Green
} catch {
    Write-Host "❌ Azure CLI no está instalado" -ForegroundColor Red
    Write-Host "`n💡 Instala Azure CLI desde: https://aka.ms/installazurecliwindows" -ForegroundColor Yellow
    exit 1
}

# Login a Azure
Write-Host "`n🔑 Autenticando en Azure..." -ForegroundColor Yellow
az login --use-device-code

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n❌ Error en la autenticación" -ForegroundColor Red
    exit 1
}

# Obtener tenant info
$account = az account show | ConvertFrom-Json
$tenantId = $account.tenantId

Write-Host "`n✅ Autenticado en tenant: $($account.name)" -ForegroundColor Green
Write-Host "   Tenant ID: $tenantId" -ForegroundColor Gray

# Crear la aplicación
Write-Host "`n📱 Creando aplicación en Azure AD..." -ForegroundColor Yellow

$appName = "GitHub-CopilotStudio-CICD-$(Get-Date -Format 'yyyyMMdd')"

$app = az ad app create `
    --display-name $appName `
    --sign-in-audience "AzureADMyOrg" | ConvertFrom-Json

$appId = $app.appId

Write-Host "✅ Aplicación creada: $appName" -ForegroundColor Green
Write-Host "   App ID: $appId" -ForegroundColor Gray

# Crear Service Principal
Write-Host "`n👤 Creando Service Principal..." -ForegroundColor Yellow

$sp = az ad sp create --id $appId | ConvertFrom-Json

Write-Host "✅ Service Principal creado" -ForegroundColor Green
Write-Host "   Object ID: $($sp.id)" -ForegroundColor Gray

# Crear credencial (secret)
Write-Host "`n🔑 Generando client secret..." -ForegroundColor Yellow

$credential = az ad app credential reset `
    --id $appId `
    --append `
    --display-name "GitHub Actions" `
    --years 2 | ConvertFrom-Json

$clientSecret = $credential.password

Write-Host "✅ Client Secret generado (válido por 2 años)" -ForegroundColor Green

# Mostrar instrucciones
Write-Host "`n" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "📋 CONFIGURAR GITHUB SECRETS" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n1. Ve a tu repositorio en GitHub" -ForegroundColor White
Write-Host "2. Settings → Secrets and variables → Actions → New repository secret" -ForegroundColor White
Write-Host "3. Agrega estos secrets:`n" -ForegroundColor White

Write-Host "POWER_PLATFORM_TENANT_ID" -ForegroundColor Yellow
Write-Host "$tenantId`n" -ForegroundColor Gray

Write-Host "POWER_PLATFORM_APP_ID" -ForegroundColor Yellow
Write-Host "$appId`n" -ForegroundColor Gray

Write-Host "POWER_PLATFORM_CLIENT_SECRET" -ForegroundColor Yellow
Write-Host "$clientSecret`n" -ForegroundColor Gray

Write-Host "⚠️  IMPORTANTE: Guarda el CLIENT_SECRET ahora, no se mostrará de nuevo!" -ForegroundColor Red

# Guardar en archivo temporal
$secretsFile = "github-secrets-$(Get-Date -Format 'yyyyMMddHHmmss').txt"
@"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
GITHUB SECRETS - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

POWER_PLATFORM_TENANT_ID=$tenantId
POWER_PLATFORM_APP_ID=$appId
POWER_PLATFORM_CLIENT_SECRET=$clientSecret

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PRÓXIMOS PASOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Configura los secrets en GitHub (ver arriba)

2. Agrega el Service Principal a cada ambiente de Power Platform:
   
   a) Ve a: https://admin.powerplatform.microsoft.com
   b) Selecciona cada ambiente (DEV, TEST, PROD)
   c) Settings → Users + permissions → Application users
   d) + New app user
   e) Selecciona la app: $appName
   f) Asigna el rol: System Administrator
   g) Click en Create

3. Configura las URLs de los ambientes en GitHub Secrets:
   
   POWER_PLATFORM_URL_DEV=https://org-dev.crm.dynamics.com/
   POWER_PLATFORM_URL_TEST=https://org-test.crm.dynamics.com/
   POWER_PLATFORM_URL_PROD=https://org-prod.crm.dynamics.com/

4. (Opcional) Configura los Environment IDs:
   
   POWER_PLATFORM_ENV_DEV=environment-id-dev
   POWER_PLATFORM_ENV_TEST=environment-id-test
   POWER_PLATFORM_ENV_PROD=environment-id-prod

5. Crea los GitHub Environments:
   
   - development (sin protección)
   - test (1 revisor)
   - production (2 revisores + wait timer)

⚠️  BORRA ESTE ARCHIVO DESPUÉS DE CONFIGURAR LOS SECRETS
"@ | Out-File -FilePath $secretsFile -Encoding UTF8

Write-Host "`n📄 Información guardada en: $secretsFile" -ForegroundColor Cyan
Write-Host "   ⚠️  Borra este archivo después de configurar GitHub" -ForegroundColor Yellow

# Abrir Power Platform Admin Center
Write-Host "`n🌐 Abriendo Power Platform Admin Center..." -ForegroundColor Cyan
Start-Sleep -Seconds 2
Start-Process "https://admin.powerplatform.microsoft.com/environments"

Write-Host "`n✅ Service Principal creado exitosamente!" -ForegroundColor Green
Write-Host "`n💡 Sigue las instrucciones del archivo: $secretsFile" -ForegroundColor Yellow
