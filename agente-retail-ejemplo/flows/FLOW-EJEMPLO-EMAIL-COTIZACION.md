# 📧 Flow de Ejemplo: Enviar Email de Cotización

## 📋 Resumen

**Nombre:** EnviarEmailCotizacion  
**Trigger:** Microsoft Copilot Studio  
**Propósito:** Enviar email al equipo de ventas cuando un cliente consulta precios

---

## 🔧 Estructura del Flow

### 1️⃣ Trigger: Microsoft Copilot Studio

**Inputs:**
- `ProductName` (Text) - Nombre del producto consultado
- `CustomerName` (Text) - Nombre del cliente
- `CustomerEmail` (Email) - Email del cliente
- `StoreLocation` (Text) - Ubicación de tienda preferida

---

### 2️⃣ Acción: Compose - Generar Número de Referencia

**Nombre:** Generar Número de Referencia

**Expression:**
```
concat('COT-', formatDateTime(utcNow(), 'yyyyMMddHHmmss'))
```

**Resultado:** `COT-20251106152330`

---

### 3️⃣ Acción: Send an email (V2)

**Connector:** Office 365 Outlook

**Configuración:**

| Campo | Valor |
|-------|-------|
| **To** | ventas@tuempresa.com |
| **Subject** | Nueva Consulta de Precio - `{ProductName}` |
| **Body** | Ver plantilla abajo ⬇️ |

**Plantilla del Email:**

```
Nueva consulta de precio recibida:

Cliente: {CustomerName}
Email: {CustomerEmail}
Producto: {ProductName}
Tienda: {StoreLocation}
Número de Referencia: {Outputs('Generar Número de Referencia')}
Fecha: {utcNow()}

Por favor, contactar al cliente a la brevedad.

---
Este mensaje fue generado automáticamente por el Asistente de Ventas Retail.
```

---

### 4️⃣ Acción: Respond to Copilot Studio

**Outputs:**

| Nombre | Tipo | Valor |
|--------|------|-------|
| `ConfirmationMessage` | Text | "Hemos enviado tu consulta al equipo de ventas." |
| `ReferenceNumber` | Text | `{Outputs('Generar Número de Referencia')}` |

---

## 🎯 Integración con el Agente

### Actualizar Topic: Información de Precios

Agregar estas acciones después de preguntar por el producto:

```yaml
# Obtener información del cliente
- kind: Question
  id: question_customer_name
  variable: Global.CustomerName
  prompt: ¿Cuál es tu nombre?
  entity: PersonNamePrebuiltEntity

- kind: Question
  id: question_customer_email
  variable: Global.CustomerEmail
  prompt: ¿Cuál es tu email para enviarte la cotización?
  entity: EmailPrebuiltEntity

# Llamar al Cloud Flow
- kind: InvokeFlowAction
  id: invoke_email_flow
  flowId: "FLOW-ID-AQUI"  # Reemplazar con el ID real del flow
  input:
    ProductName: =Topic.ProductForPrice
    CustomerName: =Global.CustomerName
    CustomerEmail: =Global.CustomerEmail
    StoreLocation: =Global.PreferredLocation
  output: Topic.FlowResponse

# Confirmar al usuario
- kind: SendActivity
  id: send_confirmation
  activity: |
    ✓ {Topic.FlowResponse.ConfirmationMessage}
    
    📧 Te enviaremos la cotización a {Global.CustomerEmail}
    📝 Tu número de referencia es: {Topic.FlowResponse.ReferenceNumber}
    
    ¿Hay algo más en lo que pueda ayudarte?
```

---

## 🧪 Probar el Flow

### Desde Power Automate

1. Ir al flow en Power Automate
2. Click en "Test" (arriba derecha)
3. Seleccionar "Manually"
4. Ingresar valores de prueba:
   - ProductName: "Laptop Dell XPS"
   - CustomerName: "Juan Pérez"
   - CustomerEmail: "juan@example.com"
   - StoreLocation: "Tienda Centro"
5. Click "Run flow"
6. Verificar que se envió el email

### Desde el Agente

1. Ir a https://copilotstudio.microsoft.com
2. Abrir "Asistente de Ventas Retail"
3. En Test Chat:
   ```
   Usuario: cuánto cuesta una laptop
   Bot: ¿De qué producto deseas conocer el precio?
   Usuario: Laptop Dell XPS
   Bot: ¿Cuál es tu nombre?
   Usuario: Juan Pérez
   Bot: ¿Cuál es tu email para enviarte la cotización?
   Usuario: juan@example.com
   Bot: ✓ Hemos enviado tu consulta...
   ```
4. Verificar email recibido

---

## 📦 Exportar con la Solución

El flow se exportará automáticamente con la solución:

```powershell
.\scripts\export-solution.ps1 `
  -EnvironmentUrl "https://orgce8fe757.crm.dynamics.com/" `
  -SolutionName "MyRetailAgent"
```

**Ubicación en la solución:**
```
solution/MyRetailAgent/
├── Workflows/
│   └── EnviarEmailCotizacion-{GUID}.json
├── bots/
└── botcomponents/
```

---

## 🔄 Variaciones del Flow

### Opción 1: Guardar en Dataverse

Agregar antes de "Send email":

**Acción:** Create a new record (Dataverse)

- **Table:** Consultas (crear esta tabla primero)
- **Fields:**
  - Producto: `{ProductName}`
  - Cliente: `{CustomerName}`
  - Email: `{CustomerEmail}`
  - Referencia: `{Outputs('Generar Número de Referencia')}`
  - Fecha: `{utcNow()}`

### Opción 2: Notificar por Teams

Agregar después de "Send email":

**Acción:** Post message in a chat or channel (Teams)

- **Post as:** Flow bot
- **Post in:** Channel
- **Team:** Ventas
- **Channel:** Consultas
- **Message:** 
  ```
  🔔 Nueva consulta de precio
  
  Cliente: {CustomerName}
  Producto: {ProductName}
  Ref: {Outputs('Generar Número de Referencia')}
  ```

### Opción 3: Consultar API de Precios

Agregar antes de "Send email":

**Acción:** HTTP

- **Method:** GET
- **URI:** `https://api.tuempresa.com/precios?producto={ProductName}`
- **Headers:** Authorization: Bearer {token}

Luego usar la respuesta en el email.

---

## ✅ Checklist de Implementación

- [ ] Crear flow en Power Automate
- [ ] Configurar trigger con 4 inputs
- [ ] Agregar acción Compose (número de referencia)
- [ ] Agregar acción Send email
- [ ] Agregar acción Respond to Copilot Studio
- [ ] Guardar y agregar a solución MyRetailAgent
- [ ] Copiar Flow ID
- [ ] Actualizar topic Información de Precios
- [ ] Probar desde Power Automate
- [ ] Probar desde el agente
- [ ] Exportar solución
- [ ] Versionar en Git

---

## 🆘 Troubleshooting

### Error: "Flow not found"
✅ Verificar que el Flow ID es correcto y que el flow está en la misma solución

### Error: "Invalid inputs"
✅ Verificar que los nombres de inputs coinciden exactamente (ProductName, CustomerName, etc.)

### Email no se envía
✅ Verificar permisos en Office 365 Outlook
✅ Revisar el historial de ejecución del flow

---

**📝 Nota:** Este es un flow de ejemplo. En producción, considera:
- Validación de datos
- Manejo de errores
- Límites de rate limiting
- Seguridad de datos del cliente
- Cumplimiento de GDPR/privacidad
