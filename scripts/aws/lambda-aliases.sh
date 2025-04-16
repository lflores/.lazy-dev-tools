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
echo -e "👀 scanning service ${LIGHT_GREEN}${LAMBDA_NAME}${NC} with alias ${LIGHT_GREEN}${ALIAS_NAME}${NC}"
LIST_ALIASES=$(aws lambda list-aliases --function-name $LAMBDA_NAME)
echo -e "$LIST_ALIASES"