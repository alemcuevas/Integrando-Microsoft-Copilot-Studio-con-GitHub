# Guía de Importación a Copilot Studio

## Introducción

Este documento te guiará paso a paso en el proceso de importar el **Agente de Retail** a Microsoft Copilot Studio.

---

## Métodos de Importación

### Método 1: Importación mediante Power Platform CLI (Recomendado)

Este método es más rápido y automatizado.

#### Prerrequisitos

1. **Power Platform CLI instalado**
   - Descarga desde: https://aka.ms/PowerPlatformCLI
   - Verifica la instalación:
     ```powershell
     pac --version
     ```

2. **Acceso a Power Platform**
   - Cuenta de Microsoft con licencia de Copilot Studio
   - Permisos de creador en el entorno

#### Pasos de Importación

**1. Autenticarse en Power Platform**

```powershell
# Autenticarse con tu entorno
pac auth create --url https://[tu-entorno].crm.dynamics.com

# Ejemplo:
# pac auth create --url https://org12345.crm.dynamics.com
```

**2. Navegar al directorio del agente**

```powershell
cd "c:\Users\alemartinez\Integrando-Microsoft-Copilot-Studio-con-GitHub\agente-retail-ejemplo"
```

**3. Importar el agente**

```powershell
# Sintaxis básica
pac copilot import --path .

# Con nombre específico
pac copilot import --path . --name "Agente Retail Asistente"

# Con entorno específico
pac copilot import --path . --environment [environment-id]
```

**4. Verificar la importación**

```powershell
# Listar agentes
pac copilot list
```

---

### Método 2: Importación Manual desde la Interfaz Web

Este método requiere más pasos manuales pero ofrece más control.

#### Paso 1: Preparar archivos

1. Asegúrate de tener todos los archivos del agente en tu computadora
2. Estructura esperada:
   ```
   agente-retail-ejemplo/
   ├── bot.json
   ├── topics/
   ├── entities/
   └── variables/
   ```

#### Paso 2: Crear nuevo agente en Copilot Studio

1. Ir a https://copilotstudio.microsoft.com
2. Iniciar sesión con tu cuenta de Microsoft
3. Seleccionar el entorno correcto (esquina superior derecha)
4. Hacer clic en **"Create"** o **"Crear"**
5. Seleccionar **"New agent"** o **"Nuevo agente"**
6. Seleccionar **"Start with a blank canvas"** o **"Comenzar desde cero"**

#### Paso 3: Configurar información básica

1. **Nombre**: Agente de Retail - Asistente de Ventas
2. **Lenguaje**: Español (España) o Español (México)
3. **Descripción**: Asistente virtual para retail
4. Hacer clic en **"Create"**

#### Paso 4: Importar entidades personalizadas

1. En el panel izquierdo, ir a **"Entities"**
2. Hacer clic en **"+ New entity"** > **"From file"**
3. Importar:
   - `entities/ProductCategory.entity.json`
   - `entities/StoreLocation.entity.json`

#### Paso 5: Configurar variables globales

1. Ir a **"Variables"** en el panel izquierdo
2. Hacer clic en **"+ New variable"**
3. Crear las siguientes variables globales:
   - CustomerName (Texto)
   - CustomerEmail (Texto)
   - CustomerPhone (Texto)
   - PreferredCategory (Texto)
   - PreferredLocation (Texto)
   - CurrentProduct (Texto)

#### Paso 6: Importar topics

Para cada archivo en la carpeta `topics/`:

1. Ir a **"Topics"** en el panel izquierdo
2. Hacer clic en **"+ New topic"** > **"From blank"**
3. Copiar manualmente la estructura del JSON al diseñador visual de Copilot Studio

**Topics a importar (en orden):**
1. `greeting.topic.json` - Saludo
2. `product-inquiry.topic.json` - Consulta de productos
3. `check-inventory.topic.json` - Verificar inventario
4. `pricing-info.topic.json` - Información de precios
5. `recommendations.topic.json` - Recomendaciones
6. `store-locations.topic.json` - Ubicaciones
7. `returns-policy.topic.json` - Política de devoluciones
8. `escalation.topic.json` - Escalamiento
9. `fallback.topic.json` - Respuesta por defecto

---

### Método 3: Importación como Solución de Power Platform

Este método es útil para ambientes empresariales.

#### Pasos:

**1. Crear solución**

```powershell
# Crear una nueva solución
pac solution init --publisher-name MiEmpresa --publisher-prefix emp

# Agregar el agente a la solución
pac solution add-reference --path .
```

**2. Empaquetar solución**

```powershell
pac solution pack --zipfile "AgentRetail.zip" --folder .
```

**3. Importar en Power Platform**

1. Ir a https://make.powerapps.com
2. Seleccionar **"Solutions"**
3. Hacer clic en **"Import solution"**
4. Subir el archivo `AgentRetail.zip`
5. Seguir el asistente de importación

---

## Configuración Post-Importación

### 1. Configurar conexiones a APIs (Opcional)

Si deseas conectar el agente con sistemas reales:

1. Ir a **"Topics"** > Seleccionar un topic con Action Nodes
2. Configurar los conectores necesarios:
   - **Sistema de inventario**: Para verificación de stock real
   - **Sistema POS**: Para precios actualizados
   - **CRM**: Para gestión de clientes
   - **Email**: Para notificaciones

### 2. Configurar escalamiento a agentes humanos

1. Ir al topic **"Escalation"**
2. En el nodo de transferencia:
   - Configurar integración con Omnichannel for Customer Service
   - O configurar webhook a sistema de tickets

### 3. Personalizar mensajes

1. Revisar cada topic
2. Ajustar mensajes según la voz de tu marca
3. Actualizar:
   - Nombres de tiendas
   - Direcciones
   - Números de teléfono
   - URLs

### 4. Configurar canales de publicación

1. Ir a **"Channels"** o **"Canales"**
2. Activar los canales deseados:
   - Website
   - Microsoft Teams
   - Facebook Messenger
   - WhatsApp (requiere configuración adicional)

---

## Pruebas

### Probar en el panel de pruebas

1. En Copilot Studio, hacer clic en **"Test your bot"**
2. Probar flujos de conversación:
   - Saludo inicial
   - Búsqueda de productos
   - Verificación de inventario
   - Consulta de precios
   - Escalamiento

### Frases de prueba sugeridas:

```
Hola
Busco una laptop
¿Tienen en stock zapatillas Nike?
Cuánto cuesta el iPhone 15?
Recomiéndame un producto
Dónde están ubicados?
Quiero devolver un producto
Hablar con un agente
```

---

## Solución de Problemas

### Error: "Invalid schema version"

**Causa**: Versión incompatible del esquema

**Solución**:
- Actualizar Power Platform CLI a la última versión
- Verificar que el entorno soporte la versión del esquema

### Error: "Entity not found"

**Causa**: Las entidades no se importaron correctamente

**Solución**:
1. Importar manualmente las entidades primero
2. Luego importar los topics que las usan

### Error: "Missing variables"

**Causa**: Variables globales no definidas

**Solución**:
1. Crear las variables globales manualmente
2. Usar nombres exactos como en `global-variables.json`

### Topics no se muestran correctamente

**Causa**: El formato JSON no es compatible con la versión de Copilot Studio

**Solución**:
- Recrear los topics usando el diseñador visual
- Usar los JSON como guía de la estructura

---

## Mejores Prácticas

### Antes de importar:

✅ Revisa que tengas permisos adecuados en el entorno
✅ Verifica la versión de Copilot Studio
✅ Haz backup de cualquier agente existente
✅ Documenta las personalizaciones necesarias

### Después de importar:

✅ Prueba todos los flujos de conversación
✅ Configura las integraciones necesarias
✅ Personaliza los mensajes a tu marca
✅ Capacita al equipo en el uso del agente
✅ Monitorea las interacciones iniciales

---

## Recursos Adicionales

### Documentación oficial:
- [Power Platform CLI](https://docs.microsoft.com/en-us/power-platform/developer/cli/introduction)
- [Copilot Studio](https://docs.microsoft.com/en-us/microsoft-copilot-studio/)
- [Import/Export Bots](https://docs.microsoft.com/en-us/microsoft-copilot-studio/authoring-export-import-bots)

### Videos tutoriales:
- [YouTube: Copilot Studio Basics](https://www.youtube.com/copilot-studio)
- [Microsoft Learn: Copilot Studio Learning Path](https://learn.microsoft.com/training/copilot-studio)

### Comunidad:
- [Power Platform Community](https://powerusers.microsoft.com/)
- [Copilot Studio Forum](https://powerusers.microsoft.com/t5/Microsoft-Copilot-Studio/bd-p/CopilotStudio)

---

## Soporte

Si encuentras problemas durante la importación:

1. Consulta la sección de **Solución de Problemas** arriba
2. Revisa los logs de importación en Power Platform
3. Consulta la documentación oficial
4. Contacta al administrador de tu entorno

---

**Última actualización**: Noviembre 2025
**Versión del agente**: 1.0.0
**Compatible con**: Copilot Studio 2024+
