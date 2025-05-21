#!/bin/bash

# Initializes a directory and shell config for sensitive env vars

set -euo pipefail

ENV_DIR="$HOME/.secure_env"
ENV_FILE="$ENV_DIR/secrets.sh"
ZSHRC="$HOME/.zshrc"
BLOCK_START="# >>> secure env loader >>>"
BLOCK_END="# <<< secure env loader <<<"

log() {
  echo "[INFO] $1"
}

error_exit() {
  echo "[ERROR] $1" >&2
  exit 1
}

create_env_dir() {
  mkdir -p "$ENV_DIR"
  chmod 700 "$ENV_DIR"
  touch "$ENV_FILE"
  chmod 600 "$ENV_FILE"
  log "Created $ENV_FILE with secure permissions."
}

add_zshrc_block() {
  if grep -q "$BLOCK_START" "$ZSHRC"; then
    log "secure_env block already exists in .zshrc — skipping."
    return
  fi

  cat <<EOF >> "$ZSHRC"

$BLOCK_START
# Source sensitive environment variables if the file exists
[ -f "$ENV_FILE" ] && source "$ENV_FILE"
$BLOCK_END
EOF

  log "Added secure_env sourcing block to .zshrc"
}

main() {
  create_env_dir
  add_zshrc_block
  log "Initialization complete. Add secrets to $ENV_FILE"
}

main
