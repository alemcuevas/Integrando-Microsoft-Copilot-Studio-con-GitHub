# Guía: Crear e Importar como Solución de Power Platform

## Introducción

Esta guía te muestra cómo empaquetar el agente de retail como una **Solución de Power Platform** para facilitar el despliegue y versionado.

---

## Prerrequisitos

- Power Platform CLI instalado y actualizado
- Cuenta con permisos de System Administrator o System Customizer
- Visual Studio Code con la extensión Power Platform Tools (opcional)

---

## Método 1: Crear Solución desde Copilot Studio (RECOMENDADO)

Este es el flujo correcto para trabajar con soluciones:

### Paso 1: Crear la Solución en Power Platform

```powershell
# Autenticarse
pac auth create --url https://[tu-entorno].crm.dynamics.com

# Crear una nueva solución
pac solution init --publisher-name "MiEmpresa" --publisher-prefix "miemp"
```

O desde la interfaz web:

1. Ve a https://make.powerapps.com
2. Selecciona **Solutions** (Soluciones)
3. Haz clic en **+ New solution**
4. Completa:
   - **Display name**: Agente de Retail - Asistente de Ventas
   - **Name**: AgenteRetailAsistente
   - **Publisher**: Crea uno nuevo o selecciona existente
   - **Version**: 1.0.0.0

### Paso 2: Crear el Bot en Copilot Studio

1. Ve a https://copilotstudio.microsoft.com
2. **IMPORTANTE**: Antes de crear el bot, asegúrate de estar en el **mismo entorno**
3. Al crear el nuevo chatbot:
   - En configuración avanzada, selecciona **"Add to a Dataverse solution"**
   - Selecciona la solución que creaste: **AgenteRetailAsistente**

4. Usa los archivos JSON de este proyecto como guía para crear:
   - Topics (9 topics)
   - Entities (2 entidades)
   - Variables (10 variables globales)

### Paso 3: Exportar la Solución

**Desde la interfaz web:**

1. Ve a https://make.powerapps.com
2. Selecciona **Solutions**
3. Encuentra **AgenteRetailAsistente**
4. Haz clic en **Export**
5. Selecciona **Unmanaged** (para desarrollo)
6. Haz clic en **Export**
7. Descarga el archivo .zip

**Desde CLI:**

```powershell
# Exportar solución no administrada
pac solution export --name AgenteRetailAsistente --path ./ --managed false

# Exportar solución administrada (para producción)
pac solution export --name AgenteRetailAsistente --path ./ --managed true
```

### Paso 4: Guardar en GitHub

```powershell
# Desempaquetar la solución para control de versiones
pac solution unpack --zipfile AgenteRetailAsistente.zip --folder ./solution-source

# Agregar a Git
git add .
git commit -m "Exportar agente de retail como solución"
git push
```

---

## Método 2: Importar Solución Existente

### Desde CLI

```powershell
# Autenticarse en el entorno destino
pac auth create --url https://[entorno-destino].crm.dynamics.com

# Importar solución
pac solution import --path AgenteRetailAsistente.zip --async

# Ver el progreso
pac solution import --path AgenteRetailAsistente.zip --async --poll-status
```

### Desde la Interfaz Web

1. Ve a https://make.powerapps.com
2. Selecciona el entorno destino
3. Ve a **Solutions**
4. Haz clic en **Import solution**
5. Sube el archivo .zip
6. Sigue el asistente:
   - Revisa los detalles
   - Configura las conexiones necesarias
   - Haz clic en **Import**

---

## Método 3: Workflow Completo con Git

### Estructura recomendada en Git

```
agente-retail-repo/
├── README.md
├── solution/
│   ├── AgenteRetailAsistente/          # Solución desempaquetada
│   │   ├── CanvasApps/
│   │   ├── Entities/
│   │   ├── OptionSets/
│   │   ├── Other/
│   │   │   └── Solution.xml
│   │   └── Workflows/
│   └── AgenteRetailAsistente.zip       # Solución empaquetada
├── docs/
│   ├── GUIA-IMPORTACION.md
│   └── EJEMPLOS-CONVERSACIONES.md
└── scripts/
    ├── export-solution.ps1
    └── import-solution.ps1
```

### Script de Exportación (export-solution.ps1)

```powershell
# export-solution.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$EnvironmentUrl,
    
    [Parameter(Mandatory=$false)]
    [string]$SolutionName = "AgenteRetailAsistente"
)

Write-Host "Exportando solución: $SolutionName" -ForegroundColor Green

# Autenticar
pac auth create --url $EnvironmentUrl

# Exportar solución no administrada
pac solution export --name $SolutionName --path ./solution --managed false --overwrite

# Desempaquetar para control de versiones
pac solution unpack --zipfile "./solution/$SolutionName.zip" --folder "./solution/$SolutionName" --processCanvasApps

Write-Host "Exportación completada!" -ForegroundColor Green
```

### Script de Importación (import-solution.ps1)

```powershell
# import-solution.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$EnvironmentUrl,
    
    [Parameter(Mandatory=$false)]
    [string]$SolutionName = "AgenteRetailAsistente"
)

Write-Host "Importando solución: $SolutionName" -ForegroundColor Green

# Autenticar
pac auth create --url $EnvironmentUrl

# Empaquetar solución desde fuente
pac solution pack --zipfile "./solution/$SolutionName.zip" --folder "./solution/$SolutionName" --processCanvasApps

# Importar
pac solution import --path "./solution/$SolutionName.zip" --async --publish-changes

Write-Host "Importación iniciada!" -ForegroundColor Green
```

### Uso de los Scripts

```powershell
# Exportar
.\scripts\export-solution.ps1 -EnvironmentUrl "https://dev.crm.dynamics.com"

# Importar
.\scripts\import-solution.ps1 -EnvironmentUrl "https://test.crm.dynamics.com"
```

---

## Método 4: CI/CD con GitHub Actions

### Workflow de GitHub Actions (.github/workflows/deploy-solution.yml)

```yaml
name: Deploy Copilot Solution

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  export-and-deploy:
    runs-on: windows-latest
    
    steps:
    - name: Checkout repository
      uses: actions/checkout@v3
    
    - name: Setup Power Platform CLI
      uses: microsoft/powerplatform-actions/actions-install@v1
    
    - name: Authenticate to Dev Environment
      uses: microsoft/powerplatform-actions/who-am-i@v1
      with:
        environment-url: ${{ secrets.DEV_ENVIRONMENT_URL }}
        app-id: ${{ secrets.APPLICATION_ID }}
        client-secret: ${{ secrets.CLIENT_SECRET }}
        tenant-id: ${{ secrets.TENANT_ID }}
    
    - name: Export Solution from Dev
      uses: microsoft/powerplatform-actions/export-solution@v1
      with:
        environment-url: ${{ secrets.DEV_ENVIRONMENT_URL }}
        app-id: ${{ secrets.APPLICATION_ID }}
        client-secret: ${{ secrets.CLIENT_SECRET }}
        tenant-id: ${{ secrets.TENANT_ID }}
        solution-name: AgenteRetailAsistente
        solution-output-file: solution/AgenteRetailAsistente.zip
        managed: false
    
    - name: Unpack Solution
      uses: microsoft/powerplatform-actions/unpack-solution@v1
      with:
        solution-file: solution/AgenteRetailAsistente.zip
        solution-folder: solution/AgenteRetailAsistente
        solution-type: Unmanaged
    
    - name: Commit Changes
      run: |
        git config user.name "GitHub Actions"
        git config user.email "actions@github.com"
        git add solution/
        git commit -m "Auto-export solution [skip ci]" || echo "No changes"
        git push
    
    - name: Import to Test Environment
      uses: microsoft/powerplatform-actions/import-solution@v1
      with:
        environment-url: ${{ secrets.TEST_ENVIRONMENT_URL }}
        app-id: ${{ secrets.APPLICATION_ID }}
        client-secret: ${{ secrets.CLIENT_SECRET }}
        tenant-id: ${{ secrets.TENANT_ID }}
        solution-file: solution/AgenteRetailAsistente.zip
```

---

## Gestión de Múltiples Entornos

### Estrategia recomendada:

```
Desarrollo (DEV)
    ↓ Exportar/Commit
GitHub Repository
    ↓ CI/CD Pipeline
Testing (TEST)
    ↓ Aprobación Manual
Producción (PROD)
```

### Comandos por entorno:

```powershell
# Desarrollo - Exportar cambios
pac auth create --url https://dev.crm.dynamics.com
pac solution export --name AgenteRetailAsistente --path ./dev

# Testing - Importar para pruebas
pac auth create --url https://test.crm.dynamics.com
pac solution import --path ./dev/AgenteRetailAsistente.zip

# Producción - Solución administrada
pac auth create --url https://dev.crm.dynamics.com
pac solution export --name AgenteRetailAsistente --path ./prod --managed true

pac auth create --url https://prod.crm.dynamics.com
pac solution import --path ./prod/AgenteRetailAsistente.zip
```

---

## Solución de Problemas

### Error: "Solution with the same name already exists"

```powershell
# Eliminar solución existente primero (¡cuidado!)
pac solution delete --solution-name AgenteRetailAsistente

# O usar un nuevo nombre/versión
```

### Error: "Missing dependencies"

La solución requiere componentes que no existen en el entorno destino.

**Solución:**
1. Revisar las dependencias en la solución exportada
2. Importar las soluciones requeridas primero
3. O eliminar las dependencias innecesarias

### Error: "Insufficient permissions"

**Solución:**
- Necesitas rol de **System Administrator** o **System Customizer**
- Contacta al administrador del entorno

---

## Mejores Prácticas

### ✅ DO (Hacer):

- Versionar la solución desempaquetada en Git (`.xml`, `.json`)
- Usar soluciones **no administradas** en DEV/TEST
- Usar soluciones **administradas** en PROD
- Incrementar versión con cada cambio
- Documentar cambios en cada versión
- Probar en TEST antes de PROD

### ❌ DON'T (No hacer):

- No versionar el `.zip` directamente (es binario)
- No importar solución no administrada en PROD
- No modificar soluciones administradas
- No saltarse el entorno de pruebas

---

## Recursos Adicionales

- [Power Platform ALM Guide](https://docs.microsoft.com/power-platform/alm/)
- [Solution Concepts](https://docs.microsoft.com/power-platform/alm/solution-concepts-alm)
- [GitHub Actions for Power Platform](https://github.com/marketplace/actions/powerplatform-actions)
- [pac solution commands](https://docs.microsoft.com/power-platform/developer/cli/reference/solution)

---

**Última actualización**: Noviembre 2025  
**Versión**: 1.0.0
