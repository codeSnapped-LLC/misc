#!/bin/bash
set -eo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

handle_error() {
    local line="$1"
    local message="${2:-}"
    echo -e "${RED}Error occurred on line $line${NC}: ${message}"
    exit 1
}

trap 'handle_error $LINENO' ERR

usage() {
    echo "Usage: $0 <git-ssh-url>"
    exit 1
}

clone_repo() {
    local repo_url="$1"
    echo -e "${GREEN}Cloning repository...${NC}"
    git clone "$repo_url" || { echo -e "${RED}Failed to clone repository${NC}"; return 1; }
}

init_gitflow() {
    echo -e "${GREEN}Initializing git flow...${NC}"
    git flow init -d || { echo -e "${RED}Git flow initialization failed${NC}"; return 1; }
}

create_gitversion_config() {
    echo -e "${GREEN}Creating gitversion config...${NC}"
    cp gitflow-setup/gitversion-config.txt gitversion.yml
}

initial_commit() {
    echo -e "${GREEN}Creating initial commit...${NC}"
    git add gitversion.yml
    git commit -m "Initialize repository with gitflow and gitversion"
    git push --all
    git push --tags
}

main() {
    [[ $# -eq 1 ]] || usage
    local REPO_URL="$1"
    local REPO_NAME
    REPO_NAME=$(basename "$REPO_URL" .git)

    clone_repo "$REPO_URL"
    cd "$REPO_NAME" || { echo -e "${RED}Failed to enter repository directory${NC}"; return 1; }
    init_gitflow
    create_gitversion_config
    setup_precommit
    initial_commit

    echo -e "${GREEN}Repository setup complete in ${REPO_NAME}${NC}"
    echo -e "Read gitflow-readme.md for usage instructions"
}

setup_precommit() {
    echo -e "${GREEN}Setting up pre-commit hooks...${NC}"
    cp gitflow-setup/pre-commit-config.txt .pre-commit-config.yaml
    pre-commit install
    pre-commit run --all-files || { echo -e "${RED}Pre-commit checks failed${NC}"; return 1; }
}

main "$@"
