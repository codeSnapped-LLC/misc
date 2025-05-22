#!/bin/bash

# Unified permissions fixing script for secure directories and files
# Handles: .ssh, .env, .secure_env directories and their contents

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Initialize arrays
declare -A SECURE_DIRS
declare -A SECURE_FILES

# Set directory permissions
SECURE_DIRS["$HOME/.ssh"]="700"
SECURE_DIRS["$HOME/.env"]="700"
SECURE_DIRS["$HOME/.secure_env"]="700"

# Set file permissions
SECURE_FILES["$HOME/.ssh/id_rsa"]="600"
SECURE_FILES["$HOME/.ssh/id_rsa.pub"]="644"
SECURE_FILES["$HOME/.ssh/authorized_keys"]="600"
SECURE_FILES["$HOME/.ssh/config"]="600"
SECURE_FILES["$HOME/.secure_env/secrets.sh"]="600"
SECURE_FILES["$HOME/.secure_env/exports.sh"]="644"
SECURE_FILES["$HOME/.env/.env"]="600"

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

fix_permissions() {
    local errors=0
    
    # Process directories
    # Process directories
    for dir in "${!SECURE_DIRS[@]}"; do
        dir="${dir}"  # Handle quoting properly
        if [ ! -d "$dir" ]; then
            log "${YELLOW}Directory $dir does not exist - skipping${NC}"
            continue
        fi
        
        local perm="${SECURE_DIRS[$dir]}"
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
    for file in "${!SECURE_FILES[@]}"; do
        file="${file}"  # Handle quoting properly
        if [ ! -f "$file" ]; then
            log "${YELLOW}File $file does not exist - skipping${NC}"
            continue
        fi
        
        local perm="${SECURE_FILES[$file]}"
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
