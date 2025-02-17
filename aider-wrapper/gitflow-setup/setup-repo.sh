#!/bin/bash
set -e

REPO_URL=$1
REPO_NAME=$(basename $REPO_URL .git)

if [ -z "$REPO_URL" ]; then
    echo "Usage: $0 <git-ssh-url>"
    exit 1
fi

# Clone repository
git clone $REPO_URL
cd $REPO_NAME

# Initialize git flow with defaults
git flow init -d

# Create gitversion config
cat > gitversion.yml <<EOL
mode: Mainline
branches:
  main:
    mode: Mainline
  develop:
    mode: Mainline
    tracks-release-branches: true
    regex: ^develop$
EOL

# Initial commit
git add gitversion.yml
git commit -m "Initialize repository with gitflow and gitversion"
git push --all
git push --tags

echo "Repository setup complete in $REPO_NAME"
echo "Read gitflow-readme.md for usage instructions"
