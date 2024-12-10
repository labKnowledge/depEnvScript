#!/bin/bash

# Golang Development Environment
install_golang() {
    print_message "Installing Go development environment..."
    
    # Install Go
    wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
    rm go1.22.0.linux-amd64.tar.gz
    
    # Add to PATH
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    
    # Install common Go tools
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    
    check_status "Go development environment"
}

# Rust Development Environment
install_rust() {
    print_message "Installing Rust development environment..."
    
    # Install Rust using rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    
    # Install common Rust tools
    rustup component add rustfmt
    rustup component add clippy
    cargo install cargo-edit
    cargo install cargo-watch
    
    check_status "Rust development environment"
}

# Java Development Environment
install_java() {
    print_message "Installing Java development environment..."
    
    # Install OpenJDK
    sudo apt install -y openjdk-17-jdk openjdk-17-jre
    
    # Install Maven
    sudo apt install -y maven
    
    # Install Gradle
    sudo apt install -y gradle
    
    # Install Spring Boot CLI
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install springboot
    
    check_status "Java development environment"
}

# Ruby Development Environment
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
    gem install bundler
    gem install rails
    gem install rspec
    gem install rubocop
    
    check_status "Ruby development environment"
}