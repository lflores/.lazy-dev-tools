#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m' # No Color

# installer config
PROJECT_REPO="https://github.com/lflores/.lazy-dev-tools.git"
PROJECT_DIR="$HOME/.lazy-dev-tools"

#removing project
echo "${GREEN}Removing .lazy-dev-tools project from ~/bin/lazy-dev-tools...${NC}"
rm -fr ~/bin/lazy-dev-tools
rm -fr ~/${PROJECT_DIR}

echo "${LIGHT_GREEN}Uninstallation complete. Now you can't run lazy-dev-tools.${NC}"