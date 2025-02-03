#!/bin/bash

# Load environment variables from ~/.aider.env
ENV_FILE="$HOME/.aider/.env"

if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
else
    echo "Error: Environment file '$ENV_FILE' not found."
    exit 1
fi

# Ensure required environment variables are set
REQUIRED_VARS=("GIT_EMAIL" "GIT_NAME" "OPENAI_API_KEY" "DEEPSEEK_API_KEY")
for VAR in "${REQUIRED_VARS[@]}"; do
    if [[ -z "${!VAR}" ]]; then
        echo "Error: Environment variable '$VAR' is not set."
        exit 1
    fi
done

# Check if Aider is installed
if ! command -v aider &> /dev/null; then
    echo "Error: Aider is not installed. Please follow the installation instructions at https://aider.chat/docs/install.html"
    exit 1
fi

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

# Run aider based on user choice
run_aider() {
    case $choice in
        1)
            aider --openai-api-key "$OPENAI_API_KEY" --model "openai/gpt-4o"
            ;;
        2)
            aider --openai-api-key "$OPENAI_API_KEY" --model "openai/gpt-4o"
            ;;
        3)
            aider --anthropic-api-key "$ANTHROPIC_API_KEY"
            ;;
        4)
            aider --anthropic-api-key "$ANTHROPIC_API_KEY" --architect --yes-always
            ;;
        5)
            aider --deepseek --model "deepseek/deepseek-coder" --api-key "$DEEPSEEK_API_KEY"
            ;;
        6)
            aider --deepseek --model "deepseek/deepseek-reasoner" --api-key "$DEEPSEEK_API_KEY"
            ;;
        *)
            echo "Invalid choice."
            exit 1
            ;;
    esac

    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to run aider."
        exit 1
    fi
}

# Main execution
display_menu
run_aider
