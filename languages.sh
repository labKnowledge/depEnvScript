#!/bin/bash

# PHP Development Environment
install_php() {
    print_message "Installing PHP development environment..."
    
    # Add PHP repository
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt update
    
    # Install PHP and common extensions
    sudo apt install -y php8.2 php8.2-cli php8.2-common php8.2-curl \
        php8.2-mbstring php8.2-mysql php8.2-xml php8.2-zip php8.2-bcmath \
        php8.2-gd php8.2-intl php8.2-sqlite3
    
    # Install Composer
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
    
    # Install Laravel CLI
    composer global require laravel/installer
    echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc
    
    check_status "PHP development environment"
}

# .NET Development Environment
install_dotnet() {
    print_message "Installing .NET development environment..."
    
    # Install Microsoft package repository and GPG key
    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    
    # Install .NET SDK
    sudo apt update
    sudo apt install -y dotnet-sdk-8.0
    
    # Install Entity Framework tools
    dotnet tool install --global dotnet-ef
    
    # Add .NET tools to PATH
    echo 'export PATH="$PATH:$HOME/.dotnet/tools"' >> ~/.bashrc
    
    check_status ".NET development environment"
}

# C/C++ Development Environment
install_cpp() {
    print_message "Installing C/C++ development environment..."
    
    # Install GCC, G++, and build tools
    sudo apt install -y gcc g++ gdb make cmake ninja-build
    
    # Install Boost libraries
    sudo apt install -y libboost-all-dev
    
    # Install Conan package manager
    pip3 install conan
    
    # Install LLVM and Clang
    sudo apt install -y llvm clang clang-format clangd
    
    # Install vcpkg
    git clone https://github.com/Microsoft/vcpkg.git ~/.vcpkg
    ~/.vcpkg/bootstrap-vcpkg.sh
    echo 'export PATH="$PATH:$HOME/.vcpkg"' >> ~/.bashrc
    
    check_status "C/C++ development environment"
}

# Kotlin Development Environment
install_kotlin() {
    print_message "Installing Kotlin development environment..."
    
    # Install SDKMAN if not already installed
    if [ ! -d "$HOME/.sdkman" ]; then
        curl -s "https://get.sdkman.io" | bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    fi
    
    # Install Kotlin
    sdk install kotlin
    
    # Install Gradle if not already installed
    if ! command -v gradle &> /dev/null; then
        sdk install gradle
    fi
    
    # Install IntelliJ IDEA Community Edition
    sudo snap install intellij-idea-community --classic
    
    check_status "Kotlin development environment"
}

# Swift Development Environment
install_swift() {
    print_message "Installing Swift development environment..."
    
    # Install Swift dependencies
    sudo apt install -y \
        binutils \
        git \
        gnupg2 \
        libc6-dev \
        libcurl4-openssl-dev \
        libedit2 \
        libgcc-9-dev \
        libpython3.8 \
        libsqlite3-0 \
        libstdc++-9-dev \
        libxml2-dev \
        libz3-dev \
        pkg-config \
        tzdata \
        unzip \
        zlib1g-dev
    
    # Download and install Swift
    SWIFT_VERSION="5.9.2"
    wget https://download.swift.org/swift-${SWIFT_VERSION}-release/ubuntu2204/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu22.04.tar.gz
    sudo tar xzf swift-${SWIFT_VERSION}-RELEASE-ubuntu22.04.tar.gz -C /usr/local
    rm swift-${SWIFT_VERSION}-RELEASE-ubuntu22.04.tar.gz
    
    # Add Swift to PATH
    echo 'export PATH="/usr/local/swift-${SWIFT_VERSION}-RELEASE-ubuntu22.04/usr/bin:$PATH"' >> ~/.bashrc
    
    check_status "Swift development environment"
}

# Enhanced Golang installation with more tools
install_golang() {
    print_message "Installing Go development environment..."
    
    # Install Go
    GO_VERSION="1.22.0"
    wget "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
    rm "go${GO_VERSION}.linux-amd64.tar.gz"
    
    # Add to PATH
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
    
    # Source the updated PATH
    source ~/.bashrc
    
    # Install common Go tools
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    go install github.com/fatih/gomodifytags@latest
    go install github.com/cweill/gotests/gotests@latest
    go install github.com/josharian/impl@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install golang.org/x/tools/cmd/gorename@latest
    go install golang.org/x/tools/cmd/guru@latest
    
    check_status "Go development environment"
}

# Enhanced Rust installation with additional tools
install_rust() {
    print_message "Installing Rust development environment..."
    
    # Install Rust using rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    
    # Install common Rust tools
    rustup component add rustfmt
    rustup component add clippy
    rustup component add rust-analyzer
    rustup component add rust-src
    
    # Install additional cargo tools
    cargo install cargo-edit    # adds additional cargo commands
    cargo install cargo-watch   # watches for changes
    cargo install cargo-expand  # shows expanded macros
    cargo install cargo-audit   # checks for security vulnerabilities
    cargo install cargo-tarpaulin # code coverage reporting
    cargo install cargo-outdated # checks for outdated dependencies
    cargo install tokei        # code statistics
    
    check_status "Rust development environment"
}

# Enhanced Java installation
install_java() {
    print_message "Installing Java development environment..."
    
    # Install SDKMAN if not already installed
    if [ ! -d "$HOME/.sdkman" ]; then
        curl -s "https://get.sdkman.io" | bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    fi
    
    # Install Java versions
    sdk install java 17.0.9-tem     # Latest LTS version
    sdk install java 21.0.1-tem     # Latest version
    
    # Set Java 17 as default
    sdk default java 17.0.9-tem
    
    # Install build tools
    sdk install maven
    sdk install gradle
    
    # Install Spring Boot
    sdk install springboot
    
    # Install Micronaut
    sdk install micronaut
    
    # Install Quarkus CLI
    curl -Ls https://sh.jbang.dev | bash -s - trust add https://repo1.maven.org/maven2/io/quarkus/quarkus-cli/
    curl -Ls https://sh.jbang.dev | bash -s - app install --fresh --force quarkus@quarkusio
    
    check_status "Java development environment"
}

# Enhanced Ruby installation
install_ruby() {
    print_message "Installing Ruby development environment..."
    
    # Install RVM
    gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    
    # Install Ruby
    rvm install 3.2.0
    rvm use 3.2.0 --default
    
    # Install common gems
    gem install bundler           # package management
    gem install rails            # web framework
    gem install rspec            # testing framework
    gem install rubocop          # linter
    gem install pry              # debugging
    gem install solargraph       # language server
    gem install rake             # build tool
    gem install fasterer         # performance suggestions
    gem install reek             # code smell detector
    gem install ruby-debug-ide   # debugging
    gem install debase           # debugging
    
    # Install Node.js (required for Rails asset pipeline)
    if ! command -v node &> /dev/null; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs
    fi
    
    check_status "Ruby development environment"
}

# Function to install all languages
install_all_languages() {
    install_golang
    install_rust
    install_java
    install_ruby
    install_php
    install_dotnet
    install_cpp
    install_kotlin
    install_swift
}

# Main language installation menu
language_menu() {
    local install_type="$1"
    if [ -z "$install_type" ]; then
        echo "Language Installation Menu"
        echo "-------------------------"
        echo "1) Install All Languages"
        echo "2) Install Go"
        echo "3) Install Rust"
        echo "4) Install Java"
        echo "5) Install Ruby"
        echo "6) Install PHP"
        echo "7) Install .NET"
        echo "8) Install C/C++"
        echo "9) Install Kotlin"
        echo "10) Install Swift"
        echo "0) Exit"
    
        read -p "Please select an option [0-10]: " choice
    else
        # Automatic mode
        choice="$install_type"
    fi
    case $choice in
        "all"|"1") install_all_languages ;;
        "golang"|"2") install_golang ;;
        "rust"|"3") install_rust ;;
        "java"|"4") install_java ;;
        "ruby"|"5") install_ruby ;;
        "php"|"6") install_php ;;
        "dotnet"|"7") install_dotnet ;;
        "cpp"|"8") install_cpp ;;
        "kotlin"|"9") install_kotlin ;;
        "swift"|"10") install_swift ;;
        "exit"|"0") exit 0 ;;
        *) 
            if [ -z "$install_type" ]; then
                print_error "Invalid option"
                language_menu
            else
                print_error "Invalid installation type. Use 'all' or language name eg 'java'..."
                exit 1
            fi
            ;;
    esac
}


# Main execution
if [ $# -eq 0 ]; then
    language_menu
else
    language_menu "$1"
fi