# Aider Docker Wrapper

This script provides a convenient way to run Aider using Docker. Follow the steps below to set it up and use it effectively.

## Setup Instructions

1. **Place the Script:**
   - Move the `aider.sh` script to a directory in your home, such as `$HOME/scripts/`.

2. **Add to PATH:**
   - Edit your shell configuration file (`.bashrc` or `.zshrc`) to include the scripts directory in your PATH. Add the following line:
     ```bash
     export PATH="$HOME/scripts:$PATH"
     ```
   - Reload your shell configuration:
     - For Bash: `source ~/.bashrc`
     - For Zsh: `source ~/.zshrc`

3. **Environment Configuration:**
   - Copy the `.env.example` file to `$HOME/.aider/.env` and fill in the necessary API keys and configuration details.

## Usage

- Run the script using the command:
  ```bash
  aider.sh
  ```

- Follow the on-screen menu to select the desired option for running Aider with different models and configurations.

## More Information

For more details about Aider, visit the official page: [aider.chat](https://aider.chat)
