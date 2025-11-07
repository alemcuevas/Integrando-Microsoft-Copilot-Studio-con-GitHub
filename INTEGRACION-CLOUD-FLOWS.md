# 🔄 Integración de Cloud Flows con el Agente de Retail

## 🎯 Objetivo
Integrar Power Automate (Cloud Flows) con el agente para automatizar procesos como:
- Enviar emails de confirmación
- Registrar consultas en SharePoint/Dataverse
- Notificar a equipos de ventas
- Consultar APIs externas

---

## 📋 Casos de Uso para el Agente de Retail

### 1. 📧 Enviar Email de Cotización
**Trigger:** Cuando el usuario solicita información de precio
**Acción:** Enviar email al equipo de ventas con los detalles

### 2. 📝 Registrar Consulta en Dataverse
**Trigger:** Cualquier interacción con el agente
**Acción:** Guardar en tabla de CRM para seguimiento

### 3. 🔔 Notificar Escalación
**Trigger:** Cuando se transfiere a agente humano
**Acción:** Enviar notificación por Teams

### 4. 📊 Consultar Inventario Real
**Trigger:** Verificar inventario
**Acción:** Llamar API del sistema de inventario

---

## 🛠️ Métodos de Integración

### Método 1: Crear Flow en Power Automate

#### Paso 1: Crear el Flow

1. Ir a https://make.powerautomate.com
2. Click en **"+ Create"** → **"Instant cloud flow"**
3. Seleccionar trigger: **"Microsoft Copilot Studio"**
4. Agregar acciones necesarias
5. **Importante:** Agregar a la solución `MyRetailAgent`

#### Paso 2: Agregar Input/Output Parameters

**Inputs (desde el agente):**
- `ProductName` (String)
- `CustomerEmail` (String)
- `StoreLocation` (String)

**Outputs (al agente):**
- `ConfirmationMessage` (String)
- `ReferenceNumber` (String)

#### Paso 3: Guardar en la Solución

1. En el flow, click en **"..."** → **"Add to solution"**
2. Seleccionar **"MyRetailAgent"**
3. Guardar

### Método 2: Llamar Flow desde Topic

Una vez creado el flow, agrégalo al topic:

```yaml
- kind: DialogComponent
  displayName: Consulta de Productos con Flow
  dialog:
    beginDialog:
      kind: OnRecognizedIntent
      actions:
        - kind: Question
          id: question_product
          variable: Topic.ProductName
          prompt: ¿Qué producto te interesa?
          entity: StringPrebuiltEntity

        - kind: Question
          id: question_email
          variable: Topic.CustomerEmail
          prompt: ¿Cuál es tu email?
          entity: EmailPrebuiltEntity

        # Llamar Cloud Flow
        - kind: InvokeFlowAction
          id: invoke_flow
          flowId: "GUID-DEL-FLOW"
          input:
            ProductName: =Topic.ProductName
            CustomerEmail: =Topic.CustomerEmail
          output: Topic.FlowResponse

        - kind: SendActivity
          id: send_confirmation
          activity: Gracias, hemos enviado la información a {Topic.CustomerEmail}. Tu número de referencia es {Topic.FlowResponse.ReferenceNumber}
```

---

## 📦 Ejemplo de Flow: Registrar Consulta

### Flow Name: "Registrar Consulta de Cliente"

**Trigger:** Microsoft Copilot Studio
- Input: `ProductName` (String)
- Input: `CustomerEmail` (String)
- Input: `ConsultationType` (String)

**Acciones:**

1. **Compose - Generate Reference Number**
   ```
   concat('REF-', formatDateTime(utcNow(), 'yyyyMMddHHmmss'))
   ```

2. **Create a new record (Dataverse)**
   - Table: `Consultas`
   - Fields:
     - Producto: `@{triggerBody()['text']}`
     - Email: `@{triggerBody()['text_1']}`
     - Fecha: `utcNow()`
     - Número de Referencia: `@{outputs('Compose')}`

3. **Send an email (V2)**
   - To: Equipo de ventas
   - Subject: Nueva consulta de cliente
   - Body:
     ```
     Cliente: @{triggerBody()['text_1']}
     Producto: @{triggerBody()['text']}
     Referencia: @{outputs('Compose')}
     ```

4. **Respond to Copilot Studio**
   - Output: `ConfirmationMessage` = "Consulta registrada exitosamente"
   - Output: `ReferenceNumber` = `@{outputs('Compose')}`

---

## 🔧 Crear Flow desde CLI/Git

### Limitaciones
❌ No se puede crear flows 100% desde YAML/CLI
✅ Pero sí se pueden:
1. Exportar flows existentes con la solución
2. Versionarlos en Git
3. Importarlos en otros entornos

### Estructura en la Solución

Cuando exportes la solución con flows:

```
solution/MyRetailAgent/
├── Workflows/
│   └── RegistrarConsultaCliente.json
├── bots/
│   └── miemp_asistenteVentasRetail/
└── botcomponents/
```

---

## 📝 Script para Crear Flow Básico

```powershell
# crear-flow-ejemplo.ps1

Write-Host "Guía para crear Cloud Flow para el Agente" -ForegroundColor Cyan

Write-Host @"

1. Ir a: https://make.powerautomate.com

2. Click en '+ Create' → 'Instant cloud flow'

3. Configurar:
   Name: Registrar Consulta de Cliente
   Trigger: Microsoft Copilot Studio
   
4. Agregar inputs:
   - ProductName (String)
   - CustomerEmail (String)
   
5. Agregar acciones:
   - Compose: Generate Reference Number
   - Create record en Dataverse
   - Send email
   - Respond to Copilot Studio
   
6. Guardar en solución 'MyRetailAgent'

7. Copiar el Flow ID para usarlo en el topic

"@

Write-Host "`nPresiona Enter para abrir Power Automate..." -NoNewline
Read-Host
Start-Process "https://make.powerautomate.com"
```

---

## 🎯 Topics que se Benefician de Flows

### 1. Información de Precios
**Flow:** Consultar precios en tiempo real desde ERP
```yaml
- kind: InvokeFlowAction
  flowId: "precio-real-time-flow"
  input:
    ProductSKU: =Topic.ProductName
  output: Topic.PriceInfo
```

### 2. Verificar Inventario
**Flow:** Consultar sistema de inventario
```yaml
- kind: InvokeFlowAction
  flowId: "check-inventory-flow"
  input:
    ProductName: =Topic.ProductName
    StoreLocation: =Topic.StoreLocation
  output: Topic.InventoryStatus
```

### 3. Transferir a Agente Humano
**Flow:** Crear ticket en sistema de CRM y notificar por Teams
```yaml
- kind: InvokeFlowAction
  flowId: "escalate-to-agent-flow"
  input:
    CustomerName: =Global.CustomerName
    Issue: =Topic.CustomerIssue
  output: Topic.TicketNumber
```

---

## 📊 Exportar Solución con Flows

```powershell
# El script export-solution.ps1 ya exporta los flows automáticamente

.\scripts\export-solution.ps1 `
  -EnvironmentUrl "https://orgce8fe757.crm.dynamics.com/" `
  -SolutionName "MyRetailAgent"

# Los flows se exportarán en:
# solution/MyRetailAgent/Workflows/
```

---

## ✅ Checklist para Integrar Flows

- [ ] Identificar procesos a automatizar
- [ ] Crear flows en Power Automate
- [ ] Agregar flows a la solución MyRetailAgent
- [ ] Configurar inputs/outputs
- [ ] Obtener Flow ID
- [ ] Actualizar topics para invocar flows
- [ ] Probar en Test Chat
- [ ] Exportar solución completa
- [ ] Versionar en Git

---

## 🚀 Próximo Paso Recomendado

**Crear un flow simple de ejemplo:**

1. **Flow:** "Enviar Confirmación de Consulta"
   - Trigger: Microsoft Copilot Studio
   - Input: Email del cliente
   - Acción: Enviar email de confirmación
   - Output: Mensaje de éxito

2. **Integrar en topic "Información de Precios"**

3. **Exportar y versionar**

---

**¿Te gustaría que creemos un flow de ejemplo específico para el agente de retail?**
