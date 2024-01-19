#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m' # No Color

show_ubuntu_installer() {
    echo -e "${YELLOW}Or if you have Ubuntu, please follow next url for more info https://command-not-found.com/$1${NC}"
}

# check if curl is installed
has_git=$(curl --help)
if [ $? -ne 0 ]; then
    echo -e "${LIGHT_RED}'curl' tool is required please install using 'sudo apt install curl'."
    show_ubuntu_installer "curl"
    exit
fi

# check if git is installed
has_git=$(git --help)
if [ $? -ne 0 ]; then
    echo -e "${LIGHT_RED}'git' tool is required please install using 'sudo apt install git'."
    show_ubuntu_installer "git"
    exit
fi

# installer config
PROJECT_REPO="https://github.com/lflores/.lazy-dev-tools.git"
PROJECT_DIR="$HOME/.lazy-dev-tools"

# download repository
echo -e "${GREEN}Downloading project from ${PROJECT_REPO}...${NC}"
git clone "$PROJECT_REPO" "$PROJECT_DIR"

# check if download was successful
if [ $? -ne 0 ]; then
  echo -e "${RED}Error: No se pudo descargar el proyecto. Verifica la URL del repositorio.${NC}"
  exit 1
fi

# Configure console
echo -e "${LIGTH_GREEN}Configuring console to run project...${NC}"

# If bin folder doesn't exist in $PATH create it and configure
if [ ! -d "$HOME/bin" ]; then
  mkdir "$HOME/bin"
fi

# Create symbolic link for lazy-dev-tools launcher
ln -s "$PROJECT_DIR/lazy-dev-tools.sh" "$HOME/bin/lazy-dev-tools"

# Verify if the symbolic link could be created
if [ $? -ne 0 ]; then
  echo -e "${RED}Error:${NC} ${YELLOW}No se pudo crear el enlace simbólico en el directorio binario.${NC}"
  exit 1
fi

echo -e "${LIGHT_GREEN}Installation complete. Now you can run lazy-dev-tools.${NC}"