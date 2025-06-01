# Guía de Navegación - Consola GCP

## 🎯 Cómo encontrar tu proyecto en la Consola de GCP

### 1. **Acceder a Cloud Run**
1. Ve a [Google Cloud Console](https://console.cloud.google.com)
2. En el menú lateral izquierdo, busca "Cloud Run"
3. O usa la barra de búsqueda: "Cloud Run"

**URL Directa:** `https://console.cloud.google.com/run`

### 2. **Ver tu Servicio Desplegado**
Una vez en Cloud Run verás:

```
Servicios de Cloud Run
┌─────────────────────────────────────────────────────┐
│ 📱 helloworld-php                                   │
│ 🌐 https://helloworld-php-[hash]-uc.a.run.app      │
│ 📍 us-central1                                      │
│ ✅ Serving                                          │
│ 🚦 100% tráfico                                     │
└─────────────────────────────────────────────────────┘
```

### 3. **Configuraciones Detalladas**
Haz clic en tu servicio `helloworld-php` para ver:

#### **Pestaña "Detalles"**
- 🌐 URL del servicio
- 📊 Métricas en tiempo real
- 🎛️ Variables de entorno
- 🔧 Configuración de recursos (CPU, Memoria)

#### **Pestaña "Revisiones"**
- 📚 Historial de versiones
- 🏷️ Tags de cada versión
- ⚡ Configuración de cada revisión

#### **Pestaña "Logs"**
- 📝 Logs de la aplicación
- 🐛 Errores y debugging
- ⏱️ Timestamps de cada evento

#### **Pestaña "Métricas"**
- 📈 Solicitudes por segundo
- ⏰ Latencia promedio
- 💾 Uso de memoria
- 🖥️ Uso de CPU

### 4. **Otras Secciones Importantes**

#### **Cloud Build**
`https://console.cloud.google.com/cloud-build/builds`
- 🔨 Historial de builds
- ⏱️ Duración de cada build
- 📋 Logs del proceso de containerización

#### **Artifact Registry**
`https://console.cloud.google.com/artifacts`
- 🐳 Imágenes de Docker creadas
- 📦 Versiones almacenadas
- 🗂️ Repositorios de contenedores

#### **Facturación**
`https://console.cloud.google.com/billing`
- 💰 Costos del proyecto
- 📊 Uso de recursos
- 🔍 Desglose por servicio

## 🔍 **Comandos para Verificar desde Terminal**

```bash
# Ver servicios de Cloud Run
gcloud run services list

# Ver detalles de tu servicio
gcloud run services describe helloworld-php --region=us-central1

# Ver logs en tiempo real
gcloud logs tail projects/[PROJECT-ID]/logs/run.googleapis.com%2Fstdout

# Ver métricas
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=helloworld-php" --limit=50
```

## 📱 **App Móvil Google Cloud**

También puedes monitorear desde tu móvil:
- 📱 Descarga "Google Cloud Console" app
- 🔔 Configura alertas
- 📊 Ve métricas básicas

## 🚨 **Alertas y Monitoreo**

En `https://console.cloud.google.com/monitoring`:
- ⚠️ Configura alertas de errores
- 📧 Notificaciones por email
- 📈 Dashboards personalizados

## 💡 **Tips Útiles**

1. **Bookmarks recomendados:**
   - Cloud Run: `https://console.cloud.google.com/run`
   - Logs: `https://console.cloud.google.com/logs`
   - Facturación: `https://console.cloud.google.com/billing`

2. **Atajos de teclado:**
   - `/` = Abrir búsqueda
   - `g + r` = Ir a Cloud Run
   - `g + l` = Ir a Logs

3. **Filtros útiles en Logs:**
   ```
   resource.type="cloud_run_revision"
   resource.labels.service_name="helloworld-php"
   ``` 