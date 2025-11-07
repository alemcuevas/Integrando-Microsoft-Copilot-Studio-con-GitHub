# Agente de Retail - Asistente de Ventas

## Descripción
Agente virtual diseñado para asistir a clientes en una tienda retail. Proporciona información sobre productos, verifica disponibilidad, responde consultas sobre precios y ofrece recomendaciones personalizadas.

## Características principales

### 🛍️ Funcionalidades del agente
- **Consulta de productos**: Búsqueda de artículos por categoría, nombre o características
- **Verificación de inventario**: Consulta de disponibilidad en tienda y online
- **Información de precios**: Precios actuales, promociones y descuentos
- **Recomendaciones**: Sugerencias basadas en preferencias del cliente
- **Horarios y ubicaciones**: Información de sucursales y horarios de atención
- **Política de devoluciones**: Detalles sobre garantías y devoluciones
- **Escalamiento**: Transferencia a agente humano cuando sea necesario

## Estructura del proyecto

```
agente-retail-ejemplo/
├── bot.json                    # Metadata y configuración del agente
├── README.md                   # Este archivo
├── topics/
│   ├── greeting.topic.json     # Saludo inicial
│   ├── product-inquiry.topic.json    # Consultas de productos
│   ├── check-inventory.topic.json    # Verificación de inventario
│   ├── pricing-info.topic.json       # Información de precios
│   ├── recommendations.topic.json    # Recomendaciones de productos
│   ├── store-locations.topic.json    # Ubicaciones y horarios
│   ├── returns-policy.topic.json     # Política de devoluciones
│   ├── escalation.topic.json         # Escalamiento a humano
│   └── fallback.topic.json           # Respuesta por defecto
├── entities/
│   ├── ProductCategory.entity.json   # Categorías de productos
│   └── StoreLocation.entity.json     # Ubicaciones de tiendas
└── variables/
    └── global-variables.json   # Variables globales del bot
```

## Topics incluidos

### 1. Greeting (Saludo)
- Mensaje de bienvenida personalizado
- Presentación de capacidades del agente
- Opciones rápidas para el usuario

### 2. Product Inquiry (Consulta de productos)
- Búsqueda por categoría
- Búsqueda por nombre de producto
- Detalles y especificaciones

### 3. Check Inventory (Verificar inventario)
- Disponibilidad en tienda física
- Disponibilidad online
- Tiempo estimado de reabastecimiento

### 4. Pricing Info (Información de precios)
- Precio actual del producto
- Promociones activas
- Descuentos disponibles

### 5. Recommendations (Recomendaciones)
- Productos similares
- Productos complementarios
- Tendencias y novedades

### 6. Store Locations (Ubicaciones)
- Direcciones de sucursales
- Horarios de atención
- Contacto de tiendas

### 7. Returns Policy (Política de devoluciones)
- Condiciones de devolución
- Período de garantía
- Proceso de cambio

### 8. Escalation (Escalamiento)
- Transferencia a agente humano
- Recopilación de información del cliente
- Contexto de la consulta

## Variables globales

- `CustomerName`: Nombre del cliente
- `ProductCategory`: Categoría seleccionada
- `ProductName`: Producto de interés
- `StoreLocation`: Ubicación preferida
- `CustomerEmail`: Email para seguimiento

## Entidades personalizadas

### ProductCategory
- Electrónica
- Ropa y Accesorios
- Hogar y Decoración
- Deportes y Fitness
- Juguetes y Juegos
- Belleza y Cuidado Personal
- Alimentos y Bebidas

### StoreLocation
- Tienda Centro
- Tienda Norte
- Tienda Sur
- Tienda Este
- Tienda Oeste
- Online

## Cómo importar a Copilot Studio

### Opción 1: Importación mediante Power Platform CLI

```powershell
# Autenticarse
pac auth create --url https://[tu-entorno].crm.dynamics.com

# Importar el agente
pac copilot import --path "./agente-retail-ejemplo"
```

### Opción 2: Importación manual

1. Abre [Copilot Studio](https://copilotstudio.microsoft.com)
2. Ve a la sección de **Agentes**
3. Haz clic en **Importar**
4. Selecciona los archivos del proyecto
5. Configura el entorno de destino
6. Completa la importación

## Personalización recomendada

Antes de usar el agente en producción, considera personalizar:

1. **Catálogo de productos**: Actualiza las entidades con tus productos reales
2. **Integraciones**: Conecta con tu sistema de inventario y POS
3. **Branding**: Ajusta mensajes según la voz de tu marca
4. **Ubicaciones**: Actualiza direcciones y horarios de tus tiendas
5. **Políticas**: Adapta las políticas de devolución a las de tu empresa

## Integraciones sugeridas

Para máxima funcionalidad, integra con:

- **Sistema de inventario**: API REST para verificación en tiempo real
- **CRM**: Salesforce, Dynamics 365 para gestión de clientes
- **Sistema POS**: Consulta de precios actualizados
- **Email**: SendGrid, Outlook para envío de confirmaciones
- **Chat en vivo**: Teams, Zendesk para escalamiento

## Flujo de conversación típico

```
Cliente: Hola
Bot: ¡Bienvenido a [Nombre Tienda]! Soy tu asistente virtual...

Cliente: Busco zapatillas deportivas
Bot: Tenemos varias opciones en zapatillas deportivas...

Cliente: ¿Tienen en stock el modelo X?
Bot: Verificando inventario... [consulta API]

Cliente: ¿Cuál es el precio?
Bot: El precio es $X con un 15% de descuento...

Cliente: ¿Puedo pasar a recogerlo?
Bot: Sí, está disponible en la Tienda Centro...
```

## Métricas y KPIs

Monitorea el rendimiento del agente mediante:

- **Tasa de resolución**: % de consultas resueltas sin escalamiento
- **Satisfacción del cliente**: CSAT score post-interacción
- **Tiempo promedio de respuesta**: Velocidad de respuesta
- **Conversiones**: % de interacciones que resultan en ventas
- **Topics más utilizados**: Identificar consultas frecuentes

## Versión
1.0.0 - Versión inicial (Noviembre 2025)

## Soporte
Para preguntas o mejoras, contacta al equipo de desarrollo.

## Licencia
Este agente es un ejemplo educativo para demostración de Copilot Studio.
