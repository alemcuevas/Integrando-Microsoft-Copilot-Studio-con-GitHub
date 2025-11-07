# 🗑️ Guía para Eliminar Agentes Duplicados

## 🎯 Objetivo
Eliminar los agentes duplicados del entorno y dejar solo **"Asistente de Ventas Retail"** (el que está 100% en español).

---

## 📋 Agentes a Eliminar

### 1. ❌ TemplateBase
- **ID:** `f21e25ba-94bb-f011-bbd2-000d3a36e147`
- **Razón:** Era solo para extraer el template, ya no se necesita

### 2. ❌ Agente de Retail - Asistente de Ventas
- **ID:** `03754518-43ce-4433-91db-ccf987760cc7`
- **Razón:** Primera versión, tiene nombres en inglés

### 3. ✅ Asistente de Ventas Retail (MANTENER)
- **ID:** `500b0408-9351-4d48-97ac-93d82b17f5bb`
- **Razón:** Versión final, 100% en español

---

## 🔧 Pasos para Eliminar Agentes

### Método 1: Desde Copilot Studio (Recomendado)

1. **Abrir Copilot Studio:**
   - Ir a: https://copilotstudio.microsoft.com

2. **Eliminar TemplateBase:**
   - En la lista de agentes, buscar "TemplateBase"
   - Click en los **3 puntos** (⋮) al lado del nombre
   - Seleccionar **"Delete"** o **"Eliminar"**
   - Confirmar la eliminación

3. **Eliminar "Agente de Retail - Asistente de Ventas":**
   - En la lista de agentes, buscar "Agente de Retail - Asistente de Ventas"
   - Click en los **3 puntos** (⋮)
   - Seleccionar **"Delete"** o **"Eliminar"**
   - Confirmar la eliminación

4. **Verificar:**
   - Solo debe quedar: **"Asistente de Ventas Retail"**

### Método 2: Desde Power Platform Solution

1. **Abrir Power Platform:**
   - Ir a: https://make.powerapps.com

2. **Ir a Soluciones:**
   - Click en **"Solutions"** en el menú lateral

3. **Abrir MyRetailAgent:**
   - Click en la solución **"MyRetailAgent"**

4. **Ver Componentes:**
   - Verás todos los bots (agentes) en la solución

5. **Eliminar Bots:**
   - Selecciona **"TemplateBase"**
   - Click en **"Remove"** → **"Remove from this solution"**
   - Repite con **"Agente de Retail - Asistente de Ventas"**

6. **Exportar Solución Limpia:**
   - Una vez eliminados, exporta la solución actualizada

---

## ⚡ Verificación con CLI

Después de eliminar desde la UI, ejecuta:

```powershell
# Ver agentes restantes
pac copilot list

# Debería mostrar solo 1 agente:
# Asistente de Ventas Retail
```

---

## 📦 Después de Eliminar

### 1. Exportar Solución Limpia

```powershell
cd C:\Users\alemartinez\Integrando-Microsoft-Copilot-Studio-con-GitHub\agente-retail-ejemplo

.\scripts\export-solution.ps1 `
  -EnvironmentUrl "https://orgce8fe757.crm.dynamics.com/" `
  -SolutionName "MyRetailAgent"
```

### 2. Verificar Componentes

```powershell
# Contar componentes
Get-ChildItem .\solution\MyRetailAgent\botcomponents\ | Measure-Object

# Debería mostrar: Count = 9
```

### 3. Versionar en Git

```powershell
git add .
git commit -m "chore: Eliminar agentes duplicados - Solo Asistente de Ventas Retail en español"
git push
```

---

## 🎯 Resultado Esperado

Después de completar estos pasos:

- ✅ **1 agente:** Asistente de Ventas Retail
- ✅ **9 componentes:** Todos en español
- ✅ **0 duplicados**
- ✅ **Solución limpia y versionada**

---

## 🆘 Si algo sale mal

Si eliminas el agente incorrecto:

```powershell
# Puedes recrearlo desde el template
pac copilot create `
  --schemaName "miemp_asistenteRetailES" `
  --templateFileName "templates/retail-agent-template.yaml" `
  --displayName "Asistente de Ventas Retail" `
  --solution "MyRetailAgent"
```

---

**⏱️ Tiempo estimado:** 2-3 minutos  
**💡 Recomendación:** Hazlo desde Copilot Studio (Método 1), es más rápido y visual.
