# Laboratorio GCP: Deploy a PHP service to Cloud Run

Este proyecto implementa el Quickstart de Google Cloud Platform para desplegar un servicio PHP en Cloud Run.

## Descripción del Proyecto

Una aplicación PHP simple que responde "Hello World!" y se despliega usando Cloud Run de Google Cloud Platform.

## Archivos del Proyecto

- `index.php`: Aplicación PHP principal
- `Dockerfile`: Configuración para containerizar la aplicación
- `.dockerignore`: Archivos a excluir del contenedor

## Prerequisitos

1. Cuenta de Google Cloud Platform
2. Google Cloud SDK instalado
3. Proyecto de GCP creado
4. APIs habilitadas:
   - Cloud Build API
   - Cloud Run API

## Pasos para Desplegar

### 1. Configuración Inicial

```bash
# Configurar proyecto de GCP
gcloud config set project [PROJECT-ID]

# Habilitar APIs necesarias
gcloud services enable cloudbuild.googleapis.com run.googleapis.com
```

### 2. Desplegar a Cloud Run

```bash
# Desplegar desde código fuente
gcloud run deploy helloworld-php \
    --source . \
    --platform managed \
    --region us-central1 \
    --allow-unauthenticated
```

### 3. Probar la Aplicación

Después del despliegue, obtendrás una URL para probar tu aplicación.

### 4. Limpiar Recursos

```bash
# Eliminar el servicio
gcloud run services delete helloworld-php --region us-central1
```

## Estructura del Código

### index.php
- Aplicación PHP que lee la variable de entorno `NAME`
- Responde con "Hello [NAME]!" o "Hello World!" por defecto
- Utiliza `htmlspecialchars()` para seguridad

### Dockerfile
- Basado en la imagen oficial `php:8.1-apache`
- Configura Apache para usar la variable de entorno `PORT`
- Copia el código fuente al contenedor
- Usa configuración de desarrollo de PHP

## Conceptos de DevOps Aplicados

1. **Containerización**: Uso de Docker para empaquetar la aplicación
2. **Infrastructure as Code**: Configuración declarativa con Dockerfile
3. **Serverless**: Uso de Cloud Run (serverless containers)
4. **CI/CD**: Despliegue directo desde código fuente
5. **Cloud Native**: Aplicación diseñada para la nube

## Referencias

- [Cloud Run Quickstart - PHP](https://cloud.google.com/run/docs/quickstarts/build-and-deploy/deploy-php-service?hl=es-419)
- [Docker PHP Official Images](https://hub.docker.com/_/php)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) 