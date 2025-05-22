#!/bin/bash

# Unified permissions fixing script for secure directories and files
# Handles: .ssh, .env, .secure_env directories and their contents

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Set directory permissions (using traditional arrays for compatibility)
SECURE_DIRS=(
    "$HOME/.ssh:700"
    "$HOME/.env:700"
    "$HOME/.secure_env:700"
)

# Set file permissions
SECURE_FILES=(
    "$HOME/.ssh/id_rsa:600"
    "$HOME/.ssh/id_rsa.pub:644"
    "$HOME/.ssh/authorized_keys:600"
    "$HOME/.ssh/config:600"
    "$HOME/.secure_env/secrets.sh:600"
    "$HOME/.secure_env/exports.sh:644"
    "$HOME/.env/.env:600"
)

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

fix_permissions() {
    local errors=0
    
    # Process directories
    # Process directories
    for entry in "${SECURE_DIRS[@]}"; do
        IFS=':' read -r dir perm <<< "$entry"
        if [ ! -d "$dir" ]; then
            log "${YELLOW}Directory $dir does not exist - skipping${NC}"
            continue
        fi
        
        local current_perm
        current_perm=$(stat -f "%A" "$dir" 2>/dev/null || echo "000")
        if [ "$current_perm" != "$perm" ]; then
            log "Setting $dir permissions to $perm"
            if ! chmod "$perm" "$dir"; then
                log "${RED}Failed to set permissions on $dir${NC}"
                ((errors++))
            fi
        fi
    done
    
    # Process files
    for entry in "${SECURE_FILES[@]}"; do
        IFS=':' read -r file perm <<< "$entry"
        if [ ! -f "$file" ]; then
            log "${YELLOW}File $file does not exist - skipping${NC}"
            continue
        fi
        
        local current_perm
        current_perm=$(stat -f "%A" "$file" 2>/dev/null || echo "000")
        if [ "$current_perm" != "$perm" ]; then
            log "Setting $file permissions to $perm"
            if ! chmod "$perm" "$file"; then
                log "${RED}Failed to set permissions on $file${NC}"
                ((errors++))
            fi
        fi
    done
    
    return $errors
}

main() {
    log "Starting permission fixes..."
    
    if fix_permissions; then
        log "${GREEN}All permissions verified and corrected successfully${NC}"
    else
        log "${RED}Completed with some errors (see above)${NC}"
        exit 1
    fi
}

main
