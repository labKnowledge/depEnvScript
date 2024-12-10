#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Print functions
print_message() { echo -e "${GREEN}[+] $1${NC}"; }
print_warning() { echo -e "${YELLOW}[!] $1${NC}"; }
print_error() { echo -e "${RED}[-] $1${NC}"; }

# Available templates
TEMPLATES=("base" "python" "node" "golang")

# Function to create devcontainer files
create_devcontainer() {
    local template="$1"
    local target_dir="$2"

    # Create .devcontainer directory
    mkdir -p "$target_dir/.devcontainer"

    # Copy template files
    cp "/usr/local/share/devcontainer-templates/$template/Dockerfile" "$target_dir/.devcontainer/"
    cp "/usr/local/share/devcontainer-templates/$template/docker-compose.yml" "$target_dir/.devcontainer/"

    # Create devcontainer.json
    cat > "$target_dir/.devcontainer/devcontainer.json" << EOF
{
    "name": "${template} Development Container",
    "dockerComposeFile": "docker-compose.yml",
    "service": "dev",
    "workspaceFolder": "/workspace",
    "remoteUser": "developer",
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-azuretools.vscode-docker",
                "GitHub.copilot",
                "eamodio.gitlens"
            ]
        }
    }
}
EOF

    # Add template-specific VS Code extensions
    case "$template" in
        "python")
            sed -i 's/"extensions": \[/"extensions": [\n                "ms-python.python",\n                "ms-python.vscode-pylance",\n                "ms-toolsai.jupyter",/' "$target_dir/.devcontainer/devcontainer.json"
            ;;
        "node")
            sed -i 's/"extensions": \[/"extensions": [\n                "dbaeumer.vscode-eslint",\n                "esbenp.prettier-vscode",\n                "ms-vscode.vscode-typescript-next",/' "$target_dir/.devcontainer/devcontainer.json"
            ;;
        "golang")
            sed -i 's/"extensions": \[/"extensions": [\n                "golang.go",\n                "golang.go-nightly",\n                "vadimcn.vscode-lldb",/' "$target_dir/.devcontainer/devcontainer.json"
            ;;
    esac
}

# Main function
main() {
    local template="$1"
    local target_dir="${2:-.}"

    # Validate template
    if [[ ! " ${TEMPLATES[@]} " =~ " ${template} " ]]; then
        print_error "Invalid template. Available templates: ${TEMPLATES[*]}"
        exit 1
    }

    # Create devcontainer
    print_message "Creating $template development container in $target_dir"
    create_devcontainer "$template" "$target_dir"

    # Success message and instructions
    print_message "Development container created successfully!"
    print_warning "To use this development container:"
    echo "1. Open the project in VS Code"
    echo "2. Press F1 and select 'Dev Containers: Reopen in Container'"
    echo "3. Wait for the container to build and start"
}

# Display help
show_help() {
    echo "Usage: setup-devcontainer <template> [target-directory]"
    echo "Available templates: ${TEMPLATES[*]}"
    echo ""
    echo "Examples:"
    echo "  setup-devcontainer python ."
    echo "  setup-devcontainer node my-project"
}

# Parse arguments
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_help
    exit 0
fi

if [ -z "$1" ]; then
    print_error "Template name is required"
    show_help
    exit 1
fi

main "$1" "$2"