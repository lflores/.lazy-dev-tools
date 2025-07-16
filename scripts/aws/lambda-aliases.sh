#!/bin/bash
# =======================================================
# import utils code
# Read <root dir>/tools/utils.sh for more info
SCRIPT_DIR="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
BASE_DIR="$(realpath "$SCRIPT_DIR/../../")"
source "${BASE_DIR}/tools/utils.sh"
# =======================================================

get_aliases(){
    if [[ ! -f "config.yaml" ]]; then
        echo -e "${YELLOW}⚠ config.yaml not found in ${folder}${NC}"
        return 1
    fi
    LAMBDA_NAME=$(grep '^name:' config.yaml | awk '{ print $2 }' | sed 's/^["'\'']//;s/["'\'']$//')
    ALIAS_NAME=$(grep 'alias:' config.yaml | awk '{ print $2 }' | sed 's/^["'\'']//;s/["'\'']$//')
    FOLDER_NAME=$(basename "$PWD")
    echo -e "👀 scanning service ${LIGHT_GREEN}${LAMBDA_NAME}${NC} with alias ${LIGHT_GREEN}${ALIAS_NAME}${NC}"
    LIST_ALIASES=$(aws lambda list-aliases --function-name $LAMBDA_NAME 2>&1)
    if echo "$LIST_ALIASES" | grep -q "ResourceNotFoundException"; then
        echo -e "${LIGHT_RED}❌ Lambda function '$LAMBDA_NAME' not found.${NC}"
        return 1
    fi

    if ! echo "$LIST_ALIASES" | grep -q "\"Name\": \"$ALIAS_NAME\""; then
        echo -e "${YELLOW}⚠ Alias '$ALIAS_NAME' not found for Lambda '$LAMBDA_NAME'.${NC} in $FOLDER_NAME" 
        return 2
    fi
    echo -e "$LIST_ALIASES"
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
    get_aliases
    cd -> /dev/null
    ((counter++))
done

echo -e "Checked ${counter} folders"