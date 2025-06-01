#!/bin/bash

# Script de configuración para GCP CI/CD con Azure Pipelines
# Autor: Laboratorio DevOps
# Fecha: $(date)

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funciones de utilidad
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que gcloud esté instalado
check_gcloud() {
    if ! command -v gcloud &> /dev/null; then
        print_error "gcloud CLI no está instalado. Por favor instálalo primero."
        exit 1
    fi
    print_status "gcloud CLI encontrado"
}

# Obtener ID del proyecto actual
get_project_id() {
    PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
    if [ -z "$PROJECT_ID" ]; then
        print_error "No hay proyecto configurado. Ejecuta: gcloud config set project [PROJECT-ID]"
        exit 1
    fi
    print_status "Proyecto actual: $PROJECT_ID"
}

# Habilitar APIs necesarias
enable_apis() {
    print_status "Habilitando APIs necesarias..."
    
    APIS=(
        "run.googleapis.com"
        "cloudbuild.googleapis.com"
        "containerregistry.googleapis.com"
        "iam.googleapis.com"
    )
    
    for api in "${APIS[@]}"; do
        print_status "Habilitando $api..."
        gcloud services enable $api
    done
    
    print_status "APIs habilitadas correctamente"
}

# Crear Service Account
create_service_account() {
    SA_NAME="azure-pipelines-sa"
    SA_EMAIL="$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"
    
    print_status "Creando Service Account: $SA_NAME"
    
    # Verificar si ya existe
    if gcloud iam service-accounts describe $SA_EMAIL &> /dev/null; then
        print_warning "Service Account ya existe: $SA_EMAIL"
    else
        gcloud iam service-accounts create $SA_NAME \
            --display-name="Azure Pipelines Service Account" \
            --description="Service Account para CI/CD desde Azure Pipelines"
        print_status "Service Account creado: $SA_EMAIL"
    fi
}

# Asignar roles al Service Account
assign_roles() {
    SA_EMAIL="azure-pipelines-sa@$PROJECT_ID.iam.gserviceaccount.com"
    
    print_status "Asignando roles al Service Account..."
    
    ROLES=(
        "roles/run.admin"
        "roles/storage.admin"
        "roles/iam.serviceAccountUser"
        "roles/cloudbuild.builds.builder"
    )
    
    for role in "${ROLES[@]}"; do
        print_status "Asignando rol: $role"
        gcloud projects add-iam-policy-binding $PROJECT_ID \
            --member="serviceAccount:$SA_EMAIL" \
            --role="$role"
    done
    
    print_status "Roles asignados correctamente"
}

# Crear clave del Service Account
create_service_account_key() {
    SA_EMAIL="azure-pipelines-sa@$PROJECT_ID.iam.gserviceaccount.com"
    KEY_FILE="azure-pipelines-key.json"
    
    print_status "Creando clave del Service Account..."
    
    gcloud iam service-accounts keys create $KEY_FILE \
        --iam-account=$SA_EMAIL
    
    print_status "Clave creada: $KEY_FILE"
    
    # Convertir a base64 para Azure DevOps
    print_status "Convertiendo clave a base64..."
    BASE64_KEY=$(cat $KEY_FILE | base64 -w 0)
    
    echo ""
    print_status "=== CONFIGURACIÓN PARA AZURE DEVOPS ==="
    echo ""
    echo "Crea las siguientes variables en Azure DevOps:"
    echo ""
    echo "GCP_PROJECT_ID: $PROJECT_ID"
    echo ""
    echo "GCP_SERVICE_ACCOUNT_KEY:"
    echo "$BASE64_KEY"
    echo ""
    print_warning "¡IMPORTANTE! Guarda estas variables de forma segura"
    
    # Guardar en archivo para referencia
    cat > azure-devops-variables.txt << EOF
# Variables para Azure DevOps Variable Group

GCP_PROJECT_ID: $PROJECT_ID

GCP_SERVICE_ACCOUNT_KEY:
$BASE64_KEY

# Archivo de clave original: $KEY_FILE
# Creado: $(date)
EOF
    
    print_status "Variables guardadas en: azure-devops-variables.txt"
}

# Crear bucket de prueba (opcional)
create_test_bucket() {
    BUCKET_NAME="$PROJECT_ID-cicd-test"
    
    print_status "Creando bucket de prueba: $BUCKET_NAME"
    
    if gsutil ls gs://$BUCKET_NAME &> /dev/null; then
        print_warning "Bucket ya existe: $BUCKET_NAME"
    else
        gsutil mb gs://$BUCKET_NAME
        print_status "Bucket creado: $BUCKET_NAME"
    fi
}

# Función principal
main() {
    print_status "=== CONFIGURACIÓN GCP PARA CI/CD CON AZURE PIPELINES ==="
    echo ""
    
    check_gcloud
    get_project_id
    
    echo ""
    print_status "¿Continuar con la configuración? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_status "Configuración cancelada"
        exit 0
    fi
    
    enable_apis
    create_service_account
    assign_roles
    create_service_account_key
    create_test_bucket
    
    echo ""
    print_status "=== CONFIGURACIÓN COMPLETADA ==="
    echo ""
    print_status "Próximos pasos:"
    echo "1. Copia las variables de azure-devops-variables.txt"
    echo "2. Configúralas en Azure DevOps > Pipelines > Library"
    echo "3. Crea un nuevo pipeline usando azure-pipelines.yml"
    echo "4. ¡Haz push de tu código para activar el CI/CD!"
    echo ""
    print_warning "Recuerda eliminar el archivo azure-pipelines-key.json después de configurar Azure DevOps"
}

# Ejecutar función principal
main "$@" 