# Ejemplos de Conversaciones y Casos de Uso

Este documento muestra ejemplos de conversaciones típicas con el agente de retail y casos de uso comunes.

---

## Conversación 1: Búsqueda de Producto

```
Usuario: Hola
Bot: ¡Hola! 👋 Bienvenido a nuestra tienda. Soy tu asistente virtual de ventas.

Bot: Puedo ayudarte con:
     🔍 Buscar productos
     📦 Verificar disponibilidad
     💰 Consultar precios y promociones
     🎯 Recomendaciones personalizadas
     📍 Ubicaciones de tiendas
     ↩️ Política de devoluciones

Bot: ¿En qué puedo ayudarte hoy?

Usuario: Busco una laptop
Bot: ¡Perfecto! Te ayudaré a encontrar lo que buscas. 🔍

Bot: ¿Qué categoría de producto te interesa?
     [Opciones mostradas]

Usuario: Electrónica
Bot: Excelente elección en electrónica. 👍

Bot: ¿Podrías darme más detalles sobre lo que buscas?

Usuario: Laptop HP 15 pulgadas
Bot: Déjame buscar productos que coincidan con 'Laptop HP 15 pulgadas'...

Bot: ¡Encontré 3 productos que podrían interesarte! 🎉
     1. HP Pavilion 15" - Intel i5 - 8GB RAM - $12,999
     2. HP Envy 15" - Intel i7 - 16GB RAM - $19,999
     3. HP ProBook 15" - Intel i5 - 8GB RAM - $14,499
```

---

## Conversación 2: Verificación de Inventario

```
Usuario: ¿Tienen en stock zapatillas Nike?
Bot: Te ayudaré a verificar la disponibilidad del producto. 📦

Bot: ¿Qué producto quieres verificar?

Usuario: Nike Air Max 90
Bot: ¿En qué ubicación te gustaría verificar la disponibilidad?
     [Muestra opciones de tiendas]

Usuario: Tienda Centro
Bot: Verificando disponibilidad de 'Nike Air Max 90' en centro...

Bot: ¡Buenas noticias! ✅
     📦 Producto: Nike Air Max 90
     📍 Ubicación: centro
     ✅ Estado: Disponible
     📊 Cantidad: 12 unidades en stock

Bot: ¿Te gustaría:
     1️⃣ Ver el precio y promociones
     2️⃣ Obtener la dirección de la tienda
     3️⃣ Reservar el producto
     4️⃣ Verificar otro producto
```

---

## Conversación 3: Consulta de Precios con Promoción

```
Usuario: Cuánto cuesta el Samsung Galaxy S24?
Bot: Te ayudaré con información de precios y promociones. 💰

Bot: ¿De qué producto quieres conocer el precio?

Usuario: Samsung Galaxy S24
Bot: Consultando precio de 'Samsung Galaxy S24'...

Bot: 💰 Samsung Galaxy S24
     🏷️ Precio regular: $24,999

Bot: 🎉 ¡PROMOCIÓN ESPECIAL!
     🔥 Precio con descuento: $21,999
     💵 Ahorras: $3,000 (12% OFF)
     ⏰ Válido hasta: 15 de Noviembre 2025

Bot: ✨ Promociones adicionales aplicables:
     - 12 meses sin intereses con tarjetas participantes
     - 10% adicional pagando con tarjeta de la tienda
     - Regalo: Audífonos Galaxy Buds ($2,499 de valor)
```

---

## Conversación 4: Recomendaciones de Productos

```
Usuario: Recomiéndame algo
Bot: ¡Me encanta ayudarte a encontrar el producto perfecto! 🎯

Bot: ¿Qué tipo de recomendación buscas?
     🔥 Productos más vendidos
     ✨ Novedades
     🎯 Basado en un producto
     💡 Sorpréndeme

Usuario: Lo más vendido
Bot: ✨ Recomendaciones para ti:
     
     Top 5 Productos Más Vendidos:
     
     1. 📱 iPhone 15 Pro - $29,999
        ⭐ 4.8/5 (2,456 reseñas)
        
     2. 🎧 AirPods Pro 2da Gen - $5,999
        ⭐ 4.9/5 (1,823 reseñas)
        
     3. 💻 MacBook Air M2 - $34,999
        ⭐ 4.9/5 (987 reseñas)
        
     4. ⌚ Apple Watch Series 9 - $12,999
        ⭐ 4.7/5 (1,234 reseñas)
        
     5. 📺 Samsung QLED 55" - $19,999
        ⭐ 4.8/5 (756 reseñas)

Bot: ¿Alguno de estos productos te interesa?
```

---

## Conversación 5: Ubicación de Tiendas

```
Usuario: Dónde están ubicados?
Bot: Te ayudaré a encontrar la tienda más cercana. 📍

Bot: ¿Qué información necesitas?
     📍 Ver todas las ubicaciones
     🔍 Buscar tienda cercana
     🕐 Horarios de atención
     📞 Información de contacto

Usuario: Ver todas las ubicaciones
Bot: 🏪 Nuestras Tiendas:

     Tienda Centro
     📍 Av. Principal 123, Centro
     🕐 Lun-Sáb: 9:00 AM - 9:00 PM | Dom: 10:00 AM - 6:00 PM
     📞 (555) 123-4567

     Tienda Norte
     📍 Blvd. Norte 456, Zona Norte
     🕐 Lun-Dom: 10:00 AM - 8:00 PM
     📞 (555) 234-5678

     [... más ubicaciones]

Bot: ¿Necesitas algo más?
```

---

## Conversación 6: Política de Devoluciones

```
Usuario: Quiero devolver un producto
Bot: Te ayudaré con información sobre devoluciones y cambios. 🔄

Bot: ¿Qué información necesitas?
     📋 Política de devolución
     🔄 Hacer un cambio
     💰 Solicitar reembolso
     ⚠️ Producto defectuoso
     📜 Información de garantía

Usuario: Solicitar reembolso
Bot: 💰 Proceso de Reembolso

     Para compras en tienda:
     1. Lleva el producto con ticket original
     2. Reembolso en efectivo o al mismo método de pago
     3. Procesamiento inmediato

     Para compras online:
     1. Solicita devolución en www.mitienda.com/devoluciones
     2. Imprime etiqueta de envío gratuito
     3. Envía el paquete
     4. Reembolso en 5-7 días hábiles tras recepción

Bot: ¿Fue compra en tienda o en línea?
```

---

## Conversación 7: Escalamiento a Agente Humano

```
Usuario: Necesito hablar con una persona
Bot: Entiendo que necesitas ayuda más especializada. 
     Te conectaré con uno de nuestros asesores. 👤

Bot: Para ayudarte mejor, ¿podrías indicarme tu nombre?

Usuario: Juan Pérez
Bot: Gracias, Juan Pérez. ¿Cuál es tu correo electrónico para seguimiento?

Usuario: juan.perez@email.com
Bot: ¿Podrías describirme brevemente en qué necesitas ayuda?

Usuario: Tengo un problema con una compra reciente
Bot: Perfecto, Juan Pérez. He registrado tu solicitud:
     📧 Email: juan.perez@email.com
     📝 Consulta: Tengo un problema con una compra reciente

Bot: ¿Cómo prefieres que te contactemos?
     💬 Chat en vivo ahora
     📞 Llamada telefónica
     📧 Correo electrónico
     💬 WhatsApp

Usuario: Chat en vivo
Bot: ¡Perfecto! Estoy transfiriendo tu conversación...
     ⏱️ Tiempo de espera aproximado: 2-3 minutos
     
     Por favor, no cierres esta ventana.
     
     [Transferencia a agente humano...]
```

---

## Casos de Uso Empresariales

### Caso 1: Cliente Buscando Regalo

**Escenario**: Cliente indeciso buscando un regalo

```
Usuario: Necesito un regalo para mi mamá
Bot: ¡Qué lindo! Te ayudo a encontrar el regalo perfecto 🎁

Bot: ¿En qué categoría estás pensando?

Usuario: No estoy seguro
Bot: No te preocupes. ¿Qué le gusta a tu mamá?
     - Tecnología
     - Belleza y cuidado personal
     - Hogar y decoración
     - Ropa y accesorios

Usuario: Belleza
Bot: Perfecto! Tengo excelentes opciones en belleza...
     [Continúa con recomendaciones]
```

### Caso 2: Cliente Comparando Productos

**Escenario**: Cliente comparando características de dos productos

```
Usuario: Cuál es la diferencia entre el iPhone 15 y el 15 Pro?
Bot: Te ayudo a comparar estos productos...

     iPhone 15:
     💰 $23,999
     📱 6.1" Super Retina XDR
     📷 Cámara dual 48MP + 12MP
     🔋 Batería hasta 20 hrs

     iPhone 15 Pro:
     💰 $29,999
     📱 6.1" Always-On display
     📷 Sistema triple cámara 48MP
     🔋 Batería hasta 23 hrs
     ✨ Chip A17 Pro
     🎮 Mejor rendimiento gaming

Bot: ¿Te ayudo con algo más en la comparación?
```

### Caso 3: Cliente con Producto Defectuoso

**Escenario**: Urgencia por producto con falla

```
Usuario: Compré una TV hace 3 días y no enciende
Bot: Lamento mucho escuchar eso. Para productos defectuosos:

     ✅ Cambio inmediato sin importar el tiempo si está en garantía
     🔍 Evaluación técnica
     🎁 Cambio por producto nuevo o reembolso total
     ⚡ Prioridad en atención

Bot: ¿Te gustaría que te conecte con un especialista?

Usuario: Sí por favor
Bot: Conectando con especialista en garantías...
     [Escalamiento prioritario]
```

---

## Métricas de Éxito

### KPIs a monitorear:

1. **Tasa de resolución**: 75-85% de consultas resueltas sin escalamiento
2. **Satisfacción del cliente**: CSAT > 4.2/5
3. **Tiempo promedio de respuesta**: < 3 segundos
4. **Topics más utilizados**:
   - Consulta de productos (35%)
   - Verificación de inventario (25%)
   - Información de precios (20%)
   - Ubicaciones (10%)
   - Otros (10%)

---

## Pruebas Recomendadas

### Suite de Pruebas Básicas:

✅ Saludo inicial y presentación
✅ Búsqueda por categoría
✅ Búsqueda por producto específico
✅ Verificación de stock
✅ Consulta de precios
✅ Productos con promoción
✅ Productos sin promoción
✅ Recomendaciones
✅ Ubicaciones de tiendas
✅ Política de devoluciones
✅ Escalamiento a humano
✅ Fallback para consultas no entendidas

### Suite de Pruebas Avanzadas:

✅ Flujo completo de compra
✅ Múltiples cambios de tema en una conversación
✅ Entradas con errores ortográficos
✅ Preguntas complejas
✅ Interrupciones de flujo
✅ Volver a temas anteriores
✅ Producto no disponible
✅ Múltiples productos en una consulta

---

**Versión**: 1.0.0  
**Última actualización**: Noviembre 2025
