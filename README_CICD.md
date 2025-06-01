# 🚀 Laboratorio DevOps: CI/CD con Azure Pipelines y Google Cloud Run

## 📖 Información del Estudiante
- **Materia:** DevOps
- **Laboratorio:** Crea una canalización de CI/CD con Azure Pipelines y Cloud Run
- **Enlace:** https://cloud.google.com/dotnet/docs/creating-a-cicd-pipeline-azure-pipelines-cloud-run

## 🎯 Objetivos del Laboratorio

1. ✅ Crear un proyecto de Azure DevOps
2. ✅ Conectar Azure Pipelines a Container Registry
3. ✅ Crear una conexión de servicio para Container Registry
4. ✅ Compilar y desplegar de forma continua

## 🏗️ Arquitectura de la Solución

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Developer     │    │  Azure DevOps    │    │  Google Cloud   │
│                 │    │                  │    │                 │
│ Git Push ──────▶│    │ ┌──────────────┐ │    │ ┌─────────────┐ │
│                 │    │ │   Pipeline   │ │    │ │ Cloud Run   │ │
│                 │    │ │              │ │    │ │             │ │
│                 │    │ │ 1. Test      │ │    │ │ PHP App     │ │
│                 │    │ │ 2. Build     │ │────▶│ │             │ │
│                 │    │ │ 3. Push GCR  │ │    │ │ Auto-scale  │ │
│                 │    │ │ 4. Deploy    │ │    │ │             │ │
│                 │    │ └──────────────┘ │    │ └─────────────┘ │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 📁 Estructura del Proyecto

```
gcp-lab/
├── 📄 index.php                    # Aplicación PHP principal
├── 🐳 Dockerfile                   # Configuración de contenedor
├── 🔧 azure-pipelines.yml          # Pipeline de CI/CD
├── 📋 .dockerignore                # Archivos excluidos del build
├── 📚 README_CICD.md               # Esta documentación
├── 📖 CICD_SETUP_GUIDE.md          # Guía de configuración
├── 🖥️ GCP_CONSOLE_GUIDE.md         # Guía de navegación en GCP
├── 📁 scripts/
│   └── 🔨 setup-gcp.sh             # Script de configuración automática
└── 📁 test/
    └── 🧪 test-app.php              # Pruebas unitarias
```

## 🔧 Componentes Técnicos

### 1. **Aplicación PHP (`index.php`)**
```php
<?php
$name = $_ENV['NAME'] ?? 'World';
echo sprintf('Hello %s!', htmlspecialchars($name));
```
- **Funcionalidad:** Responde con saludo personalizable
- **Seguridad:** Usa `htmlspecialchars()` para prevenir XSS
- **Configuración:** Variable de entorno `NAME`

### 2. **Containerización (`Dockerfile`)**
```dockerfile
FROM php:8.1-apache
ENV APACHE_DOCUMENT_ROOT=/var/www/html
# ... configuración optimizada para Cloud Run
```
- **Base:** PHP 8.1 con Apache
- **Optimización:** Configurado para Cloud Run
- **Puerto:** Dinámico usando variable `$PORT`

### 3. **Pipeline CI/CD (`azure-pipelines.yml`)**
```yaml
stages:
- stage: Test      # Pruebas unitarias
- stage: Build     # Construir imagen Docker
- stage: Deploy    # Desplegar a Cloud Run
- stage: PostDeploy # Verificación post-despliegue
```

## 🚀 Proceso de CI/CD

### **Stage 1: Test** 🧪
- Instala PHP en el agente de Azure
- Ejecuta pruebas unitarias (`test/test-app.php`)
- Valida funcionalidad básica de la aplicación

### **Stage 2: Build** 🔨
- Construye imagen Docker
- Autentica con Google Cloud
- Pushea imagen a Google Container Registry (GCR)

### **Stage 3: Deploy** 🚀
- Despliega imagen a Cloud Run
- Configura recursos (512Mi RAM, 1 CPU)
- Prueba la aplicación desplegada

### **Stage 4: PostDeploy** ✅
- Verifica que el despliegue fue exitoso
- Muestra URL de la aplicación
- Proporciona enlaces de monitoreo

## 🔐 Configuración de Seguridad

### **Service Account** (GCP)
```bash
azure-pipelines-sa@[PROJECT-ID].iam.gserviceaccount.com
```

**Roles asignados:**
- `roles/run.admin` - Administrar Cloud Run
- `roles/storage.admin` - Acceso a Container Registry
- `roles/iam.serviceAccountUser` - Usar service accounts
- `roles/cloudbuild.builds.builder` - Construir imágenes

### **Variables Secretas** (Azure DevOps)
- `GCP_PROJECT_ID` - ID del proyecto de Google Cloud
- `GCP_SERVICE_ACCOUNT_KEY` - Clave JSON en base64

## 📊 Monitoreo y Observabilidad

### **Azure DevOps Dashboard**
- **Build History:** Historial de builds exitosos/fallidos
- **Test Results:** Resultados de pruebas unitarias
- **Pipeline Analytics:** Métricas de tiempo y rendimiento

### **Google Cloud Console**
- **Cloud Run:** Estado del servicio y métricas
- **Container Registry:** Imágenes almacenadas
- **Cloud Logging:** Logs de aplicación y sistema
- **Cloud Monitoring:** Alertas y dashboards

## 🧪 Estrategia de Testing

### **Pruebas Unitarias**
```php
// Casos de prueba implementados:
✅ Output por defecto ("Hello World!")
✅ Variable NAME personalizada
✅ Manejo de variables vacías
✅ Escapado de caracteres HTML (seguridad)
✅ Formato correcto del mensaje
```

### **Pruebas de Integración**
- Verificación HTTP 200 post-despliegue
- Validación de conectividad del servicio
- Prueba de acceso público

## 📈 Métricas de DevOps

### **Deployment Frequency**
- ⚡ **Automático** en cada push a `main`
- 🔄 **Pipeline completo** en ~5-8 minutos

### **Lead Time**
- 📊 **Commit a producción:** < 10 minutos
- 🚀 **Zero downtime deployments**

### **Mean Time to Recovery**
- 🔧 **Rollback automático** en caso de fallo
- 📝 **Logs centralizados** para debugging

### **Change Failure Rate**
- ✅ **Testing obligatorio** antes de deploy
- 🛡️ **Validación automática** post-deploy

## 🌐 URLs y Enlaces Importantes

### **Desarrollo**
- Azure DevOps: `https://dev.azure.com/[organization]/[project]`
- Pipeline: `https://dev.azure.com/[organization]/[project]/_build`

### **Producción**
- Aplicación: `https://helloworld-php-cicd-[hash]-uc.a.run.app`
- Cloud Run Console: `https://console.cloud.google.com/run`
- Container Registry: `https://console.cloud.google.com/gcr`

## 🎓 Conceptos de DevOps Demostrados

### **1. Continuous Integration (CI)**
- ✅ Integración automática de código
- ✅ Ejecución de pruebas automáticas
- ✅ Validación de calidad de código

### **2. Continuous Deployment (CD)**
- ✅ Despliegue automático a producción
- ✅ Zero-downtime deployments
- ✅ Rollback automático

### **3. Infrastructure as Code (IaC)**
- ✅ Pipeline definido en YAML
- ✅ Configuración versionada
- ✅ Reproducible y auditable

### **4. Cloud Native**
- ✅ Containerización con Docker
- ✅ Serverless con Cloud Run
- ✅ Auto-scaling automático

### **5. GitOps**
- ✅ Git como fuente de verdad
- ✅ Trigger automático por push
- ✅ Historial completo de cambios

## 🔍 Comandos de Verificación

### **Verificar Despliegue**
```bash
# Estado del servicio
gcloud run services describe helloworld-php-cicd --region=us-central1

# Logs en tiempo real
gcloud logs tail projects/[PROJECT-ID]/logs/run.googleapis.com%2Fstdout

# Probar aplicación
curl https://helloworld-php-cicd-[hash]-uc.a.run.app
```

### **Métricas del Pipeline**
```bash
# Ver pipelines en Azure CLI
az pipelines list --organization https://dev.azure.com/[organization]

# Ver builds recientes
az pipelines build list --organization https://dev.azure.com/[organization] --project [project]
```

## 🏆 Entregables del Laboratorio

### **✅ Completado:**
1. **Código fuente** - Aplicación PHP containerizada
2. **Pipeline CI/CD** - Azure Pipelines configurado
3. **Service Account** - Configuración de seguridad GCP
4. **Aplicación desplegada** - Cloud Run funcionando
5. **Documentación** - Guías completas de configuración
6. **Testing** - Pruebas unitarias implementadas

### **📋 Para la Entrega:**
- **Capturas de pantalla** del pipeline ejecutándose
- **URL de la aplicación** funcionando
- **Evidencia de las pruebas** pasando exitosamente
- **Documentación** de la configuración realizada
- **Análisis de conceptos** de DevOps aplicados

---

## 🎯 Conclusión

Este laboratorio demuestra una implementación completa de CI/CD que integra:
- **Azure DevOps** como plataforma de CI/CD
- **Google Cloud Run** como plataforma de despliegue
- **Docker** para containerización
- **Automated testing** para calidad
- **Infrastructure as Code** para reproducibilidad

La solución implementa las mejores prácticas de DevOps y proporciona una base sólida para proyectos empresariales. 