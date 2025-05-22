#!/bin/bash

# Fixes permissions on ~/.secure_env and its contents
# Ensures directory is 700 and files are 600
# Logs actions and handles errors gracefully

set -euo pipefail

ENV_DIR="$HOME/.secure_env"
ENV_FILE="$ENV_DIR/secrets.sh"
LOG_FILE="$ENV_DIR/.permissions_log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

error_exit() {
  log "ERROR: $1"
  exit 1
}

check_env_dir() {
  if [ ! -d "$ENV_DIR" ]; then
    error_exit "Secure env directory $ENV_DIR does not exist. Run install_misc.sh first."
  fi
}

fix_dir_permissions() {
  chmod 700 "$ENV_DIR" || error_exit "Failed to set permissions on $ENV_DIR"
  log "Set directory permissions to 700"
}

fix_file_permissions() {
  if [ -f "$ENV_FILE" ]; then
    chmod 600 "$ENV_FILE" || error_exit "Failed to set permissions on $ENV_FILE"
    log "Set permissions to 600 for $ENV_FILE"
  else
    log "No secrets file found at $ENV_FILE - skipping"
  fi
}

main() {
  check_env_dir
  fix_dir_permissions
  fix_file_permissions
  log "Secure env permission fix complete"
}

main

