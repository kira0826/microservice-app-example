#!/bin/bash

# Función para incrementar versión
increment_version() {
    local version=$1
    local type=$2  # major, minor, o patch
    
    # Remover 'v' del inicio si existe
    version="${version#v}"
    
    # Separar la versión en partes
    IFS='.' read -r -a parts <<< "$version"
    local major="${parts[0]}"
    local minor="${parts[1]}"
    local patch="${parts[2]}"
    
    case $type in
        "major")
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        "minor")
            minor=$((minor + 1))
            patch=0
            ;;
        "patch")
            patch=$((patch + 1))
            ;;
    esac
    
    echo "v$major.$minor.$patch"
}

# Función para actualizar versión de un servicio
update_service_version() {
    local service=$1
    local type=$2
    
    if [ ! -d "$service" ]; then
        echo "Error: El directorio $service no existe"
        exit 1
    fi
    
    # Crear archivo VERSION si no existe
    if [ ! -f "$service/VERSION" ]; then
        echo "v1.0.0" > "$service/VERSION"
    fi
    
    # Leer versión actual
    local current_version=$(cat "$service/VERSION")
    
    # Calcular nueva versión
    local new_version=$(increment_version "$current_version" "$type")
    
    # Guardar nueva versión
    echo "$new_version" > "$service/VERSION"
    echo "Versión de $service actualizada a $new_version"
}

# Mostrar ayuda
show_help() {
    echo "Uso: $0 <servicio> <tipo>"
    echo "  servicio: auth-api, frontend, log-message-processor, todos-api, users-api"
    echo "  tipo: major, minor, patch"
    echo "Ejemplo: $0 auth-api minor"
}

# Verificar argumentos
if [ "$#" -ne 2 ]; then
    show_help
    exit 1
fi

# Validar servicio
valid_services=("auth-api" "frontend" "log-message-processor" "todos-api" "users-api")
if [[ ! " ${valid_services[@]} " =~ " $1 " ]]; then
    echo "Error: Servicio inválido"
    show_help
    exit 1
fi

# Validar tipo de incremento
valid_types=("major" "minor" "patch")
if [[ ! " ${valid_types[@]} " =~ " $2 " ]]; then
    echo "Error: Tipo de incremento inválido"
    show_help
    exit 1
fi

# Ejecutar actualización
update_service_version "$1" "$2"