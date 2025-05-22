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
```bash
curl -sSL https://raw.githubusercontent.com/codeSnapped-LLC/misc/develop/scripts/install_misc.sh | bash
```

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
