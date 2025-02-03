#!/bin/bash

# Load environment variables from ~/.aider.env
ENV_FILE="$HOME/.aider/.env"


if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
else
    echo "Error: Environment file '$ENV_FILE' not found."
    exit 1
fi

# Docker image configuration
DOCKER_REPO="paulgauthier/aider-full"
DOCKER_IMAGE="$DOCKER_REPO:$DOCKER_IMAGE_TAG"

# Ensure required environment variables are set
REQUIRED_VARS=("GIT_EMAIL" "GIT_NAME" "DOCKER_IMAGE_TAG" "OPENAI_API_KEY" "DEEPSEEK_API_KEY")
for VAR in "${REQUIRED_VARS[@]}"; do
    if [[ -z "${!VAR}" ]]; then
        echo "Error: Environment variable '$VAR' is not set."
        exit 1
    fi
done

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH."
    exit 1
fi

# Check if Docker image exists, if not, pull it
if ! docker image inspect "$DOCKER_IMAGE" > /dev/null 2>&1; then
    echo "Docker image '$DOCKER_IMAGE' not found. Pulling the image..."
    docker pull "$DOCKER_IMAGE"
fi
setup_git() {
    git config user.email "$GIT_EMAIL"
    git config user.name "$GIT_NAME"
    echo "Git configured with email '$GIT_EMAIL' and name '$GIT_NAME'."
}

# Display menu and get user choice
display_menu() {
    echo "Select an option:"
    echo "1) OpenAI"
    echo "2) OpenAI with Architect"
    echo "3) Anthropics' Claude"
    echo "4) Anthropics' Claude with Architect"
    echo "5) Deepseek"
    echo "6) Deepseek with Reasoning Model"
    read -p "Enter choice [1-6]: " choice
}

# Common Docker run options
DOCKER_RUN_OPTS=(
    -it
    --user "$(id -u):$(id -g)"
    --volume "$(pwd)":/app
    --volume "$AIDER_HOME":/home/user/.aider
    -e HOME=/home/user
    -e GIT_AUTHOR_NAME="$(git config --global --get user.name)"
    -e GIT_AUTHOR_EMAIL="$(git config --global --get user.email)"
)

# Run aider in Docker based on user choice
run_aider() {
    case $choice in
        1)
            docker run "${DOCKER_RUN_OPTS[@]}" "$DOCKER_IMAGE" --openai-api-key "$OPENAI_API_KEY" --model "openai/gpt-4o"
            ;;
        2)
            docker run "${DOCKER_RUN_OPTS[@]}" "$DOCKER_IMAGE" --openai-api-key "$OPENAI_API_KEY" --model "openai/gpt-4o"
            ;;
        3)
            docker run "${DOCKER_RUN_OPTS[@]}" "$DOCKER_IMAGE" --anthropic-api-key "$ANTHROPIC_API_KEY"
            ;;
        4)
            docker run "${DOCKER_RUN_OPTS[@]}" "$DOCKER_IMAGE" --anthropic-api-key "$ANTHROPIC_API_KEY" --architect --yes-always
            ;;
        5)
            docker run "${DOCKER_RUN_OPTS[@]}" -e DEEPSEEK_API_KEY="$DEEPSEEK_API_KEY" "$DOCKER_IMAGE" --deepseek --model "deepseek/deepseek-coder"
            ;;
        6)
            docker run "${DOCKER_RUN_OPTS[@]}" -e DEEPSEEK_API_KEY="$DEEPSEEK_API_KEY" "$DOCKER_IMAGE" --deepseek --model "deepseek/deepseek-reasoner"
            ;;
        *)
            echo "Invalid choice."
            exit 1
            ;;
    esac

    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to run aider container."
        exit 1
    fi
}

# Main execution
setup_git
display_menu
run_aider
