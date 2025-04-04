#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Search this source script path
# BASE_DIR="$(dirname -- "$BASH_SOURCE")"
BASE_DIR="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
# Define scripts navigation path
SCRIPTS_DIR="$BASE_DIR/scripts"

# Función de autocompletación para un parámetro específico
_autocompletar_parametro() {
    local parametros=("opcion1" "opcion2" "opcion3")
    COMPREPLY=($(compgen -W "${parametros[*]}" -- "${COMP_WORDS[COMP_CWORD]}"))
}

# Registra la función de autocompletación para el primer parámetro
complete -F _autocompletar_parametro lazy-dev-tools.sh

# List visible scripts
show_scripts() {
    echo "Allowed scripts:"
    for script in "$SCRIPTS_DIR/$1"/*; do
        echo -e "  - ${GREEN}$(basename $script .sh)${NC}"
    done
}

# Show modules options
show_options() {
    echo "Show options: "
    # module=$(find . -maxdepth 1 -type d | sed 's|./||' | fzf --height 40%)
    for folder in $SCRIPTS_DIR/*/; do
        echo -e "  - ${GREEN}$(basename "$folder")${NC}"
    done
}

show_ubuntu_installer() {
    echo -e "${YELLOW}Or if you have Ubuntu, please follow next url for more info https://command-not-found.com/$1${NC}"
}

#check if jq command exists
has_jq=$(jq --help)
if [ $? -ne 0 ]; then
    echo -e "${LIGHT_RED}'jq' tool is required please install using 'sudo apt install jq'."
    show_ubuntu_installer "jq"
    exit
fi

#check if fzf command exists
has_fzf=$(fzf --help)
if [ $? -ne 0 ]; then
    echo -e "${LIGHT_RED}'fzf' tool is required please install using 'sudo apt install fzf'${NC}."
    show_ubuntu_installer "fzf"
    exit
fi

# Check if receive model indicator or first param
if [ -z "$1" ]; then
    echo -e "${LIGHT_GREEN}Please, give a module name, such as aws, bash docker etc.${NC}"
    show_options
    exit 1
fi

if [ ! -d "$SCRIPTS_DIR/$1" ]; then
    echo "The module $1 does not exist"
    echo "Please insert valid module name"
    show_options
    exit 1
fi

# Check if receive script name to execute
if [ -z "$2" ]; then
    echo "Please, give me a script name."
    show_scripts $1
    exit 1
fi

# Check if script name exists
SCRIPT_SH="$SCRIPTS_DIR/$1/$2.sh"
SCRIPT_PY="$SCRIPTS_DIR/$1/$2.py"

#check if python3 exist
has_python=$(python3 --help)

# Verify if python script exists and check if aso exist python3 command to run it
if [ -f "$SCRIPT_PY" ] && [ $? -ne 0 ]; then
    echo -e "${LIGHT_RED}'python3' tool is required please install using 'sudo apt install python3'${NC}"
    show_ubuntu_installer "python3"
    exit 1
fi

if [ -f "$SCRIPT_SH" ]; then
    echo -e "${LIGHT_GREEN}running: ${NC} $1 $(basename $SCRIPT_SH)...\n----------------------------"
    bash "$SCRIPT_SH" "${@:3}" # Send additional arguments
    echo "--------------------------"
elif [ -f "$SCRIPT_PY" ]; then
    echo -e "${LIGHT_GREEN}running :${NC} $1 $(basename $SCRIPT_PY)...\n----------------------------"
    python3 "$SCRIPT_PY" "${@:3}" # Send additional arguments
    echo "--------------------------"
else
    echo -e "${YELLOW}The script '$2' with extension sh or py doesn't exist.${NC}"
    show_scripts $1
    exit 1
fi