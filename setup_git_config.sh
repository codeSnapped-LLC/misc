#!/bin/bash

# Interactive Git configuration setup script
# Sets up global git config with proper error handling

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Error handling function
error_exit() {
  echo -e "${RED}[ERROR] $1${NC}" >&2
  exit 1
}

# Validate email format
validate_email() {
  local email="$1"
  if [[ ! "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    error_exit "Invalid email format: $email"
  fi
}

# Main configuration function
configure_git() {
  echo -e "${GREEN}Setting up Git global configuration${NC}"
  echo -e "${YELLOW}Please provide the following information:${NC}"

  # Get user input
  read -rp "Full Name: " name
  [ -z "$name" ] && error_exit "Name cannot be empty"

  read -rp "Email Address: " email
  validate_email "$email"

  read -rp "Default Editor (default: vim): " editor
  editor=${editor:-vim}

  read -rp "Default Branch Name (default: main): " branch
  branch=${branch:-main}

  # Show confirmation
  echo -e "\n${YELLOW}About to set the following Git configuration:${NC}"
  echo "Name: $name"
  echo "Email: $email"
  echo "Editor: $editor"
  echo "Default Branch: $branch"
  echo -e "${YELLOW}Is this correct? [y/N]${NC} "
  read -r confirm

  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    # Set the configuration
    git config --global user.name "$name"
    git config --global user.email "$email"
    git config --global core.editor "$editor"
    git config --global init.defaultBranch "$branch"
    
    echo -e "${GREEN}Git configuration successfully set!${NC}"
    echo -e "\nCurrent Git configuration:"
    git config --global --list
  else
    echo -e "${YELLOW}Configuration cancelled${NC}"
  fi
}

# Run the configuration
configure_git
