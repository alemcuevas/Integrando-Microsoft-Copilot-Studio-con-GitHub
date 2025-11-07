# Configuración de Control de Código Fuente - Copilot Studio

## 🔄 Integración con GitHub

Este documento describe cómo configurar y usar el control de código fuente (source control) de Copilot Studio con este repositorio.

## 📋 Prerrequisitos

1. ✅ Solución `MyRetailAgent` creada en el ambiente
2. ✅ Agente `Asistente de Ventas Retail` desplegado
3. ✅ Cloud Flow `EnviarEmailCotizacion` agregado a la solución
4. ✅ Repositorio GitHub conectado

## 🚀 Configuración Inicial

### Paso 1: Preparar el Repositorio

El repositorio ya está preparado con la estructura necesaria:

```text
Integrando-Microsoft-Copilot-Studio-con-GitHub/
├── solution/              # ← Carpeta monitoreada por Copilot Studio
│   ├── bots/
│   ├── botcomponents/
│   └── Workflows/
├── templates/
├── scripts/
└── .gitignore
```

### Paso 2: Conectar Copilot Studio con GitHub

1. **Abrir Copilot Studio**
   - URL: <https://copilotstudio.microsoft.com>
   - Seleccionar ambiente: Contoso (default)

2. **Navegar a Settings**
   - Click en ⚙️ Settings (esquina superior derecha)
   - Seleccionar **Source control**

3. **Conectar GitHub**
   - Click en **Connect**
   - Autorizar acceso a GitHub
   - Seleccionar repositorio: `alemcuevas/Integrando-Microsoft-Copilot-Studio-con-GitHub`
   - Branch: `main`
   - Folder path: `solution`

4. **Seleccionar Solución**
   - Solution: `MyRetailAgent`
   - Click en **Connect**

Después de conectar, Copilot Studio:

- ✅ Lee la estructura actual del repositorio
- ✅ Compara con la solución en el ambiente
- ✅ Muestra diferencias (si existen)

## 🔧 Workflow de Desarrollo

### Opción 1: Cambios desde Copilot Studio (Recomendado)

1. **Hacer cambios en el agente**
   - Editar topics, agregar variables, modificar flujos
   - Guardar cambios en Copilot Studio

2. **Commit desde Copilot Studio**
   - Settings → Source control
   - Click en **Commit**
   - Escribir mensaje descriptivo
   - Click en **Commit and push**

3. **Verificar en GitHub**
   - Los cambios aparecerán automáticamente en el repositorio

### Opción 2: Cambios desde CLI/Código

1. **Exportar solución actual**
   ```powershell
   .\scripts\export-solution.ps1 -EnvironmentUrl "https://orgce8fe757.crm.dynamics.com/" -SolutionName "MyRetailAgent"
   ```

2. **Desempaquetar**
   ```powershell
   pac solution unpack --zipfile ".\solution-export\MyRetailAgent.zip" --folder ".\solution" --allowWrite --clobber
   ```

3. **Commit y push**
   ```powershell
   git add solution/
   git commit -m "feat: actualización de topics"
   git push origin main
   ```

4. **Sincronizar en Copilot Studio**
   - Settings → Source control
   - Click en **Pull**
   - Revisar cambios
   - Click en **Apply**

## 📝 Mejores Prácticas

### Mensajes de Commit

Usar formato convencional:

```text
feat: agregar topic de devoluciones
fix: corregir flujo de escalamiento
docs: actualizar documentación de flows
refactor: simplificar topic de precios
```

### Branch Strategy

```text
main           ← Producción (protegido)
  ↑
  ├── develop  ← Desarrollo (testing)
  │    ↑
  │    ├── feature/nueva-funcionalidad
  │    ├── fix/corregir-bug
  │    └── refactor/optimizar-topics
```

### Estructura de Commits

Mantener commits atómicos:

- ✅ Un topic por commit
- ✅ Un fix específico por commit
- ❌ Evitar commits masivos con múltiples cambios

## 🔍 Monitoreo y Revisión

### Revisar Cambios Pendientes

**En Copilot Studio:**

- Settings → Source control → **Changes**
- Ver archivos modificados antes de commit

**En CLI:**

```powershell
git status
git diff solution/
```

### Pull Requests

Para cambios importantes:

1. Crear branch de feature
2. Hacer cambios y commit
3. Push al branch
4. Crear Pull Request en GitHub
5. Revisión de código
6. Merge a main después de aprobación

## 🛠️ Comandos Útiles

### Exportar y Empaquetar

```powershell
# Exportar solución
pac solution export --name "MyRetailAgent" --path ".\solution-export" --managed false

# Desempaquetar para source control
pac solution unpack --zipfile ".\solution-export\MyRetailAgent.zip" --folder ".\solution" --allowWrite --clobber

# Empaquetar desde source control
pac solution pack --zipfile ".\dist\MyRetailAgent.zip" --folder ".\solution" --packagetype Unmanaged
```

### Git Operations

```powershell
# Ver estado
git status

# Ver diferencias
git diff solution/

# Agregar cambios
git add solution/

# Commit
git commit -m "feat: agregar topic de X"

# Push
git push origin main

# Pull cambios remotos
git pull origin main
```

## 🚨 Solución de Problemas

### Conflictos de Sincronización

**Problema:** Cambios tanto en Studio como en GitHub

**Solución:**

1. Pull primero desde Studio
2. Resolver conflictos manualmente
3. Commit la resolución

### Archivos Faltantes después de Unpack

**Problema:** "There are 44 unnecessary files"

**Solución:**

```powershell
pac solution unpack --allowDelete --clobber
```

### Cambios No Aparecen en GitHub

**Problema:** Commit en Studio pero no se ve en repo

**Solución:**

1. Verificar conexión: Settings → Source control
2. Re-conectar si es necesario
3. Verificar permisos de GitHub (write access)

## 📊 Estado Actual del Proyecto

### ✅ Componentes Versionados

- [x] Bot definition
- [x] 9 Bot components (topics)
- [x] 1 Cloud Flow (EnviarEmailCotizacion)
- [x] Solution manifest
- [x] Customizations

### 🔧 Archivos en Source Control

```text
solution/
├── bots/
│   └── miemp_asistenteRetailConFlow/
│       └── bot.json
├── botcomponents/
│   ├── miemp_ConsultadeProductos/
│   ├── miemp_ErrordelSistema/
│   ├── miemp_InformacióndePrecios/
│   ├── miemp_IniciodeConversacion/
│   ├── miemp_RespuestaPredeterminada/
│   ├── miemp_Saludo/
│   ├── miemp_TransferiraAgenteHumano/
│   ├── miemp_UbicacionesdeTiendas/
│   └── miemp_VerificarInventario/
├── Workflows/
│   └── EnviarEmailCotizacion-ADD36A2B-9BBB-F011-BBD2-000D3A36E147.json
├── customizations.xml
└── solution.xml
```

## 🎯 Próximos Pasos

1. ✅ Conectar repositorio GitHub con Copilot Studio
2. ⏳ Hacer cambio de prueba desde Studio
3. ⏳ Commit y verificar en GitHub
4. ⏳ Crear branch de feature para nuevos topics
5. ⏳ Configurar protección de branch main
6. ⏳ Establecer proceso de code review

## 📚 Referencias

- [Copilot Studio Source Control Docs](https://learn.microsoft.com/en-us/microsoft-copilot-studio/fundamentals-source-control)
- [Power Platform CLI Reference](https://learn.microsoft.com/en-us/power-platform/developer/cli/reference/solution)
- [Git Best Practices](https://git-scm.com/book/en/v2)

---

**Última actualización:** {{ now() }}
**Agente ID:** a782d173-f383-4dc9-b15e-67caae858fc9
**Flow ID:** ADD36A2B-9BBB-F011-BBD2-000D3A36E147
