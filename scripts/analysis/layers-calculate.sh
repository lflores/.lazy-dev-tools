#!/bin/bash

# Archivo de carpetas excluidas
EXCLUDED_FILE=".excluded"
declare -A EXCLUDE_DIRS

# Leer carpetas excluidas en un array asociativo
if [[ -f "$EXCLUDED_FILE" ]]; then
    while IFS= read -r line; do
        [[ -n "$line" ]] && EXCLUDE_DIRS["$line"]=1
    done < "$EXCLUDED_FILE"
fi

# echo "Carpetas excluidas: ${!EXCLUDE_DIRS[@]}"

declare -A LAYER_USAGE

# Buscar archivos .mjs y procesar imports
while IFS= read -r filepath; do
    # Excluir archivos dentro de node_modules
    if [[ "$filepath" == *"/node_modules/"* 
        || "$filepath" == *"/__mocks__/"* 
        || "$filepath" == *"/test/"*
        || "$filepath" == *"/tests/"* 
        || "$filepath" == *".config.mjs"*
        || "$filepath" == *"/cdk.out/"*
        || "$filepath" == *"/bff/"*
        || "$filepath" == *"/bl/"*
        ]]; then
        continue
    fi
    # Obtener carpeta raíz del archivo
    folder=$(echo "$filepath" | cut -d'/' -f2)
    echo "Procesando archivo: $filepath en carpeta: $folder"
    # Saltar si la carpeta está excluida
    if [[ -n "${EXCLUDE_DIRS[$folder]}" ]]; then
        continue
    fi
    # Buscar imports de layers en el archivo
    while IFS= read -r import; do
        layer=$(echo "$import" | sed -nE 's/.*from[[:space:]]+"(\/opt\/nodejs\/[^"]+)".*/\1/p')
        if [[ -n "$layer" ]]; then
            LAYER_USAGE["$layer"]+="$filepath;"
        fi
    done < <(grep -E 'import[[:space:]]+\{[^}]+\}[[:space:]]+from[[:space:]]+["'\'']/opt/nodejs/[^"'\'']+["'\'']' "$filepath")
done < <(find . -type f -name "*.mjs")

# Encabezado Markdown
echo -e "| Layer Lambda | Frecuencia | Impacto | Total |"
echo -e "|--------------|------------|---------|-------|"

# Calcular y mostrar pesos en formato Markdown
for layer in "${!LAYER_USAGE[@]}"; do
    IFS=';' read -ra files <<< "${LAYER_USAGE[$layer]}"
    frecuencia=0
    for f in "${files[@]}"; do
        [[ -n "$f" ]] && ((frecuencia++))
    done
    # Impacto: puedes ajustar la fórmula, aquí se iguala a la frecuencia como ejemplo
    impacto=$frecuencia
    total=$((frecuencia + impacto))
    echo "| $layer | $frecuencia | $impacto | $total |"
done