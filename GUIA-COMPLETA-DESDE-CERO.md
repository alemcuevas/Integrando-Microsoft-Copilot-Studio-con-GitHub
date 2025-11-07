# Guía Completa: Copilot Studio + GitHub desde Cero

Esta guía te llevará paso a paso desde la creación de un agente de Copilot Studio hasta tener un pipeline CI/CD completo con GitHub.

## 📋 Tabla de Contenidos

1. [Requisitos Previos](#requisitos-previos)
2. [Configuración Inicial](#configuración-inicial)
3. [Crear tu Primer Agente](#crear-tu-primer-agente)
4. [Integrar con GitHub](#integrar-con-github)
5. [Configurar CI/CD](#configurar-cicd)
6. [Trabajar en Equipo](#trabajar-en-equipo)

---

## 🎯 Requisitos Previos

### Software Necesario

#### 1. Power Platform CLI

```powershell
# Opción 1: Con winget (recomendado)
winget install Microsoft.PowerPlatformCLI

# Opción 2: Descargar desde
# https://aka.ms/PowerPlatformCLI
```

Verifica la instalación:

```powershell
pac --version
```

#### 2. Git

```powershell
# Con winget
winget install Git.Git

# O descarga desde: https://git-scm.com/download/win
```

Verifica:

```powershell
git --version
```

#### 3. Visual Studio Code (opcional pero recomendado)

```powershell
winget install Microsoft.VisualStudioCode
```

#### 4. Azure CLI (para CI/CD)

```powershell
winget install Microsoft.AzureCLI
```

### Cuentas Necesarias

1. **Microsoft 365** - Para Copilot Studio
   - Con licencia de Copilot Studio
   - Permisos de Environment Maker o superior

2. **GitHub** - Para control de versiones
   - Cuenta gratuita o pro
   - Permisos para crear repositorios

3. **Power Platform** - Ambiente configurado
   - Dataverse habilitado
   - Permisos para crear soluciones

---

## ⚙️ Configuración Inicial

### 1. Autenticación en Power Platform

```powershell
# Listar ambientes disponibles
pac auth create

# Esto abrirá un navegador para autenticarte
# Selecciona tu cuenta y ambiente
```

Verifica tu autenticación:

```powershell
pac auth list
```

Deberías ver algo como:

```
[1]   *   UNIVERSAL   tu-email@empresa.com   Contoso (default)
```

### 2. Crear Repositorio en GitHub

#### Opción A: Desde GitHub Web

1. Ve a [github.com](https://github.com)
2. Click en **+** → **New repository**
3. Nombre: `mi-agente-copilot`
4. Descripción: "Agente de Copilot Studio con CI/CD"
5. **Public** o **Private** (tu elección)
6. ✅ Add a README file
7. ✅ Add .gitignore → **VisualStudio**
8. Click **Create repository**

#### Opción B: Desde la terminal

```powershell
# Crear carpeta del proyecto
mkdir mi-agente-copilot
cd mi-agente-copilot

# Inicializar Git
git init
git branch -M main

# Crear README
echo "# Mi Agente de Copilot Studio" > README.md
git add README.md
git commit -m "feat: inicial commit"

# Conectar con GitHub (reemplaza con tu usuario)
git remote add origin https://github.com/TU-USUARIO/mi-agente-copilot.git
git push -u origin main
```

### 3. Crear Estructura de Carpetas

```powershell
# Crear estructura del proyecto
mkdir solution, templates, scripts, flows, topics, entities, variables

# Crear .gitignore
@"
# Power Platform
*.zip
temp-export/
solution-export/
backups/
agent-id.txt
flow-id.txt

# Logs
*.log

# Secrets
*secret*.txt
*-secrets-*.txt

# VS Code
.vscode/
"@ | Out-File -FilePath .gitignore -Encoding UTF8

# Commit inicial
git add .
git commit -m "chore: estructura inicial del proyecto"
git push origin main
```

---

## 🤖 Crear tu Primer Agente

### 1. Crear el Agente en Copilot Studio

#### Opción A: Desde la Interfaz Web

1. Ve a [copilotstudio.microsoft.com](https://copilotstudio.microsoft.com)
2. Click en **Create** → **New copilot**
3. Configura:
   - **Name**: Asistente Base
   - **Language**: Spanish
   - **Solution**: Crea una nueva llamada "MiSolucion"
4. Click **Create**

#### Opción B: Desde PowerShell (Avanzado)

Primero necesitas un template YAML básico:

```powershell
# Crear template básico
@"
kind: BotDefinition
displayName: Asistente Base
description: Mi primer agente de Copilot Studio
schemaName: miemp_asistenteBase
locale: es
topics: []
"@ | Out-File -FilePath templates\agente-base.yaml -Encoding UTF8

# Crear el agente
pac copilot create `
  --name "miemp_asistenteBase" `
  --description "Mi primer agente" `
  --template-file templates\agente-base.yaml
```

### 2. Agregar Topics al Agente

Crea un topic de saludo:

```yaml
# topics\saludo.yaml
kind: AdaptiveDialog
displayName: Saludo
description: Topic de bienvenida
schemaName: Saludo
trigger:
  kind: OnRecognizedIntent
  intent:
    displayName: Saludo
    triggerQueries:
      - hola
      - buenos días
      - buenas tardes
      - hey
actions:
  - kind: SendActivity
    activity: |
      ¡Hola! 👋 Soy tu asistente virtual. ¿En qué puedo ayudarte hoy?
```

### 3. Crear una Solución en Power Platform

```powershell
# Crear nueva solución
pac solution init `
  --publisher-name "MiEmpresa" `
  --publisher-prefix "miemp" `
  --outputDirectory "solution"

# Agregar el agente a la solución
# Esto se hace desde la UI de Copilot Studio:
# 1. Abre tu agente
# 2. Settings → Details
# 3. Add to solution → Selecciona "MiSolucion"
```

### 4. Exportar la Solución

Crea un script para exportar:

```powershell
# scripts\export-solution.ps1
param(
    [string]$SolutionName = "MiSolucion"
)

Write-Host "📦 Exportando solución: $SolutionName..." -ForegroundColor Cyan

# Limpiar exportaciones anteriores
Remove-Item -Path "*.zip" -ErrorAction SilentlyContinue

# Exportar
pac solution export `
    --name $SolutionName `
    --path "$SolutionName.zip" `
    --managed false

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Solución exportada: $SolutionName.zip" -ForegroundColor Green
} else {
    Write-Host "❌ Error al exportar" -ForegroundColor Red
    exit 1
}
```

Ejecuta:

```powershell
.\scripts\export-solution.ps1
```

### 5. Desempaquetar para Source Control

```powershell
# Desempaquetar la solución
pac solution unpack `
  --zipfile MiSolucion.zip `
  --folder solution `
  --allowWrite `
  --allowDelete

# Commit al repositorio
git add solution/
git commit -m "feat: agregar solución inicial"
git push origin main
```

---

## 🔗 Integrar con GitHub

### 1. Preparar el Proyecto para Source Control

Crea un script de preparación:

```powershell
# scripts\prepare-source-control.ps1

Write-Host "🔧 Preparando proyecto para Source Control..." -ForegroundColor Cyan

# Limpiar archivos temporales
$tempFolders = @("temp-export", "solution-export", "backups")
foreach ($folder in $tempFolders) {
    if (Test-Path $folder) {
        Remove-Item -Path $folder -Recurse -Force
        Write-Host "   🗑️  Eliminado: $folder" -ForegroundColor Yellow
    }
}

# Limpiar archivos ZIP
Get-ChildItem -Path . -Filter "*.zip" | Remove-Item -Force
Write-Host "   🗑️  Eliminados archivos ZIP" -ForegroundColor Yellow

# Verificar estructura
$required = @("solution\bots", "solution\Workflows", "templates", "scripts")
foreach ($path in $required) {
    if (Test-Path $path) {
        Write-Host "   ✅ $path" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  $path no encontrado" -ForegroundColor Yellow
    }
}

Write-Host "`n✅ Proyecto preparado para Source Control" -ForegroundColor Green
```

### 2. Documentar el Proyecto

Actualiza el README.md:

```markdown
# Mi Agente de Copilot Studio

Agente inteligente para [describe tu caso de uso]

## 🚀 Quick Start

### Requisitos
- Power Platform CLI
- Cuenta de Microsoft 365 con Copilot Studio

### Instalación

1. Clona el repositorio:
   \`\`\`bash
   git clone https://github.com/TU-USUARIO/mi-agente-copilot.git
   cd mi-agente-copilot
   \`\`\`

2. Autentica en Power Platform:
   \`\`\`bash
   pac auth create
   \`\`\`

3. Importa la solución:
   \`\`\`bash
   pac solution pack --folder solution --zipfile MiSolucion.zip
   pac solution import --path MiSolucion.zip
   \`\`\`

## 📂 Estructura del Proyecto

\`\`\`
mi-agente-copilot/
├── solution/           # Solución desempaquetada
│   ├── bots/          # Agentes
│   ├── Workflows/     # Cloud Flows
│   └── Other/         # Configuración
├── templates/         # Templates YAML
├── scripts/           # Scripts de automatización
├── flows/             # Documentación de flows
└── topics/            # Documentación de topics
\`\`\`

## 🛠️ Desarrollo

### Exportar cambios
\`\`\`bash
.\scripts\export-solution.ps1
pac solution unpack --zipfile MiSolucion.zip --folder solution --allowWrite
git add .
git commit -m "feat: descripción de cambios"
git push
\`\`\`
```

### 3. Crear Workflow de Desarrollo

```powershell
# scripts\workflow-desarrollo.ps1

Write-Host "📋 Workflow de Desarrollo" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor DarkGray

Write-Host "1️⃣  Haz cambios en Copilot Studio UI" -ForegroundColor White
Write-Host "   https://copilotstudio.microsoft.com`n" -ForegroundColor Gray

Write-Host "2️⃣  Exporta la solución:" -ForegroundColor White
Write-Host "   .\scripts\export-solution.ps1`n" -ForegroundColor Gray

Write-Host "3️⃣  Desempaqueta:" -ForegroundColor White
Write-Host "   pac solution unpack --zipfile MiSolucion.zip --folder solution --allowWrite --allowDelete`n" -ForegroundColor Gray

Write-Host "4️⃣  Revisa los cambios:" -ForegroundColor White
Write-Host "   git status" -ForegroundColor Gray
Write-Host "   git diff`n" -ForegroundColor Gray

Write-Host "5️⃣  Commit y push:" -ForegroundColor White
Write-Host "   git add ." -ForegroundColor Gray
Write-Host "   git commit -m 'feat: descripción'" -ForegroundColor Gray
Write-Host "   git push origin main`n" -ForegroundColor Gray

$opcion = Read-Host "¿Ejecutar workflow completo? (s/n)"

if ($opcion -eq "s") {
    # Exportar
    Write-Host "`n📦 Exportando solución..." -ForegroundColor Cyan
    .\scripts\export-solution.ps1
    
    # Desempaquetar
    Write-Host "`n📂 Desempaquetando..." -ForegroundColor Cyan
    pac solution unpack --zipfile MiSolucion.zip --folder solution --allowWrite --allowDelete
    
    # Mostrar cambios
    Write-Host "`n📊 Cambios detectados:" -ForegroundColor Cyan
    git status --short
    
    Write-Host "`n✅ Listo para commit!" -ForegroundColor Green
}
```

---

## 🚀 Configurar CI/CD

### 1. Crear Service Principal en Azure

```powershell
# Ejecutar el script de creación
.\scripts\crear-service-principal.ps1
```

Este script:
- Crea una aplicación en Azure AD
- Genera credenciales
- Muestra los valores para GitHub Secrets

Guarda los valores mostrados:
- `POWER_PLATFORM_TENANT_ID`
- `POWER_PLATFORM_APP_ID`
- `POWER_PLATFORM_CLIENT_SECRET`

### 2. Configurar Service Principal en Power Platform

1. Ve a [Power Platform Admin Center](https://admin.powerplatform.microsoft.com)
2. Para **cada ambiente** (Dev, Test, Prod):
   
   a. Selecciona el ambiente
   
   b. **Settings** → **Users + permissions** → **Application users**
   
   c. **+ New app user**
   
   d. **+ Add an app**
   
   e. Busca tu app: "GitHub-CopilotStudio-CICD"
   
   f. Selecciona y **Add**
   
   g. **Business unit**: Selecciona la unidad raíz
   
   h. **Security roles**: ✅ **System Administrator**
   
   i. **Create**

### 3. Configurar GitHub Secrets

1. Ve a tu repositorio en GitHub

2. **Settings** → **Secrets and variables** → **Actions**

3. **New repository secret** para cada uno:

```
POWER_PLATFORM_TENANT_ID=tu-tenant-id
POWER_PLATFORM_APP_ID=tu-app-id
POWER_PLATFORM_CLIENT_SECRET=tu-client-secret

POWER_PLATFORM_URL_DEV=https://org-dev.crm.dynamics.com/
POWER_PLATFORM_URL_TEST=https://org-test.crm.dynamics.com/
POWER_PLATFORM_URL_PROD=https://org-prod.crm.dynamics.com/
```

### 4. Crear GitHub Environments

1. **Settings** → **Environments** → **New environment**

2. Crea tres ambientes:

#### Development
- Nombre: `development`
- Protection rules: ❌ Ninguna
- Environment secrets: Ninguno adicional

#### Test
- Nombre: `test`
- Protection rules:
  - ✅ Required reviewers: 1 persona
  - ✅ Deployment branches: Solo `main`

#### Production
- Nombre: `production`
- Protection rules:
  - ✅ Required reviewers: 2 personas
  - ✅ Wait timer: 5 minutos
  - ✅ Deployment branches: Solo `main`

### 5. Verificar Pipeline

```powershell
# Verificar configuración
.\scripts\verificar-cicd.ps1
```

### 6. Hacer tu Primer Deploy

```powershell
# Asegúrate de tener cambios en solution/
git add .
git commit -m "feat: activar CI/CD"
git push origin main

# El pipeline se activará automáticamente
```

Ve a GitHub → **Actions** para ver el progreso.

---

## 👥 Trabajar en Equipo

### 1. Estrategia de Branches

```powershell
# Crear branch para nueva funcionalidad
git checkout -b feature/nuevo-topic

# Hacer cambios en Copilot Studio

# Exportar y commit
.\scripts\export-solution.ps1
pac solution unpack --zipfile MiSolucion.zip --folder solution --allowWrite --allowDelete
git add .
git commit -m "feat: agregar topic de facturación"
git push origin feature/nuevo-topic
```

### 2. Crear Pull Request

1. Ve a GitHub → **Pull requests** → **New pull request**
2. Base: `main` ← Compare: `feature/nuevo-topic`
3. Título: "feat: agregar topic de facturación"
4. Descripción:
   ```markdown
   ## Cambios
   - ✅ Nuevo topic para consultas de facturación
   - ✅ Integración con Flow de SAP
   
   ## Testing
   - [x] Probado en ambiente Dev
   - [x] Conversación funciona correctamente
   - [x] Flow responde en < 3 segundos
   
   ## Screenshots
   [Opcional: agregar capturas]
   ```
5. **Create pull request**

### 3. Code Review

El revisor debe:

1. Revisar cambios en `solution/`
2. Verificar que el pipeline pasa (✅ verde)
3. Probar en ambiente de desarrollo
4. Aprobar o solicitar cambios

### 4. Merge y Deploy

Cuando el PR es aprobado:

1. **Merge pull request** → **Squash and merge**
2. El pipeline automáticamente:
   - ✅ Despliega a DEV
   - 🧪 Despliega a TEST (requiere aprobación)
   - 🏭 Despliega a PROD (requiere 2 aprobaciones)

---

## 🔧 Scripts Útiles

### Crear Topic desde Template

```powershell
# scripts\crear-topic.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$NombreTopic,
    
    [string]$Descripcion = "",
    [string[]]$TriggerPhrases = @()
)

$template = @"
kind: AdaptiveDialog
displayName: $NombreTopic
description: $Descripcion
schemaName: $(($NombreTopic -replace ' ', ''))
trigger:
  kind: OnRecognizedIntent
  intent:
    displayName: $NombreTopic Intent
    triggerQueries:
$(if ($TriggerPhrases.Count -gt 0) {
    $TriggerPhrases | ForEach-Object { "      - $_`n" }
} else {
    "      - trigger phrase here"
})
actions:
  - kind: SendActivity
    activity: |
      Respuesta del topic $NombreTopic
"@

$fileName = "topics\$($NombreTopic -replace ' ', '-').yaml"
$template | Out-File -FilePath $fileName -Encoding UTF8

Write-Host "✅ Topic creado: $fileName" -ForegroundColor Green
code $fileName  # Abre en VS Code
```

Uso:

```powershell
.\scripts\crear-topic.ps1 `
  -NombreTopic "Consulta de Precios" `
  -Descripcion "Permite al usuario consultar precios de productos" `
  -TriggerPhrases @("cuánto cuesta", "precio de", "cuál es el precio")
```

### Sincronizar con Ambiente

```powershell
# scripts\sync-ambiente.ps1
param(
    [ValidateSet("dev", "test", "prod")]
    [string]$Ambiente = "dev"
)

Write-Host "🔄 Sincronizando con ambiente: $Ambiente" -ForegroundColor Cyan

# Cambiar autenticación
switch ($Ambiente) {
    "dev"  { $envId = $env:POWER_PLATFORM_ENV_DEV }
    "test" { $envId = $env:POWER_PLATFORM_ENV_TEST }
    "prod" { $envId = $env:POWER_PLATFORM_ENV_PROD }
}

if (-not $envId) {
    Write-Host "❌ Configure la variable de ambiente para $Ambiente" -ForegroundColor Red
    exit 1
}

# Autenticar
pac auth create --environment $envId

# Exportar solución
.\scripts\export-solution.ps1

# Desempaquetar
pac solution unpack --zipfile MiSolucion.zip --folder solution --allowWrite --allowDelete

Write-Host "✅ Sincronizado con $Ambiente" -ForegroundColor Green
```

---

## 📊 Troubleshooting

### Problema: "Authentication failed"

**Solución:**

```powershell
# Limpiar autenticaciones
pac auth clear

# Crear nueva autenticación
pac auth create
```

### Problema: "Solution import failed"

**Solución:**

```powershell
# Verificar la solución
pac solution check --path MiSolucion.zip

# Ver errores detallados
pac solution import --path MiSolucion.zip --verbose
```

### Problema: Pipeline falla en GitHub Actions

**Solución:**

1. Verifica los secrets están configurados
2. Revisa logs en Actions → Click en el job fallido
3. Verifica permisos del Service Principal
4. Asegúrate que el ambiente existe

### Problema: Conflictos en Git

**Solución:**

```powershell
# Ver archivos en conflicto
git status

# Para archivos JSON/XML de solution/, usar theirs o ours
git checkout --theirs solution/path/to/file.json  # Usar remoto
git checkout --ours solution/path/to/file.json    # Usar local

# Marcar como resuelto
git add .
git commit -m "fix: resolver conflictos"
```

---

## 🎓 Próximos Pasos

### 1. Agregar Tests Automatizados

```yaml
# .github/workflows/test-agent.yml
name: Test Agent

on: [pull_request]

jobs:
  test:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      - name: Validar YAML
        run: |
          Get-ChildItem -Path templates -Filter *.yaml | ForEach-Object {
            Write-Host "Validando $($_.Name)"
            # Agregar validación YAML aquí
          }
```

### 2. Integrar con Teams

1. Publica tu agente
2. Copilot Studio → **Channels** → **Microsoft Teams**
3. **Add to Teams**
4. Comparte con tu equipo

### 3. Agregar Telemetría

```powershell
# En cada topic, agregar logging
- kind: InvokeAction
  actionId: LogEvent
  parameters:
    EventName: "TopicStarted"
    TopicName: "NombreDelTopic"
```

### 4. Crear Documentación Automática

```powershell
# scripts\generar-docs.ps1
# Genera documentación markdown desde la solución
```

---

## 📚 Recursos Adicionales

### Documentación Oficial

- [Power Platform CLI](https://learn.microsoft.com/power-platform/developer/cli/introduction)
- [Copilot Studio](https://learn.microsoft.com/microsoft-copilot-studio/)
- [GitHub Actions](https://docs.github.com/actions)
- [Power Platform ALM](https://learn.microsoft.com/power-platform/alm/)

### Community

- [Power Platform Community](https://powerusers.microsoft.com/)
- [GitHub Discussions](https://github.com/microsoft/powerplatform-build-tools/discussions)

### Templates

- [Power Platform Samples](https://github.com/microsoft/PowerPlatform-Samples)
- [Copilot Studio Templates](https://github.com/microsoft/copilot-studio-samples)

---

## ✅ Checklist Completo

### Configuración Inicial
- [ ] Power Platform CLI instalado
- [ ] Git instalado y configurado
- [ ] Repositorio GitHub creado
- [ ] Autenticado en Power Platform
- [ ] Estructura de carpetas creada

### Desarrollo
- [ ] Agente creado en Copilot Studio
- [ ] Solución creada
- [ ] Agente agregado a solución
- [ ] Primer export/unpack exitoso
- [ ] Cambios committed a GitHub

### CI/CD
- [ ] Service Principal creado
- [ ] Permisos asignados en Power Platform
- [ ] GitHub Secrets configurados
- [ ] GitHub Environments creados
- [ ] Pipeline ejecutado exitosamente

### Equipo
- [ ] README.md documentado
- [ ] Workflow de desarrollo definido
- [ ] Estrategia de branches establecida
- [ ] Code review process implementado

---

## 🎉 ¡Felicitaciones!

Ahora tienes un proyecto completo de Copilot Studio con:

✅ Control de versiones en GitHub
✅ CI/CD automatizado
✅ Workflow de equipo establecido
✅ Scripts de automatización
✅ Documentación completa

**Siguiente paso:** Empieza a desarrollar topics y funcionalidades para tu agente!

---

*Última actualización: Noviembre 2025*
*Versión: 1.0*
