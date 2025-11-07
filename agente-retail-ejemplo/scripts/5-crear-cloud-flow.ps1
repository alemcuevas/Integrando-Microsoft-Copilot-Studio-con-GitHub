# Script: Crear Cloud Flow de Ejemplo para Agente de Retail
# Descripción: Guía paso a paso para crear un flow que envía email cuando se consulta precio

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Crear Cloud Flow: Enviar Email de Cotización" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Host "🎯 OBJETIVO" -ForegroundColor Yellow
Write-Host "Crear un flow que se active cuando un cliente consulta precios" -ForegroundColor White
Write-Host "y envíe un email al equipo de ventas con los detalles." -ForegroundColor White
Write-Host ""

Write-Host "📋 PASOS A SEGUIR:" -ForegroundColor Yellow
Write-Host ""

Write-Host "PASO 1: Abrir Power Automate" -ForegroundColor Cyan
Write-Host "  ➜ Se abrirá en tu navegador..." -ForegroundColor Gray
Write-Host ""

Start-Sleep -Seconds 2
Start-Process "https://make.powerautomate.com"

Write-Host "PASO 2: Crear el Flow" -ForegroundColor Cyan
Write-Host "  1. Click en '+ Create' (arriba izquierda)" -ForegroundColor White
Write-Host "  2. Seleccionar 'Instant cloud flow'" -ForegroundColor White
Write-Host "  3. En 'Flow name': EnviarEmailCotizacion" -ForegroundColor White
Write-Host "  4. En 'Choose how to trigger': Buscar 'Microsoft Copilot Studio'" -ForegroundColor White
Write-Host "  5. Click 'Create'" -ForegroundColor White
Write-Host ""
Read-Host "Presiona Enter cuando hayas creado el flow base"

Write-Host ""
Write-Host "PASO 3: Configurar el Trigger" -ForegroundColor Cyan
Write-Host "  El trigger 'Microsoft Copilot Studio' ya está agregado" -ForegroundColor White
Write-Host "  Vamos a agregar los inputs (parámetros de entrada)" -ForegroundColor White
Write-Host ""
Write-Host "  Click en el trigger → '+ Add an input' → Agregar:" -ForegroundColor White
Write-Host "    • Text → Name: ProductName → Title: Nombre del Producto" -ForegroundColor Gray
Write-Host "    • Text → Name: CustomerName → Title: Nombre del Cliente" -ForegroundColor Gray
Write-Host "    • Email → Name: CustomerEmail → Title: Email del Cliente" -ForegroundColor Gray
Write-Host "    • Text → Name: StoreLocation → Title: Ubicación de Tienda" -ForegroundColor Gray
Write-Host ""
Read-Host "Presiona Enter cuando hayas agregado los 4 inputs"

Write-Host ""
Write-Host "PASO 4: Agregar Acción - Generar Número de Referencia" -ForegroundColor Cyan
Write-Host "  1. Click '+ New step'" -ForegroundColor White
Write-Host "  2. Buscar 'Compose'" -ForegroundColor White
Write-Host "  3. En 'Inputs' ingresar la siguiente expresión:" -ForegroundColor White
Write-Host ""
Write-Host "     concat('COT-', formatDateTime(utcNow(), 'yyyyMMddHHmmss'))" -ForegroundColor Yellow
Write-Host ""
Write-Host "  4. Renombrar la acción a: 'Generar Número de Referencia'" -ForegroundColor White
Write-Host ""
Read-Host "Presiona Enter cuando hayas agregado la acción Compose"

Write-Host ""
Write-Host "PASO 5: Agregar Acción - Enviar Email" -ForegroundColor Cyan
Write-Host "  1. Click '+ New step'" -ForegroundColor White
Write-Host "  2. Buscar 'Send an email (V2)' de Office 365 Outlook" -ForegroundColor White
Write-Host "  3. Configurar:" -ForegroundColor White
Write-Host ""
Write-Host "     To: ventas@tuempresa.com" -ForegroundColor Gray
Write-Host "     Subject: Nueva Consulta de Precio - {Dynamic: ProductName}" -ForegroundColor Gray
Write-Host ""
Write-Host "     Body:" -ForegroundColor Gray
Write-Host "     -------" -ForegroundColor DarkGray
Write-Host "     Nueva consulta de precio recibida:" -ForegroundColor DarkGray
Write-Host ""
Write-Host "     Cliente: {Dynamic: CustomerName}" -ForegroundColor DarkGray
Write-Host "     Email: {Dynamic: CustomerEmail}" -ForegroundColor DarkGray
Write-Host "     Producto: {Dynamic: ProductName}" -ForegroundColor DarkGray
Write-Host "     Tienda: {Dynamic: StoreLocation}" -ForegroundColor DarkGray
Write-Host "     Número de Referencia: {Dynamic: Outputs('Generar Número de Referencia')}" -ForegroundColor DarkGray
Write-Host "     Fecha: {Dynamic: utcNow()}" -ForegroundColor DarkGray
Write-Host ""
Write-Host "     Por favor, contactar al cliente a la brevedad." -ForegroundColor DarkGray
Write-Host "     -------" -ForegroundColor DarkGray
Write-Host ""
Read-Host "Presiona Enter cuando hayas configurado el email"

Write-Host ""
Write-Host "PASO 6: Agregar Acción - Responder a Copilot Studio" -ForegroundColor Cyan
Write-Host "  1. Click '+ New step'" -ForegroundColor White
Write-Host "  2. Buscar 'Respond to Copilot Studio' (mismo conector)" -ForegroundColor White
Write-Host "  3. Click '+ Add an output' → Agregar:" -ForegroundColor White
Write-Host "    • Text → Name: ConfirmationMessage → Value:" -ForegroundColor Gray
Write-Host "      'Hemos enviado tu consulta al equipo de ventas.'" -ForegroundColor Yellow
Write-Host ""
Write-Host "    • Text → Name: ReferenceNumber → Value:" -ForegroundColor Gray
Write-Host "      {Dynamic: Outputs('Generar Número de Referencia')}" -ForegroundColor Yellow
Write-Host ""
Read-Host "Presiona Enter cuando hayas configurado la respuesta"

Write-Host ""
Write-Host "PASO 7: Guardar y Agregar a Solución" -ForegroundColor Cyan
Write-Host "  1. Click 'Save' (arriba derecha)" -ForegroundColor White
Write-Host "  2. Click en los '...' (3 puntos) → 'Add to solution'" -ForegroundColor White
Write-Host "  3. Seleccionar 'MyRetailAgent'" -ForegroundColor White
Write-Host "  4. Click 'Add'" -ForegroundColor White
Write-Host ""
Read-Host "Presiona Enter cuando hayas agregado a la solución"

Write-Host ""
Write-Host "PASO 8: Copiar el Flow ID" -ForegroundColor Cyan
Write-Host "  1. En la barra de direcciones del navegador, copiar el ID del flow" -ForegroundColor White
Write-Host "     URL: .../flows/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/..." -ForegroundColor Gray
Write-Host ""
Write-Host "  Pega el Flow ID aquí:" -ForegroundColor Yellow
$flowId = Read-Host

Write-Host ""
Write-Host "✓ Flow ID guardado: $flowId" -ForegroundColor Green
Write-Host ""

# Guardar el Flow ID para usarlo después
$flowId | Out-File -FilePath ".\flow-id.txt" -Encoding UTF8

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✓ Flow Creado Exitosamente!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Host "PRÓXIMOS PASOS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Actualizar el topic 'Información de Precios' para llamar al flow" -ForegroundColor White
Write-Host "2. Exportar la solución con el flow incluido" -ForegroundColor White
Write-Host "3. Versionar en Git" -ForegroundColor White
Write-Host ""

Write-Host "Flow ID guardado en: .\flow-id.txt" -ForegroundColor Gray
Write-Host ""

Write-Host "¿Quieres actualizar el topic ahora? (S/N): " -ForegroundColor Cyan -NoNewline
$updateTopic = Read-Host

if ($updateTopic -eq 'S' -or $updateTopic -eq 's') {
    Write-Host ""
    Write-Host "Actualizando template YAML..." -ForegroundColor Cyan
    
    # Aquí podrías agregar código para actualizar el template
    Write-Host ""
    Write-Host "ℹ️  Para agregar el flow al topic, usa esta sintaxis en el YAML:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host @"
- kind: InvokeFlowAction
  id: invoke_email_flow
  flowId: "$flowId"
  input:
    ProductName: =Topic.ProductForPrice
    CustomerName: =Global.CustomerName
    CustomerEmail: =Global.CustomerEmail
    StoreLocation: =Global.PreferredLocation
  output: Topic.FlowResponse

- kind: SendActivity
  id: send_confirmation
  activity: {Topic.FlowResponse.ConfirmationMessage} Tu número de referencia es {Topic.FlowResponse.ReferenceNumber}
"@ -ForegroundColor Gray
    
    Write-Host ""
    Write-Host "Copia esto y agrégalo al topic 'Información de Precios' en el template." -ForegroundColor White
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Script Completado" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
