# Guía: Crear el Bot en Copilot Studio

## ✅ Pre-requisito Completado
Has creado la solución **MyRetailAgent** exitosamente.

---

## 📝 Paso 1: Crear el Bot en Copilot Studio

### A. Abrir Copilot Studio

1. Ve a: https://copilotstudio.microsoft.com
2. Verifica que estás en el entorno: **Contoso (default)**
3. Haz clic en **"Create"** → **"New agent"**

### B. Configuración Inicial del Bot

**Información Básica:**
- **Name**: `Agente de Retail - Asistente de Ventas`
- **Language**: Español (España) o Español (México)
- **Description**: `Asistente virtual para retail con consultas de productos, inventario, precios y recomendaciones`

**⚠️ CRÍTICO - Agregar a Solución:**
- Busca la opción **"Show advanced options"** o **"Opciones avanzadas"**
- Activa **"Add to a Dataverse solution"**
- Selecciona la solución: **MyRetailAgent**

### C. Crear el Bot

Haz clic en **"Create"** y espera a que se cree (toma 1-2 minutos).

---

## 🏗️ Paso 2: Crear Entidades Personalizadas

Una vez creado el bot, crea las entidades basadas en los archivos JSON:

### Entidad 1: ProductCategory

1. En Copilot Studio, ve a **"Entities"** en el menú lateral
2. Clic en **"+ New entity"** → **"Closed list"**
3. Configuración:
   - **Name**: `ProductCategory`
   - **Description**: `Categorías de productos disponibles`

4. Agregar valores (basados en `entities/ProductCategory.entity.json`):

| Valor Canónico | Sinónimos |
|----------------|-----------|
| `electronica` | electrónica, tecnología, gadgets, celulares, computadoras, tablets |
| `ropa` | ropa y accesorios, vestimenta, moda, calzado, zapatos, tenis |
| `hogar` | hogar y decoración, casa, muebles, cocina, jardín |
| `deportes` | deportes y fitness, deporte, ejercicio, gimnasio, gym |
| `juguetes` | juguetes y juegos, niños, infantil, videojuegos, gaming |
| `belleza` | belleza y cuidado personal, cosméticos, maquillaje, skincare |
| `alimentos` | alimentos y bebidas, comida, bebidas, snacks, dulces |

5. **Guardar** la entidad

### Entidad 2: StoreLocation

1. Clic en **"+ New entity"** → **"Closed list"**
2. Configuración:
   - **Name**: `StoreLocation`
   - **Description**: `Ubicaciones de tiendas físicas y online`

3. Agregar valores (basados en `entities/StoreLocation.entity.json`):

| Valor Canónico | Sinónimos |
|----------------|-----------|
| `centro` | tienda centro, sucursal centro, downtown, zona centro |
| `norte` | tienda norte, sucursal norte, zona norte |
| `sur` | tienda sur, sucursal sur, zona sur |
| `este` | tienda este, sucursal este, zona este, oriente |
| `oeste` | tienda oeste, sucursal oeste, zona oeste, poniente |
| `online` | tienda online, en línea, internet, web, e-commerce |
| `all` | todas, todas las tiendas, cualquiera, la más cercana |

4. **Guardar** la entidad

---

## 🔧 Paso 3: Crear Variables Globales

1. Ve a **"Variables"** en el menú lateral
2. Para cada variable de `variables/global-variables.json`, clic en **"+ New variable"**:

| Nombre | Tipo | Uso |
|--------|------|-----|
| `CustomerName` | String | Nombre del cliente |
| `CustomerEmail` | String | Email del cliente |
| `CustomerPhone` | String | Teléfono del cliente |
| `PreferredCategory` | String | Categoría preferida |
| `PreferredLocation` | String | Ubicación preferida |
| `CurrentProduct` | String | Producto actual |

---

## 💬 Paso 4: Crear Topics

Ahora crea cada topic usando las plantillas JSON como referencia. Aquí está el orden recomendado:

### Topic 1: Greeting (Saludo) ⭐ EMPIEZA AQUÍ

**Referencia**: `topics/greeting.topic.json`

1. Ve a **"Topics"** → **"+ New topic"** → **"From blank"**
2. **Name**: `Greeting`
3. **Trigger phrases**: Agrega estas frases:
   ```
   Hola
   Buenos días
   Buenas tardes
   Hey
   Ayuda
   Inicio
   ```

4. **Diseño del flujo** (nodos):

   **Nodo 1 - Mensaje de bienvenida:**
   - Tipo: **Message**
   - Texto:
   ```
   ¡Hola! 👋 Bienvenido a nuestra tienda. Soy tu asistente virtual de ventas.
   ```

   **Nodo 2 - Capacidades:**
   - Tipo: **Message**
   - Texto:
   ```
   Puedo ayudarte con:

   🔍 Buscar productos
   📦 Verificar disponibilidad
   💰 Consultar precios y promociones
   🎯 Recomendaciones personalizadas
   📍 Ubicaciones de tiendas
   ↩️ Política de devoluciones
   ```

   **Nodo 3 - Pregunta con opciones:**
   - Tipo: **Question**
   - Texto: `¿En qué puedo ayudarte hoy?`
   - **Options for user**:
     - `Buscar un producto` → Redirect to topic: **ProductInquiry**
     - `Verificar disponibilidad` → Redirect to topic: **CheckInventory**
     - `Ver promociones` → Redirect to topic: **PricingInfo**
     - `Ubicación de tiendas` → Redirect to topic: **StoreLocations**

5. **Guardar** el topic

### Topic 2: ProductInquiry (Consulta de Productos)

**Referencia**: `topics/product-inquiry.topic.json`

1. **+ New topic** → **From blank**
2. **Name**: `ProductInquiry`
3. **Trigger phrases**:
   ```
   Buscar producto
   Quiero comprar
   Estoy buscando
   Necesito
   Tienen
   Mostrar productos
   ```

4. **Flujo básico**:
   - **Message**: "¡Perfecto! Te ayudaré a encontrar lo que buscas. 🔍"
   - **Question**: "¿Qué categoría de producto te interesa?"
     - Variable: `Topic.ProductCategory`
     - Entity: `ProductCategory`
   - **Message**: "Excelente elección en {Topic.ProductCategory}"
   - **Question**: "¿Podrías darme más detalles?"
     - Variable: `Topic.ProductDetails`
   - **Message**: "Déjame buscar productos..."
   - (Aquí conectarías una llamada a API o Power Automate Flow)

5. **Guardar**

### Topic 3: CheckInventory (Verificar Inventario)

**Referencia**: `topics/check-inventory.topic.json`

**Trigger phrases**:
```
Hay en stock
Disponibilidad
Tienen disponible
Verificar stock
```

**Flujo clave**:
- Preguntar por el producto
- Preguntar por la ubicación (usar entidad `StoreLocation`)
- Mostrar disponibilidad
- Ofrecer opciones (ver precio, reservar, etc.)

### Topic 4: PricingInfo (Precios)

**Referencia**: `topics/pricing-info.topic.json`

**Trigger phrases**:
```
Precio
Cuánto cuesta
Promoción
Descuento
Oferta
```

### Topic 5: Recommendations (Recomendaciones)

**Referencia**: `topics/recommendations.topic.json`

**Trigger phrases**:
```
Recomiéndame
Qué me sugieres
Productos similares
Novedades
```

### Topic 6: StoreLocations (Ubicaciones)

**Referencia**: `topics/store-locations.topic.json`

**Trigger phrases**:
```
Dónde están
Ubicación
Dirección
Horario
```

### Topic 7: ReturnsPolicy (Devoluciones)

**Referencia**: `topics/returns-policy.topic.json`

**Trigger phrases**:
```
Devolución
Cambio
Garantía
Reembolso
```

### Topic 8: Escalation (Escalamiento)

**Referencia**: `topics/escalation.topic.json`

**Trigger phrases**:
```
Hablar con un humano
Agente humano
Asesor
```

### Topic 9: Fallback (Sistema)

**Referencia**: `topics/fallback.topic.json`

Este es un topic del sistema que se activa cuando el bot no entiende.

---

## 🧪 Paso 5: Probar el Bot

1. En Copilot Studio, clic en **"Test your bot"** (panel lateral derecho)
2. Prueba conversaciones:
   ```
   Tú: Hola
   Bot: ¡Hola! 👋 Bienvenido...
   
   Tú: Busco una laptop
   Bot: ¡Perfecto! Te ayudaré...
   ```

---

## 📤 Paso 6: Exportar la Solución

Una vez que hayas creado todos los topics, exporta la solución:

### Opción A: Usando el script (RECOMENDADO)

```powershell
cd C:\Users\alemartinez\Integrando-Microsoft-Copilot-Studio-con-GitHub\agente-retail-ejemplo

.\scripts\export-solution.ps1 -EnvironmentUrl "https://org12345.crm.dynamics.com"
```

(Reemplaza `org12345` con tu URL real del entorno)

### Opción B: Comando directo

```powershell
pac solution export --name MyRetailAgent --path ./solution --managed false --overwrite

pac solution unpack --zipfile ./solution/MyRetailAgent.zip --folder ./solution/MyRetailAgent --allowDelete
```

---

## 📋 Checklist de Progreso

- [ ] Bot creado y agregado a solución MyRetailAgent
- [ ] Entidad ProductCategory creada con 7 categorías
- [ ] Entidad StoreLocation creada con 7 ubicaciones
- [ ] 6 variables globales creadas
- [ ] Topic 1: Greeting creado
- [ ] Topic 2: ProductInquiry creado
- [ ] Topic 3: CheckInventory creado
- [ ] Topic 4: PricingInfo creado
- [ ] Topic 5: Recommendations creado
- [ ] Topic 6: StoreLocations creado
- [ ] Topic 7: ReturnsPolicy creado
- [ ] Topic 8: Escalation creado
- [ ] Topic 9: Fallback configurado
- [ ] Bot probado con conversaciones de ejemplo
- [ ] Solución exportada con script
- [ ] Cambios commiteados a Git

---

## 🚀 Comandos Finales

```powershell
# Exportar solución
.\scripts\export-solution.ps1 -EnvironmentUrl "https://[tu-org].crm.dynamics.com"

# Agregar a Git
git add solution/
git commit -m "feat: Agente de retail completo con 9 topics"
git push

# Importar en otro entorno (TEST/PROD)
.\scripts\import-solution.ps1 -EnvironmentUrl "https://[otro-entorno].crm.dynamics.com"
```

---

## 💡 Consejos

1. **Crea los topics uno por uno** - No intentes hacerlo todo de una vez
2. **Prueba cada topic** después de crearlo
3. **Los archivos JSON son tu guía** - Consulta la estructura en cada archivo
4. **Simplifica primero** - Empieza con flujos básicos, agrega complejidad después
5. **Exporta frecuentemente** - Haz backups exportando la solución

---

## ⏱️ Tiempo Estimado

- Crear entidades: **10 min**
- Crear variables: **5 min**
- Topic Greeting (básico): **15 min**
- Resto de topics (simplificados): **60-90 min**
- **Total**: 1.5 - 2 horas para versión básica

---

## 🆘 ¿Problemas?

Si tienes problemas creando algún topic, consulta:
1. El archivo JSON correspondiente en `topics/`
2. La documentación en `EJEMPLOS-CONVERSACIONES.md`
3. O pregúntame específicamente sobre ese topic

---

¡Empieza creando el bot en Copilot Studio ahora! 🚀
