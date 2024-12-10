#!/bin/bash

# ==============================================
# Development Environment Configuration
# ==============================================

# System Configuration
SYSTEM_CONFIG=(
    "PERFORM_SYSTEM_UPDATE=true"              # Whether to run system update before installation
    "INSTALL_BUILD_ESSENTIAL=true"            # Install build-essential package
    "CLEANUP_AFTER_INSTALL=true"              # Clean up downloaded files after installation
    "CREATE_BACKUP=true"                      # Backup existing configurations
)

# User Information
USER_CONFIG=(
    "GIT_USER_NAME=''"                        # Git global user.name
    "GIT_USER_EMAIL=''"                       # Git global user.email
    "GITHUB_USERNAME=''"                      # GitHub username for configurations
)

# Docker Configuration
DOCKER_CONFIG=(
    "INSTALL_DOCKER=true"                     # Whether to install Docker
    "INSTALL_DOCKER_COMPOSE=true"             # Whether to install Docker Compose
    "DOCKER_COMPOSE_VERSION=latest"           # Docker Compose version
    "DOCKER_BUILDKIT=1"                       # Enable Docker BuildKit
    "DOCKER_USER_GROUP=true"                  # Add user to docker group
)

# Node.js Configuration
NODE_CONFIG=(
    "INSTALL_NODE=true"                       # Whether to install Node.js
    "NODE_VERSION=lts"                        # Node.js version (lts, latest, or specific version)
    "INSTALL_YARN=true"                       # Install Yarn package manager
    "INSTALL_TYPESCRIPT=true"                 # Install TypeScript
    "NPM_GLOBAL_PACKAGES=(                    # Global NPM packages to install
        typescript
        ts-node
        @angular/cli
        create-react-app
        next
    )"
)

# Python Configuration
PYTHON_CONFIG=(
    "INSTALL_PYTHON=true"                     # Whether to install Python
    "PYTHON_VERSION=3.11"                     # Python version
    "CREATE_VIRTUALENV=true"                  # Create a default virtual environment
    "INSTALL_POETRY=true"                     # Install Poetry
    "PYTHON_PACKAGES=(                        # Python packages to install
        pipenv
        poetry
        jupyter
        notebook
        pandas
        numpy
        scipy
        scikit-learn
        matplotlib
    )"
)

# AI/ML Tools Configuration
AI_CONFIG=(
    "INSTALL_CUDA=auto"                       # Install CUDA (auto, true, false)
    "CUDA_VERSION=12.3"                       # CUDA version
    "INSTALL_CUDNN=true"                      # Install cuDNN
    "INSTALL_OLLAMA=true"                     # Install Ollama
    "INSTALL_HF_CLI=true"                     # Install Hugging Face CLI
)

# VSCode Configuration
VSCODE_CONFIG=(
    "INSTALL_VSCODE=true"                     # Whether to install VSCode
    "VSCODE_SYNC_SETTINGS=false"              # Sync VSCode settings
    "VSCODE_EXTENSIONS=(                      # VSCode extensions to install
        ms-python.python
        ms-toolsai.jupyter
        ms-azuretools.vscode-docker
        GitHub.copilot
        ms-vscode.cpptools
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        ms-python.vscode-pylance
        eamodio.gitlens
        mhutchie.git-graph
    )"
)

# Browser Configuration
BROWSER_CONFIG=(
    "INSTALL_CHROME=true"                     # Install Google Chrome
    "INSTALL_BRAVE=true"                      # Install Brave Browser
)

# Development Tools Configuration
DEV_TOOLS_CONFIG=(
    "INSTALL_GIT=true"                        # Install Git
    "INSTALL_CURL=true"                       # Install curl
    "INSTALL_WGET=true"                       # Install wget
    "INSTALL_TMUX=true"                       # Install tmux
    "INSTALL_ZSH=true"                        # Install Zsh
    "INSTALL_OH_MY_ZSH=true"                  # Install Oh My Zsh
)

# Path Configuration
PATH_CONFIG=(
    "WORKSPACE_DIR=$HOME/workspace"           # Default workspace directory
    "BACKUP_DIR=$HOME/.dev-env-backup"        # Backup directory
    "LOG_DIR=$HOME/.dev-env-logs"             # Log directory
)

# ==============================================
# Helper Functions
# ==============================================

# Function to load configuration from file
load_config() {
    local config_file="$1"
    if [ -f "$config_file" ]; then
        source "$config_file"
        echo "Configuration loaded from $config_file"
    fi
}

# Function to save configuration to file
save_config() {
    local config_file="$1"
    
    # Create config directory if it doesn't exist
    mkdir -p "$(dirname "$config_file")"
    
    # Save all configuration arrays to file
    {
        echo "# System Configuration"
        printf '%s\n' "${SYSTEM_CONFIG[@]}"
        echo ""
        echo "# User Configuration"
        printf '%s\n' "${USER_CONFIG[@]}"
        echo ""
        echo "# Docker Configuration"
        printf '%s\n' "${DOCKER_CONFIG[@]}"
        echo ""
        echo "# Node.js Configuration"
        printf '%s\n' "${NODE_CONFIG[@]}"
        echo ""
        echo "# Python Configuration"
        printf '%s\n' "${PYTHON_CONFIG[@]}"
        echo ""
        echo "# AI/ML Tools Configuration"
        printf '%s\n' "${AI_CONFIG[@]}"
        echo ""
        echo "# VSCode Configuration"
        printf '%s\n' "${VSCODE_CONFIG[@]}"
        echo ""
        echo "# Browser Configuration"
        printf '%s\n' "${BROWSER_CONFIG[@]}"
        echo ""
        echo "# Development Tools Configuration"
        printf '%s\n' "${DEV_TOOLS_CONFIG[@]}"
        echo ""
        echo "# Path Configuration"
        printf '%s\n' "${PATH_CONFIG[@]}"
    } > "$config_file"
    
    echo "Configuration saved to $config_file"
}

# Function to get configuration value
get_config() {
    local key="$1"
    local default_value="$2"
    
    # Try to find the key in all configuration arrays
    local value=""
    local config_arrays=(
        SYSTEM_CONFIG[@] USER_CONFIG[@] DOCKER_CONFIG[@]
        NODE_CONFIG[@] PYTHON_CONFIG[@] AI_CONFIG[@]
        VSCODE_CONFIG[@] BROWSER_CONFIG[@] DEV_TOOLS_CONFIG[@]
        PATH_CONFIG[@]
    )
    
    for array in "${config_arrays[@]}"; do
        local eval_array=("\${!$array}")
        for item in "${eval_array[@]}"; do
            if [[ "$item" == "$key="* ]]; then
                value="${item#*=}"
                break 2
            fi
        done
    done
    
    # Return the value or default
    echo "${value:-$default_value}"
}

# Function to set configuration value
set_config() {
    local key="$1"
    local value="$2"
    local found=false
    
    # Try to find and update the key in all configuration arrays
    local config_arrays=(
        SYSTEM_CONFIG[@] USER_CONFIG[@] DOCKER_CONFIG[@]
        NODE_CONFIG[@] PYTHON_CONFIG[@] AI_CONFIG[@]
        VSCODE_CONFIG[@] BROWSER_CONFIG[@] DEV_TOOLS_CONFIG[@]
        PATH_CONFIG[@]
    )
    
    for array in "${config_arrays[@]}"; do
        local eval_array=("\${!$array}")
        for i in "${!eval_array[@]}"; do
            if [[ "${eval_array[$i]}" == "$key="* ]]; then
                eval "$array[$i]=\"$key=$value\""
                found=true
                break 2
            fi
        done
    done
    
    if ! $found; then
        echo "Configuration key '$key' not found"
        return 1
    fi
}

# Function to validate configuration
validate_config() {
    local errors=0
    
    # Check required configurations
    if [ -z "$(get_config GIT_USER_NAME)" ]; then
        echo "Warning: GIT_USER_NAME is not set"
        ((errors++))
    fi
    
    if [ -z "$(get_config GIT_USER_EMAIL)" ]; then
        echo "Warning: GIT_USER_EMAIL is not set"
        ((errors++))
    fi
    
    # Validate Python version format
    local python_version="$(get_config PYTHON_VERSION)"
    if ! [[ "$python_version" =~ ^[0-9]+\.[0-9]+$ ]]; then
        echo "Error: Invalid Python version format: $python_version"
        ((errors++))
    fi
    
    # Return number of errors
    return $errors
}

# Export configuration to environment variables
export_config() {
    # Export all configuration values as environment variables
    local config_arrays=(
        SYSTEM_CONFIG[@] USER_CONFIG[@] DOCKER_CONFIG[@]
        NODE_CONFIG[@] PYTHON_CONFIG[@] AI_CONFIG[@]
        VSCODE_CONFIG[@] BROWSER_CONFIG[@] DEV_TOOLS_CONFIG[@]
        PATH_CONFIG[@]
    )
    
    for array in "${config_arrays[@]}"; do
        local eval_array=("\${!$array}")
        for item in "${eval_array[@]}"; do
            local key="${item%%=*}"
            local value="${item#*=}"
            export "$key=$value"
        done
    done
}

# Main function to handle configuration
main() {
    local config_file="$HOME/.config/dev-env/config.sh"
    
    # Load existing configuration if available
    load_config "$config_file"
    
    # Validate configuration
    validate_config
    
    # Export configuration to environment
    export_config
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi