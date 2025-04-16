
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
echo -e "👀 updating service ${LIGHT_GREEN}${LAMBDA_NAME}${NC} with alias ${LIGHT_GREEN}${ALIAS_NAME}${NC}"

LATEST_VERSION=$(aws lambda list-versions-by-function --function-name $LAMBDA_NAME --query "Versions[-1].Version" --output text)
ALIAS_VERSION=$(aws lambda get-alias --function-name $LAMBDA_NAME --name prod --query "FunctionVersion" --output text)

UPDATE_VERSION=$(aws lambda update-alias --function-name $LAMBDA_NAME --name $ALIAS_NAME --function-version $LATEST_VERSION --output text)
sleep 5
#after update check version again
LATEST_VERSION=$(aws lambda list-versions-by-function --function-name $LAMBDA_NAME --query "Versions[-1].Version" --output text)
if [ "$LATEST_VERSION" != "$ALIAS_VERSION" ]; then
    echo -e "${LIGHT_RED}❌${NC} Alias for ${LAMBDA_NAME} prod is pointing to version ${ALIAS_VERSION} but latest version is $LATEST_VERSION"
else
    echo -e "${LIGHT_GREEN}✔${NC} Alias ${LAMBDA_NAME} prod is up to date with latest version (${LATEST_VERSION})"
fi
