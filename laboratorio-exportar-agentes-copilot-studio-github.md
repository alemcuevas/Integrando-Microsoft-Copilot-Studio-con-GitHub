# Laboratorio: Exportar Agentes de Copilot Studio hacia GitHub

## Objetivo
Aprender a exportar agentes creados en Microsoft Copilot Studio hacia un repositorio de GitHub para control de versiones y colaboración.

## Prerrequisitos

### Software necesario
- [ ] Cuenta de Microsoft con acceso a Copilot Studio
- [ ] Cuenta de GitHub
- [ ] Power Platform CLI instalado
- [ ] Git instalado en tu equipo
- [ ] Visual Studio Code (recomendado)

### Conocimientos previos
- Conceptos básicos de Git y GitHub
- Familiaridad con Microsoft Copilot Studio
- Uso básico de línea de comandos

## Duración estimada
45-60 minutos

---

## Parte 1: Preparación del entorno (15 minutos)

### Paso 1.1: Verificar instalación de Power Platform CLI

1. Abre PowerShell o Command Prompt
2. Ejecuta el siguiente comando para verificar la instalación:
   ```bash
   pac --version
   ```

3. Si no tienes Power Platform CLI instalado, descárgalo desde:
   - [Power Platform CLI](https://docs.microsoft.com/en-us/powerapps/developer/data-platform/powerapps-cli)

### Paso 1.2: Autenticación en Power Platform

1. Ejecuta el comando de autenticación:
   ```bash
   pac auth create --url https://[tu-entorno].crm.dynamics.com
   ```

2. Sigue las instrucciones en pantalla para autenticarte

### Paso 1.3: Crear repositorio en GitHub

1. Ve a GitHub.com e inicia sesión
2. Crea un nuevo repositorio:
   - Nombre: `copilot-studio-agents`
   - Descripción: "Agentes exportados desde Microsoft Copilot Studio"
   - Público o privado (según tus necesidades)
   - Inicializar con README

---

## Parte 2: Exportar el agente desde Copilot Studio (20 minutos)

### Paso 2.1: Acceder a Copilot Studio

1. Ve a [Copilot Studio](https://copilotstudio.microsoft.com)
2. Inicia sesión con tu cuenta de Microsoft
3. Selecciona el entorno donde tienes tu agente

### Paso 2.2: Identificar el agente a exportar

1. En el panel izquierdo, navega a **"Chatbots"** o **"Agentes"**
2. Selecciona el agente que deseas exportar
3. Anota el **nombre** y **ID** del agente para referencia

### Paso 2.3: Exportar usando Power Platform CLI

1. Abre PowerShell/Command Prompt
2. Navega al directorio donde quieres crear la exportación:
   ```bash
   cd C:\Users\[tu-usuario]\Documents\
   ```

3. Crear una nueva carpeta para el proyecto:
   ```bash
   mkdir copilot-agents-export
   cd copilot-agents-export
   ```

4. Exportar el agente usando PAC CLI:
   ```bash
   pac chatbot download --name "NombreDelAgente" --path ./
   ```

### Paso 2.4: Revisar los archivos exportados

Los archivos típicos que se generan incluyen:
- **Manifest.json**: Metadata del agente
- **Topics/**: Carpeta con los temas/topics del chatbot
- **Entities/**: Entidades personalizadas
- **Variables/**: Variables globales
- **Settings.json**: Configuraciones del agente

---

## Parte 3: Preparar para GitHub (10 minutos)

### Paso 3.1: Inicializar repositorio Git local

1. En la carpeta del proyecto exportado:
   ```bash
   git init
   ```

2. Configurar usuario de Git (si no está configurado):
   ```bash
   git config user.name "Tu Nombre"
   git config user.email "tu.email@ejemplo.com"
   ```

### Paso 3.2: Crear archivo .gitignore

1. Crea un archivo `.gitignore` para excluir archivos innecesarios:
   ```bash
   # Archivos temporales
   *.tmp
   *.log
   
   # Archivos de configuración sensibles
   *.env
   secrets.json
   
   # Archivos del sistema
   .DS_Store
   Thumbs.db
   
   # Archivos específicos de Power Platform
   *.msapp
   connections.json
   ```

### Paso 3.3: Crear documentación del agente

1. Crea un archivo `README.md` en la raíz del proyecto:
   ```markdown
   # [Nombre del Agente]
   
   ## Descripción
   [Descripción breve del propósito del agente]
   
   ## Características principales
   - [Característica 1]
   - [Característica 2]
   - [Característica 3]
   
   ## Estructura del proyecto
   - `Topics/`: Contiene todos los topics/temas del chatbot
   - `Entities/`: Entidades personalizadas definidas
   - `Variables/`: Variables globales del agente
   - `Manifest.json`: Metadata y configuración del agente
   
   ## Última actualización
   [Fecha de la última exportación]
   
   ## Versión
   [Versión del agente]
   ```

---

## Parte 4: Subir a GitHub (10 minutos)

### Paso 4.1: Conectar repositorio local con GitHub

1. Añadir el repositorio remoto:
   ```bash
   git remote add origin https://github.com/[tu-usuario]/copilot-studio-agents.git
   ```

### Paso 4.2: Realizar el primer commit

1. Añadir todos los archivos:
   ```bash
   git add .
   ```

2. Crear el primer commit:
   ```bash
   git commit -m "Exportación inicial del agente [NombreDelAgente] desde Copilot Studio"
   ```

### Paso 4.3: Subir al repositorio

1. Subir los archivos a GitHub:
   ```bash
   git push -u origin main
   ```

2. Si es la primera vez, puede pedirte autenticación de GitHub

---

## Parte 5: Organización y mejores prácticas (5 minutos)

### Estructura recomendada del repositorio

```
copilot-studio-agents/
├── README.md
├── .gitignore
├── agents/
│   ├── agente-soporte-tecnico/
│   │   ├── Topics/
│   │   ├── Entities/
│   │   ├── Variables/
│   │   ├── Manifest.json
│   │   └── README.md
│   └── agente-ventas/
│       ├── Topics/
│       ├── Entities/
│       ├── Variables/
│       ├── Manifest.json
│       └── README.md
└── docs/
    ├── deployment-guide.md
    └── changelog.md
```

### Mejores prácticas

1. **Versionado semántico**: Usa tags de Git para marcar versiones importantes
   ```bash
   git tag -a v1.0.0 -m "Primera versión estable del agente"
   git push origin v1.0.0
   ```

2. **Commits descriptivos**: Usa mensajes de commit claros:
   - ✅ "Añadir nuevo topic para consultas de facturación"
   - ❌ "Update"

3. **Branches para desarrollo**: Crea branches para nuevas características:
   ```bash
   git checkout -b feature/nuevo-topic-ayuda
   ```

4. **Pull Requests**: Usa PR para revisar cambios antes de mergear a main

---

## Ejercicios prácticos

### Ejercicio 1: Exportación completa
1. Selecciona un agente existente en tu Copilot Studio
2. Expórtalo siguiendo los pasos del laboratorio
3. Sube el resultado a GitHub

### Ejercicio 2: Actualización del agente
1. Realiza un cambio menor en tu agente en Copilot Studio
2. Vuelve a exportarlo
3. Compara las diferencias usando `git diff`
4. Haz commit de los cambios

### Ejercicio 3: Documentación avanzada
1. Crea documentación detallada para cada topic de tu agente
2. Añade diagramas de flujo usando Mermaid en markdown
3. Documenta las integraciones y conexiones utilizadas

---

## Solución de problemas comunes

### Error: "pac command not found"
**Solución**: 
- Reinstalar Power Platform CLI
- Verificar que esté en el PATH del sistema

### Error: "Authentication failed"
**Solución**:
- Ejecutar `pac auth clear`
- Volver a autenticarse con `pac auth create`

### Error: "Agent not found"
**Solución**:
- Verificar el nombre exacto del agente
- Asegurarse de estar en el entorno correcto

### Conflictos de Git
**Solución**:
- Usar `git status` para ver el estado
- Resolver conflictos manualmente
- Usar `git add .` y `git commit` después de resolver

---

## Recursos adicionales

### Documentación oficial
- [Power Platform CLI Reference](https://docs.microsoft.com/en-us/powerapps/developer/data-platform/powerapps-cli)
- [Copilot Studio Documentation](https://docs.microsoft.com/en-us/microsoft-copilot-studio/)
- [GitHub Documentation](https://docs.github.com/)

### Herramientas complementarias
- [GitHub Desktop](https://desktop.github.com/): Interface gráfica para Git
- [VS Code Extension for Power Platform](https://marketplace.visualstudio.com/items?itemName=microsoft-IsvExpTools.powerplatform-vscode)

### Comunidad
- [Power Platform Community](https://powerusers.microsoft.com/)
- [GitHub Community](https://github.community/)

---

## Conclusión

Al completar este laboratorio, habrás aprendido a:

- ✅ Configurar el entorno necesario para exportar agentes
- ✅ Exportar agentes de Copilot Studio usando Power Platform CLI
- ✅ Organizar el código exportado en una estructura de proyecto
- ✅ Subir y versionar agentes en GitHub
- ✅ Implementar mejores prácticas de desarrollo colaborativo

Este flujo de trabajo te permitirá mantener un control de versiones efectivo de tus agentes de Copilot Studio, facilitar la colaboración en equipo y crear una historia de cambios que puedes seguir a lo largo del tiempo.

---

## Próximos pasos

1. **Automatización**: Considera crear scripts para automatizar el proceso de exportación
2. **CI/CD**: Implementa pipelines de GitHub Actions para deployment automático
3. **Testing**: Desarrolla estrategias de testing para tus agentes
4. **Monitoreo**: Implementa logging y monitoreo de tus agentes en producción

---

*Laboratorio creado para la integración entre Microsoft Copilot Studio y GitHub*
*Última actualización: Noviembre 2024*