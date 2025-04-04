#!/bin/bash
# =======================================================
# import utils code
# Read <root dir>/tools/utils.sh for more info
SCRIPT_DIR="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
BASE_DIR="$(realpath "$SCRIPT_DIR/../../")"
source "${BASE_DIR}/tools/utils.sh"
# =======================================================

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
        # I believe that not to be forced here, because make slow method answer
        # Created Issue#12
    else
        echo -e "${LIGHT_GREEN}- $folder ${LIGHT_RED}❌${NC}$branch, ${LIGTH_BLUE} 🔀${NC} switching to ${LIGHT_GREEN}develop${NC}"
        git branch | grep 'develop' | xargs -n 1 git checkout
        # I believe that not to be forced here, because make slow method answer
        # Created Issue#12
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