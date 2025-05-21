#!/bin/bash

# Fix permissions in ~/.env directory
# Ensures directory is 700 and files are 600
# Logs actions and handles errors gracefully

ENV_DIR="$HOME/.env"
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
    error_exit "Directory $ENV_DIR does not exist."
  fi
}

fix_dir_permissions() {
  chmod 700 "$ENV_DIR" || error_exit "Failed to set permissions on $ENV_DIR"
  log "Set directory permissions to 700"
}

fix_file_permissions() {
  find "$ENV_DIR" -type f | while read -r file; do
    chmod 600 "$file" || error_exit "Failed to set permissions on $file"
    log "Set permissions to 600 for $file"
  done
}

main() {
  check_env_dir
  fix_dir_permissions
  fix_file_permissions
  log "Permission fix complete."
}

main
