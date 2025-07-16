
#!/bin/bash
# =======================================================
# import utils code
# Read <root dir>/tools/utils.sh for more info
SCRIPT_DIR="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
BASE_DIR="$(realpath "$SCRIPT_DIR/../../")"
source "${BASE_DIR}/tools/utils.sh"
# =======================================================

check_prod_last_version() {
    if [[ ! -f "config.yaml" ]]; then
        echo -e "${YELLOW}⚠ config.yaml not found in ${folder}${NC}"
        return 1
    fi
    FOLDER_NAME=$(basename "$PWD")
    LAMBDA_NAME=$(grep '^name:' config.yaml | awk '{ print $2 }' | sed 's/^["'\'']//;s/["'\'']$//')
    ALIAS_NAME=$(grep 'alias:' config.yaml | awk '{ print $2 }' | sed 's/^["'\'']//;s/["'\'']$//' | tr -d '"')
    
    if [ -z "$ALIAS_NAME" ]; then
        echo -e "${LIGHT_RED}❌${NC} ${LAMBDA_NAME} doesn't have alias $ALIAS_NAME"
        return 0;
    fi
    echo -e "👀 scanning service ${LIGHT_GREEN}${LAMBDA_NAME}${NC} with alias ${LIGHT_GREEN}${ALIAS_NAME}${NC}"
    LATEST_VERSION=$(aws lambda list-versions-by-function --function-name $LAMBDA_NAME --query "Versions[-1].Version" | tr -d '"')
    ALIAS_VERSION=$(aws lambda get-alias --function-name $LAMBDA_NAME --name $ALIAS_NAME --query "FunctionVersion" --output text 2>&1)

    if [ -z "$ALIAS_VERSION" ]; then
        echo -e "${LIGHT_RED}❌${NC} ${LAMBDA_NAME} doesn't have alias $ALIAS_NAME"
        return 0;
    fi

    if [ "$LATEST_VERSION" != "$ALIAS_VERSION" ]; then
        echo -e "${LIGHT_RED}❌${NC} Alias ${LIGHT_GREEN}$ALIAS_NAME${NC} is out to date into ${LIGHT_GREEN}${LAMBDA_NAME}${NC} is pointing to version ${LIGHT_RED}${ALIAS_VERSION}${NC} but latest version is ${LIGHT_GREEN}${LATEST_VERSION}${NC}"
    else
        echo -e "${LIGHT_GREEN}✔${NC} Alias ${LIGHT_GREEN}$ALIAS_NAME${NC} is up to date into ${LIGHT_GREEN}${LAMBDA_NAME}${NC} with latest version (${LIGHT_GREEN}${LATEST_VERSION}${NC})"
    fi
}

# First I check if current folder is git repo
folder="./"

if [ -d ".git" ]; then 
    check_prod_last_version
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
    check_prod_last_version
    cd -> /dev/null
    ((counter++))
done

echo -e "Checked ${counter} folders"