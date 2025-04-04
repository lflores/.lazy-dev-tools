#!/bin/bash
# =======================================================
# import utils code
# Read <root dir>/tools/utils.sh for more info
SCRIPT_DIR="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
BASE_DIR="$(realpath "$SCRIPT_DIR/../../")"
source "${BASE_DIR}/tools/utils.sh"
# =======================================================

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
