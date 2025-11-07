# 🚀 Flujo Automatizado - Crear Agente Retail via CLI

Este flujo combina acciones manuales necesarias con máxima automatización via scripts.

---

## 📋 Resumen del Proceso

```
Manual → CLI → Análisis → Modificación → CLI → Exportar
  (1)    (2)      (3)          (4)        (5)     (6)
```

---

## 🎯 Pasos Detallados

### ✅ Paso 1: Crear Agente Base (Manual - 5 minutos)

**Por qué manual:** Necesitamos extraer el formato YAML oficial de Microsoft.

**Instrucciones:**
```
📄 Lee: .\scripts\1-crear-agente-base.md
```

**Tareas:**
1. Ir a https://copilotstudio.microsoft.com
2. Crear agente "TemplateBase"
3. Agregar a solución "MyRetailAgent"
4. Crear 1-2 topics simples
5. Publicar

**Verificación:**
```powershell
pac copilot list
# Deberías ver: TemplateBase
```

---

### ⚙️ Paso 2: Extraer Template (Automatizado)

**Script:**
```powershell
.\scripts\2-extraer-template.ps1
```

**Qué hace:**
- Lista agentes disponibles
- Solicita el Schema Name del agente base
- Extrae el template YAML oficial
- Guarda en `./templates/base-template.yaml`
- Muestra vista previa

**Salida esperada:**
```
✓ Template extraído exitosamente!
Archivo generado: ./templates/base-template.yaml
```

---

### 🔍 Paso 3: Analizar Template (Automatizado)

**Script:**
```powershell
.\scripts\3-modificar-template.ps1
```

**Qué hace:**
- Analiza la estructura del template extraído
- Identifica secciones clave (topics, entities, variables)
- Copia el template para modificación
- Abre archivos en VS Code para comparación

**Salida:**
- Crea `./templates/retail-agent-template.yaml`
- Muestra qué secciones están presentes

---

### ✏️ Paso 4: Modificar Template (Manual guiado)

**Por qué manual:** El formato YAML exacto depende de la versión de Copilot Studio.

**Referencias abiertas:**
- `./templates/retail-agent-template.yaml` (editar este)
- `./topics/*.topic.json` (referencia)
- `./entities/*.entity.json` (referencia)

**Tareas:**
1. Revisar estructura del template base
2. Agregar topics del retail (9 topics)
3. Agregar entities (2 entities)
4. Agregar variables globales
5. Guardar cambios

**Tip:** Usa el template base como guía de sintaxis, y nuestros JSON como guía de contenido.

---

### 🚀 Paso 5: Crear Agente Retail (Automatizado)

**Script:**
```powershell
.\scripts\4-crear-agente-retail.ps1
```

**Qué hace:**
- Verifica que el template modificado existe
- Muestra configuración y preview
- Solicita confirmación
- Ejecuta `pac copilot create`
- Lista agentes creados
- Muestra próximos pasos

**Parámetros opcionales:**
```powershell
.\scripts\4-crear-agente-retail.ps1 `
    -TemplateFile "./templates/retail-agent-template.yaml" `
    -SchemaName "miemp_agenteRetail" `
    -DisplayName "Agente de Retail - Asistente de Ventas" `
    -Solution "MyRetailAgent"
```

**Salida esperada:**
```
✓ ¡Agente creado exitosamente!
```

---

### 📦 Paso 6: Exportar y Versionar (Automatizado)

**Script:**
```powershell
.\scripts\export-solution.ps1 -EnvironmentUrl "https://orgce8fe757.crm.dynamics.com/"
```

**Qué hace:**
- Exporta la solución completa
- Desempaqueta para versionado en Git
- Lista archivos exportados

**Luego versionar:**
```powershell
git add solution/
git commit -m "feat: agente retail creado via CLI template"
git push
```

---

## 📊 Resumen de Automatización

| Paso | Tipo | Duración | Automatizable |
|------|------|----------|---------------|
| 1. Crear agente base | Manual | 5 min | ❌ (necesario una vez) |
| 2. Extraer template | Script | 1 min | ✅ |
| 3. Analizar template | Script | 30 seg | ✅ |
| 4. Modificar template | Manual guiado | 10-30 min | ⚠️ (parcial) |
| 5. Crear agente retail | Script | 2 min | ✅ |
| 6. Exportar/versionar | Script | 2 min | ✅ |

**Total:** ~20-40 minutos (dependiendo de complejidad del template)

**Una vez tengas el template correcto:** Pasos 5-6 son 100% automatizados (4 minutos total)

---

## 🎯 Beneficios de Este Flujo

### ✅ Ventajas
- **Formato oficial:** Usas el YAML exacto de Microsoft
- **Reproducible:** Una vez modificado el template, crear agentes es automático
- **Versionado:** Todo queda en Git
- **Escalable:** Puedes crear múltiples agentes desde el mismo template
- **Deploy automatizado:** Scripts para exportar/importar entre entornos

### ⚠️ Consideraciones
- Requiere crear agente base una vez (por entorno/versión)
- La modificación del template requiere entender el formato YAML
- Algunos features muy avanzados pueden requerir configuración manual post-creación

---

## 🔄 Flujo Simplificado para Siguientes Agentes

Una vez tengas el template:

```powershell
# 1. Modificar template (o crear variación)
code ./templates/retail-agent-v2-template.yaml

# 2. Crear agente
.\scripts\4-crear-agente-retail.ps1 `
    -TemplateFile "./templates/retail-agent-v2-template.yaml" `
    -SchemaName "miemp_agenteRetailV2" `
    -DisplayName "Agente Retail V2"

# 3. Publicar
pac copilot publish --bot "miemp_agenteRetailV2"

# 4. Exportar
.\scripts\export-solution.ps1 -EnvironmentUrl "..."

# 5. Versionar
git add . && git commit -m "feat: agente v2" && git push
```

**Tiempo total: ~5 minutos** 🚀

---

## 📝 Notas Importantes

1. **El agente base solo se crea una vez** por entorno/versión de Copilot Studio
2. **El template extraído es reutilizable** - puedes crear muchos agentes desde él
3. **Guarda tus templates modificados** - son tu "código fuente"
4. **Versiona los templates en Git** - junto con los JSONs de referencia
5. **Documenta las modificaciones** que hagas al template base

---

## 🆘 Troubleshooting

### Error: "File not found"
→ Verifica rutas en el template YAML (deben ser relativas o no incluir rutas)

### Error: "Schema name already exists"
→ Cambia el parámetro `-SchemaName` a uno único

### Error: "Solution not found"
→ Verifica que la solución existe: `pac solution list`

### Template extraído vacío o incompleto
→ Asegúrate que el agente base esté publicado antes de extraer

---

## 🎓 Aprende Más

- **Templates YAML:** Extrae templates de diferentes agentes para ver variaciones
- **Comparación:** Usa `git diff` para comparar templates extraídos
- **Biblioteca:** Crea una colección de templates para diferentes tipos de agentes

---

**¿Listo para empezar?**

```powershell
# Ver el checklist:
cat .\scripts\1-crear-agente-base.md
```
