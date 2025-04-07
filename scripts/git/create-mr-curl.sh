# Script to create merge requests by interactive mode
# =======================================================
# import utils code
# Read <root dir>/tools/utils.sh for more info
SCRIPT_DIR="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
BASE_DIR="$(realpath "$SCRIPT_DIR/../../")"
source "${BASE_DIR}/tools/utils.sh"
# =======================================================

SCRIPT_DIR="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
BASE_DIR="$(realpath "$SCRIPT_DIR/../../")"
source "${BASE_DIR}/tools/utils.sh"
# 🔹 Configuración
GITLAB_HOST="https://gitlab.com"     # Cambia si usas self-hosted GitLab

show_ubuntu_installer() {
    echo -e "${YELLOW}Or if you have Ubuntu, please follow next url for more info https://command-not-found.com/$1${NC}"
}
# -------------------
# Create a branch into gitlab server
# $1 Parameter - Origin branch
# $2 Parameter - Destination branch
# ------------------
create_merge_request() {
    # Obtener la URL del repositorio remoto
    repo_url=$(git config --get remote.origin.url)

    # Extraer el namespace y nombre del repo (soporta HTTPS y SSH)
    if [[ "$repo_url" =~ git@.*:(.*).git ]]; then
        repo_path="${BASH_REMATCH[1]}"
    elif [[ "$repo_url" =~ https://.*gitlab.com/(.*).git ]]; then
        repo_path="${BASH_REMATCH[1]}"
    else
        echo "❌ Error: Recovering repo name."
        exit 1
    fi
    # Validar si los branches existen en el repo local
    if ! git show-ref --verify --quiet "refs/heads/$1"; then
        echo "❌ Error: Origin branch '$1' doesn't exist."
        exit 1
    fi

    # Verificar si hay cambios sin commit
    if [[ -n $(git status --porcelain) ]]; then
        echo "⚠️ You have pending commits. Aborting."
        exit 1
    fi

    # Crear el Merge Request con la API de GitLab
    echo "🚀 Creating Merge Request in GitLab..."

    response=$(curl --silent --request POST "$GITLAB_HOST/api/v4/projects/$(echo -n "$repo_path" | jq -sRr @uri)/merge_requests" \
        --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
        --header "Content-Type: application/json" \
        --data "{
            \"source_branch\": \"$1\",
            \"target_branch\": \"$2\",
            \"title\": \"feat: merge $1 to $2\",
            \"remove_source_branch\": false,
            \"squash\": false
        }")

    # Verificar respuesta
    mr_url=$(echo "$response" | jq -r '.web_url // empty')

    if [[ -n "$mr_url" ]]; then
        echo "✅ Successful Merge Request created: $mr_url"
    else
        echo "❌ Error creating merge Request."
        echo "$response" | jq .
    fi
}

PAT_FILE="~/.gitlab_pat"

#check if jq command exists
has_fzf=$(fzf --help)
if [ $? -ne 0 ]; then
    echo -e "${LIGHT_RED}'fzf' tool is required please install using 'sudo apt install fzf'."
    show_ubuntu_installer "fzf"
    exit
fi

if [[ ! -f $PAT_FILE ]]; then 
    echo "❌ GitLab PAT file not found."
    echo ""
    echo "📌 How to create it:"
    echo "1️⃣ Run the following command to create the file:"
    echo -e "   echo 'your_personal_access_token' > ${PAT_FILE}"
    echo ""
    echo "2️⃣ Secure the file permissions (optional but recommended):"
    echo "   chmod 600 $PAT_FILE"
    echo ""
    echo "3️⃣ Retry running the script."
    echo ""
    exit 1
fi

GITLAB_TOKEN=$(cat $PAT_FILE | tr -d '[:space:]')
echo "✅ Gitlab PAT token has been loaded"

echo "The token is $GITLAB_TOKEN"

exit 0
echo -e "${GREEN}Please select origin branch${NC}"
if git branch > /dev/null 2>&1; then
    branches=$(git branch | awk '{if (NR!=1) print $1 ": " $(2) " -> " $(NF)}' | fzf --height 40%)
    if [[ -n $branches ]];then
        source_branch=$(echo "$branches" | awk -F ': ' '{print $1}')
        #echo $source_branch
    else
        echo "You haven't selected source branch"
    fi
fi
echo -e "${LIGHT_GREEN}Selected origin branch was:${NC} $source_branch"
echo -e "${GREEN}Please select destination branch"
if git branch > /dev/null 2>&1; then
    branches=$(git branch | awk '{if (NR!=1) print $1 ": " $(2) " -> " $(NF)}' | fzf --height 40%)
    if [[ -n $branches ]];then
        destination_branch=$(echo "$branches" | awk -F ': ' '{print $1}')
        #echo $source_branch
    else
        echo "You haven't selected source branch"
    fi
fi
echo -e "${LIGHT_GREEN}Selected destination branch was:${NC} $destination_branch"

create_merge_request $source_branch $destination_branch
# Pedir origen y destino
#read -p "📌 Ingresa el branch origen: " source_branch
#read -p "📌 Ingresa el branch destino (default: develop): " target_branch
#target_branch=${target_branch:-develop}

