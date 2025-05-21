#!/bin/bash

# Create a Python virtual environment using UV in the current directory

set -euo pipefail

DEFAULT_ENV_NAME=".venv"

log() {
  echo "[INFO] $1"
}

error_exit() {
  echo "[ERROR] $1" >&2
  exit 1
}

check_dependencies() {
  if ! command -v uv >/dev/null 2>&1; then
    error_exit "'uv' is not installed or not in PATH. Please install it first."
  fi
}

create_env() {
  local env_name="$1"

  if [ -d "$env_name" ]; then
    error_exit "Directory '$env_name' already exists. Remove it or choose another name."
  fi

  log "Creating UV virtual environment in '$env_name'..."
  uv venv "$env_name" || error_exit "Failed to create environment."

  log "Activating environment and installing pip..."
  source "$env_name/bin/activate"
  python -m ensurepip --upgrade || error_exit "Failed to install pip."

  log "Done. To activate it: source $env_name/bin/activate"
}

main() {
  check_dependencies

  # Allow optional argument for environment directory name
  local env_dir="${1:-$DEFAULT_ENV_NAME}"

  create_env "$env_dir"
}

main "$@"
