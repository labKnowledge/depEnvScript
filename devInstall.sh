#!/bin/bash

# Colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_message() {
    echo -e "${GREEN}[+] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

print_error() {
    echo -e "${RED}[-] $1${NC}"
}

# Function to check if a command was successful
check_status() {
    if [ $? -eq 0 ]; then
        print_message "$1 successfully installed"
    else
        print_error "Failed to install $1"
        exit 1
    fi
}

# Function to install basic development tools
install_basic_tools() {
    print_message "Installing basic development tools..."
    
    # Update package list
    sudo apt update
    sudo apt upgrade -y
    
    # Install basic development packages
    sudo apt install -y \
        build-essential \
        git \
        curl \
        wget \
        unzip \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release
    
    check_status "Basic tools"
}

# Function to install Docker
install_docker() {
    print_message "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl start docker
    check_status "Docker"
    
    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    check_status "Docker Compose"
}

# Function to install Node.js and related tools
install_node() {
    print_message "Installing Node.js and related tools..."
    
    # Install NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    
    # Install latest LTS version of Node.js
    nvm install --lts
    nvm use --lts
    
    # Install global NPM packages
    npm install -g yarn typescript ts-node
    
    check_status "Node.js and related tools"
}

# Function to install Python development environment
install_python() {
    print_message "Installing Python development environment..."
    
    sudo apt install -y python3-pip python3-venv
    
    # Install some common Python packages
    pip3 install --user pipenv poetry jupyter notebook pandas numpy scipy scikit-learn matplotlib
    
    check_status "Python development environment"
}

# Function to install AI/ML tools
install_ai_tools() {
    print_message "Installing AI/ML tools..."
    
    # Install CUDA and cuDNN (if NVIDIA GPU is present)
    if lspci | grep -i nvidia > /dev/null; then
        print_message "NVIDIA GPU detected. Installing CUDA..."
        wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
        sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
        wget https://developer.download.nvidia.com/compute/cuda/12.3.1/local_installers/cuda-repo-ubuntu2204-12-3-local_12.3.1-545.23.08-1_amd64.deb
        sudo dpkg -i cuda-repo-ubuntu2204-12-3-local_12.3.1-545.23.08-1_amd64.deb
        sudo cp /var/cuda-repo-ubuntu2204-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
        sudo apt-get update
        sudo apt-get -y install cuda-toolkit-12-3
    fi

    # Install cuDNN (assuming CUDA is already installed)
    if [ -d "/usr/local/cuda" ]; then
        print_message "Installing cuDNN..."
        wget https://developer.download.nvidia.com/compute/cudnn/9.6.0/local_installers/cudnn-local-repo-ubuntu2204-9.6.0_1.0-1_amd64.deb
        sudo dpkg -i cudnn-local-repo-ubuntu2204-9.6.0_1.0-1_amd64.deb
        sudo cp /var/cudnn-local-repo-ubuntu2204-9.6.0/cudnn-*-keyring.gpg /usr/share/keyrings/
        sudo apt-get update
        sudo apt-get -y install cudnn
        sudo apt-get -y install cudnn-cuda-12
    fi
    
    # Install Ollama
    curl -fsSL https://ollama.com/install.sh | sh
    check_status "Ollama"
    
    # Install Hugging Face CLI
    pip3 install --user "huggingface_hub[cli]"
    check_status "Hugging Face CLI"
}

# Function to install VSCode
install_vscode() {
    print_message "Installing Visual Studio Code..."
    
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    
    sudo apt update
    sudo apt install -y code
    
    # Install some useful VSCode extensions
    code --install-extension ms-python.python
    code --install-extension ms-toolsai.jupyter
    code --install-extension ms-azuretools.vscode-docker
    code --install-extension GitHub.copilot
    code --install-extension ms-vscode.cpptools
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension esbenp.prettier-vscode
    code --install-extension esbenp.prettier-vscode
    code --install-extension ms-python.vscode-pylance
    code --install-extension eamodio.gitlens
    code --install-extension mhutchie.git-graph
    
    check_status "Visual Studio Code and extensions"
}

# Function to install browsers
install_browsers() {
    print_message "Installing browsers..."
    
    # Install Chrome
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo apt -f install -y
    rm google-chrome-stable_current_amd64.deb
    
    # Install Brave
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
    
    check_status "Browsers"
}

# Main installation menu
main_menu() {
    echo "Ubuntu 22.04 Development Environment Setup"
    echo "----------------------------------------"
    echo "1) Automatic Installation (All components)"
    echo "2) Minimal Installation (Basic tools, Git, Docker)"
    echo "3) Manual Installation (Choose components)"
    echo "4) Exit"
    
    read -p "Please select an option [1-4]: " choice
    
    case $choice in
        "full"|"1")
            install_basic_tools
            install_docker
            install_node
            install_python
            install_ai_tools
            install_vscode
            install_browsers
            ;;
         "minimal"|"2")
            install_basic_tools
            install_docker
            ;;
         "manual"|"3")
            manual_installation
            ;;
        4)
            exit 0
            ;;
        *)
            print_error "Invalid option"
            main_menu
            ;;
    esac
}

# Function for manual installation
manual_installation() {
    echo "Select components to install (y/n for each):"
    
    read -p "Install basic development tools? [y/n]: " basic
    if [[ $basic == "y" ]]; then
        install_basic_tools
    fi
    
    read -p "Install Docker? [y/n]: " docker
    if [[ $docker == "y" ]]; then
        install_docker
    fi
    
    read -p "Install Node.js and related tools? [y/n]: " node
    if [[ $node == "y" ]]; then
        install_node
    fi
    
    read -p "Install Python development environment? [y/n]: " python
    if [[ $python == "y" ]]; then
        install_python
    fi
    
    read -p "Install AI/ML tools? [y/n]: " ai
    if [[ $ai == "y" ]]; then
        install_ai_tools
    fi
    
    read -p "Install Visual Studio Code? [y/n]: " vscode
    if [[ $vscode == "y" ]]; then
        install_vscode
    fi
    
    read -p "Install browsers? [y/n]: " browsers
    if [[ $browsers == "y" ]]; then
        install_browsers
    fi
}

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Please do not run this script as root"
    exit 1
fi

# Start installation
main_menu

print_message "Installation complete!"
print_warning "Please log out and log back in for some changes to take effect."