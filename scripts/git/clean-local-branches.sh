#!/bin/bash
# =======================================================
# import utils code
# Read <root dir>/tools/utils.sh for more info
SCRIPT_DIR="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
BASE_DIR="$(realpath "$SCRIPT_DIR/../../")"
source "${BASE_DIR}/tools/utils.sh"
# =======================================================

# echo -e "${LIGHT_GREEN}switching to develop branch..${NC}"
# git branch | grep 'develop' | xargs -n 1 git checkout
if [[ -n $(git status --porcelain) ]]; then
    echo -e "${LIGHT_GREEN}- $folder ${YELLOW}⚠ has pending commits, aborting switch to develop${NC}"
    exit 1;
fi
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$branch" == "develop" ]]; then
    echo -e "${LIGHT_GREEN}- $folder ${NC} ${LIGHT_GREEN}✔ ${NC}$branch"
else
    echo -e "${LIGHT_GREEN}- $folder ${LIGHT_RED}❌${NC}$branch, ${LIGTH_BLUE} 🔀${NC} switching to ${LIGHT_GREEN}develop${NC}"
        git branch | grep 'develop' | xargs -n 1 git checkout
fi
echo -e "${LIGHT_GREEN}⏬${NC} pulling develop changes...";
git pull;
echo -e "${LIGHT_GREEN}👁‍🗨fetching with pruning option...${NC}";
git fetch -p;
echo -e "${LIGHT_GREEN}running pruning of local branches${NC}"
git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -d;
echo -e "${LIGHT_GREEN}showing local branches...${NC}";
git branch