
#!/bin/bash
# =======================================================
# import utils code
# Read <root dir>/tools/utils.sh for more info
SCRIPT_DIR="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
BASE_DIR="$(realpath "$SCRIPT_DIR/../../")"
source "${BASE_DIR}/tools/utils.sh"
# =======================================================

LAMBDA_NAME=$(grep '^name:' config.yaml | awk '{ print $2 }' | sed 's/^["'\'']//;s/["'\'']$//')
ALIAS_NAME=$(grep 'alias:' config.yaml | awk '{ print $2 }' | sed 's/^["'\'']//;s/["'\'']$//')

if [ -z "$ALIAS_NAME" ]; then
    echo -e "${LIGHT_RED}❌${NC} ${LAMBDA_NAME} doesn't have alias $ALIAS_NAME"
    exit 1;
fi
echo -e "👀 scanning service ${LIGHT_GREEN}${LAMBDA_NAME}${NC} with alias ${LIGHT_GREEN}${ALIAS_NAME}${NC}"
LATEST_VERSION=$(aws lambda list-versions-by-function --function-name $LAMBDA_NAME --query "Versions[-1].Version" --output text)
ALIAS_VERSION=$(aws lambda get-alias --function-name $LAMBDA_NAME --name $ALIAS_NAME --query "FunctionVersion" --output text)

if [ -z "$ALIAS_VERSION" ]; then
    echo -e "${LIGHT_RED}❌${NC} ${LAMBDA_NAME} doesn't have alias $ALIAS_NAME"
    exit 1;
fi

if [ "$LATEST_VERSION" != "$ALIAS_VERSION" ]; then
    echo -e "${LIGHT_RED}❌${NC} Alias ${LIGHT_GREEN}$ALIAS_NAME${NC} is out to date into ${LIGHT_GREEN}${LAMBDA_NAME}${NC} is pointing to version ${LIGHT_RED}${ALIAS_VERSION}${NC} but latest version is ${LIGHT_GREEN}$LATEST_VERSION${NC}"
else
    echo -e "${LIGHT_GREEN}✔${NC} Alias ${LIGHT_GREEN}$ALIAS_NAME${NC} is up to date into ${LIGHT_GREEN}${LAMBDA_NAME}${NC} with latest version (${LIGHT_GREEN}${LATEST_VERSION}${NC})"
fi
