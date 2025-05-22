#!/bin/bash

# Fixes permissions on ~/.secure_env and its contents
# Ensures proper permissions for secure environment files:
# - Directory: 700
# - secrets.sh: 600 (sensitive credentials)
# - exports.sh: 644 (non-sensitive environment vars)
# Logs actions and handles errors gracefully

set -euo pipefail

ENV_DIR="$HOME/.secure_env"
SECRETS_FILE="$ENV_DIR/secrets.sh"
EXPORTS_FILE="$ENV_DIR/exports.sh"
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
  # Handle secrets.sh (sensitive - 600)
  if [ -f "$SECRETS_FILE" ]; then
    chmod 600 "$SECRETS_FILE" || error_exit "Failed to set permissions on $SECRETS_FILE"
    log "Set permissions to 600 for $SECRETS_FILE"
  else
    log "No secrets file found at $SECRETS_FILE - skipping"
  fi

  # Handle exports.sh (non-sensitive - 644) 
  if [ -f "$EXPORTS_FILE" ]; then
    chmod 644 "$EXPORTS_FILE" || error_exit "Failed to set permissions on $EXPORTS_FILE"
    log "Set permissions to 644 for $EXPORTS_FILE"
  else
    log "No exports file found at $EXPORTS_FILE - skipping"
  fi
}

verify_permissions() {
  local incorrect=0
  
  # Verify directory permissions
  if [ "$(stat -c %a "$ENV_DIR")" != "700" ]; then
    log "WARNING: Incorrect directory permissions on $ENV_DIR"
    incorrect=1
  fi

  # Verify secrets.sh permissions if exists
  if [ -f "$SECRETS_FILE" ] && [ "$(stat -c %a "$SECRETS_FILE")" != "600" ]; then
    log "WARNING: Incorrect permissions on $SECRETS_FILE (should be 600)"
    incorrect=1
  fi

  # Verify exports.sh permissions if exists
  if [ -f "$EXPORTS_FILE" ] && [ "$(stat -c %a "$EXPORTS_FILE")" != "644" ]; then
    log "WARNING: Incorrect permissions on $EXPORTS_FILE (should be 644)"
    incorrect=1
  fi

  return $incorrect
}

main() {
  check_env_dir
  fix_dir_permissions
  fix_file_permissions
  
  if verify_permissions; then
    log "Secure env permissions verified and correct"
  else
    log "Secure env permission fix complete (with some warnings)"
  fi
}

main

