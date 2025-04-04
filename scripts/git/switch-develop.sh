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

switch_develop() {
    folder=$(basename "$PWD")
    if [ ! -d ".git" ]; then 
        echo -e "${LIGHT_GREEN}- $folder ${YELLOW}⚠ is not a git repository${NC}"
        return;
    fi
    if [[ -n $(git status --porcelain) ]]; then
        echo -e "${LIGHT_GREEN}- $folder ${YELLOW}⚠ has pending commits, aborting switch to develop${NC}"
        return;
    fi
    branch=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$branch" == "develop" ]]; then
        echo -e "${LIGHT_GREEN}- $folder ${NC} ${LIGHT_GREEN}✔ ${NC}$branch"
        git fetch --force
        git pull
    else
        echo -e "${LIGHT_GREEN}- $folder ${LIGHT_RED}❌${NC}$branch"
        git branch | grep 'develop' | xargs -n 1 git checkout
        git fetch --force
        git pull
    fi
}

# First I check if current folder is git repo
folder="./"

if [ -d ".git" ]; then 
    switch_develop
    exit 0
fi

EXCLUDED_FILE=".excluded"
EXCLUDE_DIRS=()

if [[ -f "$EXCLUDED_FILE" ]]; then
    mapfile -t EXCLUDE_DIRS < "$EXCLUDED_FILE"
fi
FOLDERS=`ls -D`;

counter=0;

for folder in $FOLDERS; do
    if [[ " ${EXCLUDE_DIRS[@]} " =~ "${folder}" ]]; then
        # echo -e "${YELLOW}${folder} está excluido${NC}"
        continue;
    fi
    cd $PWD/$folder
    switch_develop
    cd -> /dev/null
    ((counter++))
done

echo -e "Checked ${counter} folders"