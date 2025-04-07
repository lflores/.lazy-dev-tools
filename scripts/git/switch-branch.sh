#!/bin/bash
# =======================================================
# import utils code
# Read <root dir>/tools/utils.sh for more info
SCRIPT_DIR="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
BASE_DIR="$(realpath "$SCRIPT_DIR/../../")"
source "${BASE_DIR}/tools/utils.sh"
# =======================================================

switch_branch() {
    echo "$1"
    folder=$(basename "$PWD")
    if [ ! -d ".git" ]; then 
        echo -e "${LIGHT_GREEN}- $folder ${YELLOW}⚠ is not a git repository${NC}"
        return;
    fi
    if [[ -n $(git status --porcelain) ]]; then
        echo -e "${LIGHT_GREEN}- $folder ${YELLOW}⚠ has pending commits, aborting switch to develop${NC}"
        return;
    fi
        # Validar si los branches existen en el repo local
    if ! git show-ref --verify --quiet "refs/heads/$1"; then
        echo "❌ Error: The branch '$1' doesn't exist."
        exit 1
    fi
    git switch $1
}

#check if jq command exists
has_fzf=$(fzf --help)
if [ $? -ne 0 ]; then
    echo -e "${LIGHT_RED}'fzf' tool is required please install using 'sudo apt install fzf'."
    show_ubuntu_installer "fzf"
    exit
fi

# First I check if current folder is git repo
folder="./"
if [ ! -d ".git" ]; then 
    echo -e "${LIGHT_GREEN}- $folder ${YELLOW}⚠ is not a git repository${NC}"
    exit 1;
fi

if git branch > /dev/null 2>&1; then
    branches=$(git branch | awk '{if (NR!=1) print $1 ": " $(2) " -> " $(NF)}' | fzf --height 40%)
    if [[ -n $branches ]];then
        source_branch=$(echo "$branches" | awk -F ': ' '{print $1}')
    else
        echo "You haven't selected source branch"
    fi
fi
switch_branch $source_branch