#!/bin/bash

# Installation script for codeSnapped-LLC/misc configs and scripts
# Can be run with: curl -sSL https://raw.githubusercontent.com/codeSnapped-LLC/misc/develop/scripts/install_misc.sh | bash

set -euo pipefail

# Constants
REPO_URL="https://raw.githubusercontent.com/codeSnapped-LLC/misc/develop"
TEMP_DIR=$(mktemp -d)
LOG_FILE="$HOME/misc_install.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log() {
  echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

success() {
  echo -e "${GREEN}$1${NC}" | tee -a "$LOG_FILE"
}

warn() {
  echo -e "${YELLOW}$1${NC}" | tee -a "$LOG_FILE"
}

error() {
  echo -e "${RED}$1${NC}" | tee -a "$LOG_FILE"
}

error_exit() {
  error "$1"
  exit 1
}

# Cleanup function
cleanup() {
  if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
  fi
}

# Register cleanup on exit
trap cleanup EXIT

# Check dependencies
check_dependencies() {
  if ! command -v curl >/dev/null 2>&1; then
    error_exit "curl is required but not installed. Please install curl first."
  fi
}

# Backup existing file if it exists
backup_file() {
  local file="$1"
  if [ -f "$file" ]; then
    local backup="${file}.bak.$(date +%Y%m%d%H%M%S)"
    cp "$file" "$backup"
    log "Backed up $file to $backup"
  fi
}

# Download file from repo
download_file() {
  local src="$1"
  local dest="$2"
  local url="${REPO_URL}/${src}"
  
  log "Downloading $url to $dest"
  
  # Check if file exists before downloading
  if ! curl -sSL -f "$url" -o "$dest"; then
    error_exit "Failed to download $url - file not found or network error"
  fi
  
  # Verify the downloaded file isn't an HTML error page
  if [[ -f "$dest" ]] && grep -q "<html" "$dest"; then
    rm -f "$dest"
    error_exit "Downloaded file appears to be an HTML error page - check URL"
  fi
}

# Create directory with secure permissions
create_secure_dir() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    chmod 700 "$dir"
    log "Created directory $dir with permissions 700"
  fi
}

# Install zsh config files
install_zsh_configs() {
  local zsh_dir="$HOME"
  
  # Backup existing files
  backup_file "$zsh_dir/.zshrc"
  backup_file "$zsh_dir/.zlogout"
  
  # Download new files
  download_file "zshc/.zshrc" "$zsh_dir/.zshrc"
  download_file "zshc/.zlogout" "$zsh_dir/.zlogout"
  
  chmod 644 "$zsh_dir/.zshrc"
  chmod 644 "$zsh_dir/.zlogout"
  
  success "Installed zsh config files"
}

# Install scripts
install_scripts() {
  local scripts_dir="$HOME/scripts"
  create_secure_dir "$scripts_dir"
  
  # List of scripts to install
  local scripts=(
    "scripts/fix_env_permissions.sh"
    "scripts/fix_secure_env_perms.sh"
    "scripts/create_uv_env.sh"
    "scripts/init_secure_env.sh"
  )
  
  for script in "${scripts[@]}"; do
    local script_name=$(basename "$script")
    download_file "$script" "$scripts_dir/$script_name"
    chmod 750 "$scripts_dir/$script_name"
    log "Installed script $script_name"
  done
  
  success "Installed scripts to $scripts_dir"
}

# Initialize secure env directory and config
init_secure_env() {
  local env_dir="$HOME/.secure_env"
  local env_file="$env_dir/secrets.sh"
  local zshrc="$HOME/.zshrc"
  local block_start="# >>> secure env loader >>>"
  local block_end="# <<< secure env loader <<<"

  create_secure_dir "$env_dir"
  
  # Create secrets file with instructions
  if [ ! -f "$env_file" ]; then
    cat <<EOF > "$env_file"
#!/bin/bash

# Add your sensitive environment variables here
# Example:
# export API_KEY="your-secret-key"
# export DB_PASSWORD="your-db-password"

# Note: This file has strict permissions (600)
# Only edit this file directly, don't move or copy it
EOF
    chmod 600 "$env_file"
    log "Created $env_file with secure permissions and instructions"
  fi

  # Add sourcing block to .zshrc if not present
  if ! grep -q "$block_start" "$zshrc"; then
    cat <<EOF >> "$zshrc"

$block_start
# Source sensitive environment variables if the file exists
[ -f "$env_file" ] && source "$env_file"
$block_end
EOF
    log "Added secure_env sourcing block to .zshrc"
  else
    log "secure_env block already exists in .zshrc - skipping"
  fi
}

# Create secure env directories
create_env_dirs() {
  create_secure_dir "$HOME/.env"
  init_secure_env
  
  success "Created and configured secure environment directories"
}

# Main installation function
main() {
  log "Starting misc installation"
  check_dependencies
  
  install_zsh_configs
  install_scripts
  create_env_dirs
  
  success "Installation completed successfully!"
  log "Details logged to $LOG_FILE"
  
  echo -e "\n${GREEN}Next steps:${NC}"
  echo "1. Review the installed files"
  echo "2. Restart your shell or run: source ~/.zshrc"
  echo "3. Check the log file for details: $LOG_FILE"
}

main "$@"
