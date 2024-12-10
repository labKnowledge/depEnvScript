#!/bin/bash

# Source configuration
source "config.sh"

# Example of checking configuration before installation
install_components() {
    # Check if system update is enabled
    if [ "$(get_config PERFORM_SYSTEM_UPDATE)" = "true" ]; then
        print_message "Performing system update..."
        sudo apt update && sudo apt upgrade -y
    fi

    # Install Docker if enabled
    if [ "$(get_config INSTALL_DOCKER)" = "true" ]; then
        install_docker
        
        # Add user to docker group if configured
        if [ "$(get_config DOCKER_USER_GROUP)" = "true" ]; then
            sudo usermod -aG docker "$USER"
        fi
    fi

    # Install Node.js if enabled
    if [ "$(get_config INSTALL_NODE)" = "true" ]; then
        install_node "$(get_config NODE_VERSION)"
        
        # Install global NPM packages
        if [ "$(get_config INSTALL_TYPESCRIPT)" = "true" ]; then
            npm install -g typescript
        fi
    fi

    # Install Python if enabled
    if [ "$(get_config INSTALL_PYTHON)" = "true" ]; then
        install_python "$(get_config PYTHON_VERSION)"
        
        # Install Python packages
        if [ -n "$(get_config PYTHON_PACKAGES)" ]; then
            pip3 install --user "${PYTHON_PACKAGES[@]}"
        fi
    fi
}

# Example of saving custom configuration
save_custom_config() {
    # Set custom values
    set_config "GIT_USER_NAME" "John Doe"
    set_config "GIT_USER_EMAIL" "john@example.com"
    set_config "INSTALL_DOCKER" "true"
    set_config "NODE_VERSION" "18"
    
    # Save to file
    save_config "$HOME/.config/dev-env/config.sh"
}