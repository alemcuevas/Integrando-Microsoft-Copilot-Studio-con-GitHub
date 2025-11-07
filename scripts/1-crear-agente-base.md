# Paso 1: Crear Agente Base para Template

## 🎯 Objetivo
Crear un agente simple en Copilot Studio para extraer su template YAML y usarlo como base.

## 📋 Instrucciones

### 1. Abrir Copilot Studio
Ve a: **https://copilotstudio.microsoft.com**

### 2. Crear Nuevo Agente
1. Click en **"Create"** o **"+ New copilot"**
2. Selecciona **"Skip to configure"** (saltar configuración inicial)

### 3. Configuración del Agente Base

**Información básica:**
- **Name**: `TemplateBase`
- **Description**: `Agente base para extraer template YAML`
- **Language**: Español
- **Icon**: (cualquiera)

**Importante:** En la sección de solución:
- **Add to solution**: Selecciona `MyRetailAgent`

### 4. Crear un Topic Simple

Después de crear el agente:

1. Ve a **Topics** en el menú lateral
2. Click en **+ New topic** → **From blank**
3. Configura el topic:
   - **Name**: `Consulta de Producto`
   - **Display name**: `Consulta de Producto`
   - **Description**: `Topic simple para consultar productos`

4. Agrega **Trigger phrases**:
   ```
   quiero ver productos
   mostrar productos
   ver catálogo
   productos disponibles
   ```

5. Agrega un **Message node**:
   ```
   ¡Hola! Puedo ayudarte a consultar nuestros productos. ¿Qué tipo de producto buscas?
   ```

6. Agrega un **Question node**:
   - **Identify**: Product (texto)
   - **Save response as**: `ProductName`
   - **Question text**: `¿Qué producto te interesa?`

7. Agrega otro **Message node**:
   ```
   Excelente, buscando información sobre {ProductName}...
   ```

8. **Save** el topic

### 5. (Opcional) Crear un Topic de Saludo

1. Click en **+ New topic** → **From blank**
2. Nombre: `Saludo`
3. Trigger phrases:
   ```
   hola
   buenos días
   buenas tardes
   ayuda
   ```
4. Message: `¡Hola! Soy el asistente base. ¿En qué puedo ayudarte?`
5. **Save**

### 6. Publicar el Agente

1. Click en **Publish** (arriba a la derecha)
2. Click en **Publish** nuevamente en el diálogo
3. Espera a que se complete la publicación

### 7. Verificar en CLI

Abre PowerShell y ejecuta:

```powershell
pac copilot list
```

Deberías ver tu agente `TemplateBase` listado.

---

## ✅ Checklist

- [ ] Agente `TemplateBase` creado
- [ ] Agregado a solución `MyRetailAgent`
- [ ] Topic `Consulta de Producto` creado con trigger phrases
- [ ] Agente publicado
- [ ] Verificado con `pac copilot list`

---

## ➡️ Siguiente Paso

Una vez completado, ejecuta el script:
```powershell
.\scripts\2-extraer-template.ps1
```

O continúa con **Paso 2: Extraer Template**
