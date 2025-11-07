# Scripts de Automatización

Este directorio contiene scripts de PowerShell para automatizar la exportación e importación de la solución del agente de retail.

## Scripts Disponibles

### 📤 export-solution.ps1

Exporta la solución desde un entorno de Power Platform y la desempaqueta para control de versiones.

**Uso básico:**

```powershell
.\scripts\export-solution.ps1 -EnvironmentUrl "https://dev.crm.dynamics.com"
```

**Parámetros:**

| Parámetro | Tipo | Requerido | Default | Descripción |
|-----------|------|-----------|---------|-------------|
| `-EnvironmentUrl` | string | ✅ Sí | - | URL del entorno de Power Platform |
| `-SolutionName` | string | ❌ No | AgenteRetailAsistente | Nombre de la solución |
| `-Managed` | switch | ❌ No | false | Exportar como solución administrada |
| `-OutputPath` | string | ❌ No | ./solution | Directorio de salida |

**Ejemplos:**

```powershell
# Exportar solución no administrada (desarrollo)
.\scripts\export-solution.ps1 -EnvironmentUrl "https://dev.crm.dynamics.com"

# Exportar solución administrada (producción)
.\scripts\export-solution.ps1 `
    -EnvironmentUrl "https://dev.crm.dynamics.com" `
    -Managed

# Exportar con nombre y ruta personalizados
.\scripts\export-solution.ps1 `
    -EnvironmentUrl "https://dev.crm.dynamics.com" `
    -SolutionName "MiAgente" `
    -OutputPath "./export"
```

---

### 📥 import-solution.ps1

Importa la solución a un entorno de Power Platform.

**Uso básico:**

```powershell
.\scripts\import-solution.ps1 -EnvironmentUrl "https://test.crm.dynamics.com"
```

**Parámetros:**

| Parámetro | Tipo | Requerido | Default | Descripción |
|-----------|------|-----------|---------|-------------|
| `-EnvironmentUrl` | string | ✅ Sí | - | URL del entorno destino |
| `-SolutionName` | string | ❌ No | AgenteRetailAsistente | Nombre de la solución |
| `-SolutionPath` | string | ❌ No | ./solution | Directorio de la solución |
| `-Async` | switch | ❌ No | true | Importar de forma asíncrona |
| `-PublishChanges` | switch | ❌ No | true | Publicar cambios después de importar |
| `-PackFromSource` | switch | ❌ No | false | Empaquetar desde carpeta antes de importar |

**Ejemplos:**

```powershell
# Importar solución desde ZIP existente
.\scripts\import-solution.ps1 -EnvironmentUrl "https://test.crm.dynamics.com"

# Importar empaquetando desde fuente primero
.\scripts\import-solution.ps1 `
    -EnvironmentUrl "https://test.crm.dynamics.com" `
    -PackFromSource

# Importar de forma síncrona (esperar a que termine)
.\scripts\import-solution.ps1 `
    -EnvironmentUrl "https://test.crm.dynamics.com" `
    -Async:$false

# Importar sin publicar automáticamente
.\scripts\import-solution.ps1 `
    -EnvironmentUrl "https://test.crm.dynamics.com" `
    -PublishChanges:$false
```

---

## Flujo de Trabajo Típico

### 1. Desarrollo en DEV

```powershell
# Hacer cambios en Copilot Studio en el entorno DEV
# Luego exportar la solución

.\scripts\export-solution.ps1 -EnvironmentUrl "https://dev.crm.dynamics.com"
```

### 2. Commit a Git

```powershell
git add solution/
git commit -m "feat: Agregar nuevo topic de productos"
git push
```

### 3. Deploy a TEST

```powershell
.\scripts\import-solution.ps1 -EnvironmentUrl "https://test.crm.dynamics.com"
```

### 4. Deploy a PROD (solución administrada)

```powershell
# Exportar como administrada desde DEV
.\scripts\export-solution.ps1 `
    -EnvironmentUrl "https://dev.crm.dynamics.com" `
    -Managed `
    -OutputPath "./prod"

# Importar a PROD
.\scripts\import-solution.ps1 `
    -EnvironmentUrl "https://prod.crm.dynamics.com" `
    -SolutionPath "./prod"
```

---

## Requisitos Previos

### Power Platform CLI

Asegúrate de tener instalado Power Platform CLI:

```powershell
# Verificar instalación
pac --version

# Si no está instalado, descárgalo de:
# https://aka.ms/PowerPlatformCLI
```

### Permisos Necesarios

- **System Administrator** o **System Customizer** en los entornos
- Permisos para crear/modificar soluciones

### Autenticación

Los scripts manejan la autenticación automáticamente, pero necesitarás:
- Credenciales de Microsoft válidas
- Acceso a los entornos especificados

---

## Solución de Problemas

### Error: "pac command not found"

**Solución:**
1. Instala Power Platform CLI
2. Reinicia PowerShell
3. Verifica que esté en el PATH

### Error: "Insufficient permissions"

**Solución:**
- Contacta al administrador del entorno
- Solicita rol de System Administrator o System Customizer

### Error: "Solution already exists"

**Solución:**
```powershell
# Eliminar solución existente (¡cuidado!)
pac solution delete --solution-name AgenteRetailAsistente

# O cambiar el nombre de la solución
.\scripts\import-solution.ps1 `
    -EnvironmentUrl "..." `
    -SolutionName "AgenteRetailAsistente_v2"
```

### Error: "Missing dependencies"

**Solución:**
1. Identificar las dependencias faltantes
2. Importar las soluciones requeridas primero
3. Luego importar esta solución

---

## Automatización Avanzada

### Wrapper Script (deploy-all.ps1)

Puedes crear un script que combine ambos:

```powershell
# deploy-all.ps1
param(
    [string]$DevUrl,
    [string]$TestUrl,
    [string]$ProdUrl
)

# Exportar de DEV
.\scripts\export-solution.ps1 -EnvironmentUrl $DevUrl

# Importar a TEST
.\scripts\import-solution.ps1 -EnvironmentUrl $TestUrl

# Preguntar antes de PROD
$confirm = Read-Host "¿Desplegar a PROD? (S/N)"
if ($confirm -eq "S") {
    # Exportar administrada
    .\scripts\export-solution.ps1 -EnvironmentUrl $DevUrl -Managed -OutputPath "./prod"
    
    # Importar a PROD
    .\scripts\import-solution.ps1 -EnvironmentUrl $ProdUrl -SolutionPath "./prod"
}
```

---

## Mejores Prácticas

✅ **Siempre exportar después de cambios importantes**

✅ **Usar soluciones no administradas en DEV/TEST**

✅ **Usar soluciones administradas en PROD**

✅ **Probar en TEST antes de PROD**

✅ **Mantener control de versiones en Git**

✅ **Documentar cambios en commits**

---

**Última actualización:** Noviembre 2025
