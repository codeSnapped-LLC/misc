#!/bin/bash

# Fixes permissions on ~/.secure_env and its contents

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

check_and_fix() {
  if [ ! -d "$ENV_DIR" ]; then
    error_exit "$ENV_DIR does not exist"
  fi

  chmod 700 "$ENV_DIR" || error_exit "Failed to set dir permissions"
  log "Set permissions on $ENV_DIR to 700"

  if [ -f "$ENV_FILE" ]; then
    chmod 600 "$ENV_FILE" || error_exit "Failed to set file permissions"
    log "Set permissions on $ENV_FILE to 600"
  else
    log "$ENV_FILE not found, skipping file perms"
  fi
}

main() {
  check_and_fix
  log "Permission check complete"
}

main

