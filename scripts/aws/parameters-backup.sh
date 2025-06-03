#!/bin/bash
# =======================================================
# import utils code
# Read <root dir>/tools/utils.sh for more info
SCRIPT_DIR="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
BASE_DIR="$(realpath "$SCRIPT_DIR/../../")"
source "${BASE_DIR}/tools/utils.sh"
# =======================================================

get_parameter_info() {
    FILENAME="$1"
    #echo -e "Backing up: $1"
    VALUE=$(aws ssm get-parameter --name " $1" --query "Parameter.Value" --output text 2> /dev/null)
    # aws ssm get-parameter --name "/bppr/mb/move-money/popular-pay/certificate" --query "Parameter.Value" --output text
    # aws ssm get-parameter --name " /bppr/mb40/accounts/il/connection_info" --query "Parameter.Value" --output text
    # aws ssm get-parameters-by-path --path "/bppr/mb/move-money/popular-pay/certificate"
    # aws ssm describe-parameters --query "Parameters[*].Name" --output text
    # aws ssm describe-parameters --query "Parameters[?contains(Name,'config')].Name" --output string
    # aws ssm describe-parameters --query "Parameters[?contains(Name,'/bppr/mb40/accounts/il/connection_info')].Name" --output text
    #echo -e "$VALUE"
    if [[ -n $VALUE ]];then
        echo -e "${LIGHT_GREEN}✔${NC} Parameter found: $1"
        SAFE_NAME=$(echo $FILENAME | sed -E 's|^/||; s|/|_|g')
        echo "$VALUE" > "$2/${SAFE_NAME}.json"
        ((counter++))
    else
        echo -e "${LIGHT_RED}❌${NC} Parameter not found: $1"
    fi
    return
}

# First I check if current folder is git repo
folder="./"
PARAMETERS_FILE=".parameters"
if [[ ! -f "$PARAMETERS_FILE" ]]; then
     echo -e "${YELLOW} - ⚠ The file $PARAMETERS_FILE is required to know which parameters you needs backup${NC}"    
     exit 1
fi

counter=0;
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output json)
ACCOUNT_ID=$(echo "$ACCOUNT_ID" | tr -d '"[:space:]')
ACCOUNT_ID="parameters/$ACCOUNT_ID"

if [[ ! -f "$ACCOUNT_ID" ]]; then
    echo -e "Creando ${ACCOUNT_ID}"
    mkdir -p "$ACCOUNT_ID"
fi

while IFS= read -r parameter; do
    get_parameter_info $parameter $ACCOUNT_ID
done < "$PARAMETERS_FILE"

echo -e "${LIGHT_GREEN}👀${NC} Backuped ${counter} parameters"