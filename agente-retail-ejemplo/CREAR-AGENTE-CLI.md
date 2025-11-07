# Crear Agente usando CLI - Guía Completa

## 🎯 Respuesta Corta

**SÍ, se puede crear e importar el agente desde CLI**, pero necesitas:

1. Crear un agente simple primero (manual)
2. Extraer su template YAML
3. Modificar el template con tu contenido
4. Crear nuevos agentes basados en ese template

---

## 📋 Proceso Completo

### Paso 1: Crear un Agente Básico (Una Sola Vez)

Ve a https://copilotstudio.microsoft.com y crea un agente simple llamado "Template Base":

- **Name**: Template Base
- **Language**: Español
- **Add to solution**: MyRetailAgent
- Crea 1-2 topics simples

### Paso 2: Extraer el Template

```powershell
# Listar agentes
pac copilot list

# Extraer template (usar el ID o schema name del agente)
pac copilot extract-template `
    --bot "cr123_templatebase" `
    --templateFileName "./templates/base-template.yaml" `
    --overwrite
```

### Paso 3: Modificar el Template

Edita `base-template.yaml` con el contenido de tu agente de retail:
- Topics
- Entities  
- Variables
- Trigger phrases

### Paso 4: Crear Nuevos Agentes desde el Template

```powershell
# Crear agente desde template
pac copilot create `
    --schemaName "miemp_agenteRetail" `
    --templateFileName "./templates/base-template.yaml" `
    --displayName "Agente de Retail - Asistente de Ventas" `
    --solution "MyRetailAgent"
```

---

## 🚀 Script de Automatización

Guarda esto como `create-agent-from-template.ps1`:

```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$TemplateFile,
    
    [Parameter(Mandatory=$true)]
    [string]$AgentName,
    
    [Parameter(Mandatory=$true)]
    [string]$SchemaName,
    
    [Parameter(Mandatory=$false)]
    [string]$Solution = "MyRetailAgent"
)

Write-Host "Creando agente desde template..." -ForegroundColor Cyan

pac copilot create `
    --schemaName $SchemaName `
    --templateFileName $TemplateFile `
    --displayName $AgentName `
    --solution $Solution

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Agente creado exitosamente!" -ForegroundColor Green
    
    # Listar agentes
    Write-Host "`nAgentes en el entorno:" -ForegroundColor Cyan
    pac copilot list
} else {
    Write-Host "✗ Error al crear el agente" -ForegroundColor Red
}
```

**Uso:**
```powershell
.\create-agent-from-template.ps1 `
    -TemplateFile "./templates/retail-agent.yaml" `
    -AgentName "Agente de Retail v1" `
    -SchemaName "miemp_agenteRetailV1"
```

---

## ⚠️ Limitaciones Actuales

### Lo que SÍ funciona:
- ✅ Crear agentes desde templates YAML
- ✅ Extraer templates de agentes existentes
- ✅ Listar agentes
- ✅ Publicar agentes

### Lo que NO funciona bien:
- ❌ No hay documentación oficial del formato YAML completo
- ❌ No se puede crear desde JSON directamente
- ❌ El formato exacto de topics complejos no está documentado
- ❌ Entities y variables tienen formato específico no documentado

---

## 💡 Enfoque Recomendado

Dado las limitaciones, te recomiendo este flujo híbrido:

### Opción A: Template + Desarrollo manual (RECOMENDADO)

1. **Crear agente base con template**
   ```powershell
   pac copilot create --schemaName "..." --templateFileName "..." --displayName "..." --solution "MyRetailAgent"
   ```

2. **Completar manualmente en Copilot Studio**
   - Agregar topics complejos
   - Configurar entities
   - Definir variables
   - Usar los archivos JSON como guía

3. **Exportar como solución**
   ```powershell
   .\scripts\export-solution.ps1 -EnvironmentUrl "https://..."
   ```

### Opción B: Todo manual + Exportar (MÁS SIMPLE)

1. **Crear todo en Copilot Studio** (UI)
   - Usar `CREAR-BOT-MANUAL.md` como guía
   - Más control y visual

2. **Exportar cuando esté listo**
   ```powershell
   .\scripts\export-solution.ps1 -EnvironmentUrl "https://..."
   ```

3. **Importar en otros entornos**
   ```powershell
   .\scripts\import-solution.ps1 -EnvironmentUrl "https://..."
   ```

---

## 📚 Comandos Útiles

### Listar agentes
```powershell
pac copilot list
```

### Extraer template de un agente
```powershell
pac copilot extract-template `
    --bot "schema_name_o_guid" `
    --templateFileName "./output.yaml" `
    --overwrite
```

### Crear agente desde template
```powershell
pac copilot create `
    --schemaName "miemp_nuevoAgente" `
    --templateFileName "./template.yaml" `
    --displayName "Mi Nuevo Agente" `
    --solution "MyRetailAgent"
```

### Publicar agente
```powershell
pac copilot publish --bot "schema_name_o_guid"
```

### Ver estado de deployment
```powershell
pac copilot status --bot "schema_name_o_guid"
```

---

## 🎯 Conclusión

**Respuesta a tu pregunta:**

> ¿Con esto no podemos crear e importar el agente y todo desde aquí?

**Sí, PERO con limitaciones:**

✅ **Puedes crear agentes desde CLI** con `pac copilot create`  
✅ **Puedes usar templates YAML**  
✅ **Puedes automatizar la creación básica**  

❌ **NO puedes** crear agentes complejos 100% desde CLI (aún)  
❌ **La documentación del formato YAML es limitada**  
❌ **Topics complejos requieren la UI de Copilot Studio**  

### Recomendación Final:

**Usa el enfoque híbrido:**
1. Crea un agente simple con CLI (si quieres)
2. Desarrolla el contenido en Copilot Studio (UI)
3. Exporta como solución para versionado
4. Automatiza el deploy entre entornos

Los archivos JSON que creamos siguen siendo valiosos como **documentación y guía** para crear el agente manualmente.

---

**¿Prefieres que te ayude a:**
1. Crear un template YAML válido extrayendo uno de un agente simple?
2. O seguir con el enfoque manual usando `CREAR-BOT-MANUAL.md`?
