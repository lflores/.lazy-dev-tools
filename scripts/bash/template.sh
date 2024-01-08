#!/bin/bash
# Colors for console
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m' # No Color

show_help() {
  echo "Uso: $0 -a <valorA> -b <valorB> [-t <tipo>]"
  echo "Descripción: Este script realiza alguna tarea."
  echo "  -a <valorA>: Especifica el valor A."
  echo "  -b <valorB>: Especifica el valor B."
  echo "  -t <tipo>: Especifica el tipo (opcional)."
}

# check options null
if [ "$#" -eq 0 ]; then
  show_help
  exit 1
fi

# Check parameters and required arguments
while getopts "t:h" opt; do
  case $opt in
    h) 
    show_help
        ;;
    t)
      paramType="$OPTARG"
      echo $opt con valor: $OPTARG
      ;;
    \?)
      echo "Opción inválida: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "La opción -$OPTARG requiere un argumento." >&2
      exit 1
      ;;
  esac
done
