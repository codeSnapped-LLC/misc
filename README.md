# Development Environment Setup Tools

This repository contains scripts to configure and maintain a secure development environment.

## Main Installer: `install_misc.sh`

The primary installation script that sets up all configurations.

### Features:
- Installs Zsh configuration files (`.zshrc`, `.zlogout`)
- Sets up secure environment directories (`~/.env`, `~/.secure_env`)
- Downloads and installs utility scripts
- Handles backups of existing files
- Provides detailed logging

### Installation:

Recommended method (with download verification):
```bash
# Try both possible paths since GitHub raw URLs can be inconsistent
curl -sSL https://raw.githubusercontent.com/codeSnapped-LLC/misc/refs/heads/develop/install_misc.sh -o install_misc.sh || \
curl -sSL https://raw.githubusercontent.com/codeSnapped-LLC/misc/refs/heads/develop/scripts/install_misc.sh -o install_misc.sh

chmod +x install_misc.sh && ./install_misc.sh
```

One-line method (less recommended):
```bash
curl -sSL https://raw.githubusercontent.com/codeSnapped-LLC/misc/refs/heads/develop/install_misc.sh | bash -s -- || \
curl -sSL https://raw.githubusercontent.com/codeSnapped-LLC/misc/refs/heads/develop/scripts/install_misc.sh | bash -s --
```

Troubleshooting:
1. Verify the script exists at:
   - https://github.com/codeSnapped-LLC/misc/blob/develop/install_misc.sh
   - https://github.com/codeSnapped-LLC/misc/blob/develop/scripts/install_misc.sh
2. Check your network connection
3. Try cloning the repo instead:
   ```bash
   git clone https://github.com/codeSnapped-LLC/misc.git
   cd misc
   ./install_misc.sh
   ```

If you get 404 errors:
1. Verify the repository exists at the URL
2. Check you have the correct branch name (develop)
3. Ensure the script path is correct

## Utility Scripts

### 1. `create_uv_env.sh`
Creates Python virtual environments using UV.

**Usage:**
```bash
./create_uv_env.sh [env_name]  # Default: .venv
```

**Features:**
- Creates UV virtual environment
- Upgrades pip automatically
- Generates empty `.env` and `requirements.txt` if missing
- Validates UV installation

### 2. `fix_env_permissions.sh`
Secures permissions for environment files.

**Usage:**
```bash
./fix_env_permissions.sh
```

**Features:**
- Sets `~/.env` directory to 700 permissions
- Sets all files in `~/.env` to 600 permissions
- Maintains detailed permission log

### 3. `fix_secure_env_perms.sh`
Specialized permissions for sensitive environment files.

**Usage:**
```bash
./fix_secure_env_perms.sh
```

**Features:**
- Secures `~/.secure_env` directory (700)
- Protects `secrets.sh` file (600)
- Includes existence checks
- Detailed error logging

### 4. `setup_git_config.sh`
Interactive Git configuration setup.

**Usage:**
```bash
./setup_git_config.sh
```

**Features:**
- Guides through global Git setup
- Validates email format
- Provides sensible defaults
- Shows confirmation before applying changes

## Security Features

All scripts include:
- Strict error handling (`set -euo pipefail`)
- Permission validation
- Backup systems for existing files
- Detailed logging
- Input validation where applicable

## Requirements

- Bash 4.0+
- Core utilities (curl, chmod, etc.)
- For UV script: Python and UV installed

## Best Practices

1. Review scripts before running
2. Check logs after installation:
   - Main installer: `~/misc_install.log`
   - Permission scripts: `~/.env/.permissions_log` and `~/.secure_env/.permissions_log`
3. Store sensitive data only in `~/.secure_env/`
