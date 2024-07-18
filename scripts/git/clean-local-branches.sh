#!/bin/bash

# ========================
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m' # No Color

echo -e "${LIGHT_GREEN}switching to develop branch..${NC}"
git branch | grep 'develop' | xargs -n 1 git checkout
echo -e "${LIGHT_GREEN}pulling develop changes...${NC}";
git pull;
echo -e "${LIGHT_GREEN}fetching with pruning option...${NC}";
git fetch -p;
echo -e "${LIGHT_GREEN}running pruning of local branches${NC}"
git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -d;
echo -e "${LIGHT_GREEN}showing local branches...${NC}";
git branch
