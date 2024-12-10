# Dev Environment Setup Script

## Overview
This repository contains a script named `devInstall.sh` designed to simplify the installation of development tools, libraries, and applications on an Ubuntu 22.04 system. The script is crafted to provide flexibility, allowing users to choose between full automation or manual selection of components for their development environment.

## Why This Script?

1. **Streamlined Development Setup**: Automate the process of setting up a robust development environment, saving time and reducing errors that can occur during manual installation.
   
2. **Versatile Installation Options**: Provide options for both automatic and manual installations, allowing users to tailor the setup based on their specific needs or preferences.

3. **Efficiency and Productivity**: By handling repetitive tasks, this script ensures that developers have a ready-to-go environment with minimal configuration required, enhancing productivity.

4. **Customization**: Users can choose which components to install, whether it's basic tools, AI/ML libraries, or specific IDEs, making the setup highly customizable.

5. **Simplicity in Maintenance**: Regular updates and maintenance of development environments can be streamlined using this script, ensuring that all necessary packages are kept up-to-date.

## How to Use

### Prerequisites

1. **Ensure Your System is Up-to-Date:**
   Before running the script, make sure your system packages are up-to-date.
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Run Directly from GitHub (Recommended):**
   You can run the script directly from GitHub without cloning the repository using the following command:
   - Full installation 

    ```bash
    curl -o- https://labknowledge.github.io/depEnvScript/devInstall.sh | bash -s full
    ```

    - Minimal Installation

    ```bash
    curl -o- https://labknowledge.github.io/depEnvScript/devInstall.sh | bash -s minimal
    ```

    - Manual Installation

    ```bash
    curl -o- https://labknowledge.github.io/depEnvScript/devInstall.sh | bash -s manual

   This method simplifies the process and is ideal for those who just need a quick setup.

3. **Clone the Repository:**
   Alternatively, you can clone the repository to your local machine using `git`.
   ```bash
   git clone https://github.com/labKnowledge/depEnvScript.git
   cd depEnvScript
   ```

### Running the Script

1. **Make the Script Executable:**
   Before running, make sure the script has execute permissions.
   ```bash
   chmod +x devInstall.sh
   ```

2. **Run the Installation Menu:**
   Execute the script to start the installation process.
   ```bash
   ./devInstall.sh
   ```

### Main Installation Menu

Upon running `devInstall.sh`, you will be presented with a menu:

```bash
Ubuntu 22.04 Development Environment Setup
----------------------------------------
1) Automatic Installation (All components)
2) Minimal Installation (Basic tools, Git, Docker)
3) Manual Installation (Choose components)
4) Exit
```

### Options

- **Automatic Installation (All Components):**
  Select this option to automatically install all available components. This is ideal if you want a fully configured development environment with minimal manual intervention.

  ```bash
  Please select an option [1-4]: 1
  ```

- **Minimal Installation (Basic tools, Git, Docker):**
  Choose this option for a basic setup consisting of essential development tools like `build-essential`, `git`, and `Docker`.

  ```bash
  Please select an option [1-4]: 2
  ```

- **Manual Installation (Choose Components):**
  This allows you to selectively install components based on your needs. You will be prompted for each component individually.

  ```bash
  Please select an option [1-4]: 3
  Select components to install (y/n for each):
  Install basic development tools? [y/n]: y
  Install Docker? [y/n]: y
  Install Node.js and related tools? [y/n]: n
  Install Python development environment? [y/n]: n
  Install AI/ML tools? [y/n]: n
  Install Visual Studio Code? [y/n]: n
  Install browsers? [y/n]: n
  ```

- **Exit:**
  Exit the script without performing any installations.

  ```bash
  Please select an option [1-4]: 4
  ```

### Post-Installation

After making your selection, the script will begin installing the chosen components. Once the installation is complete, you may need to log out and log back in for some changes to take effect (e.g., environment variables for tools like `nvm`).

```bash
print_warning "Please log out and log back in for some changes to take effect."
```

### Troubleshooting

If anything goes wrong during the installation, check the terminal output for error messages. The script includes functions like `print_error`, `print_message`, and `check_status` to help you identify issues.

For more detailed troubleshooting or additional customization options, refer to the README file in the repository.

### Example Usage Scenarios

1. **Quick Setup:**
   If you need a quick development environment with everything installed automatically:
   ```bash
   ./devInstall.sh 1
   ```

2. **Basic Setup:**
   For a basic setup without AI/ML tools:
   ```bash
   ./devInstall.sh 2
   ```

3. **Custom Setup:**
   If you want to pick and choose specific components:
   ```bash
   ./devInstall.sh 3
   ```

By following these steps, you can easily set up a robust development environment tailored to your needs on Ubuntu 22.04 using the `devInstall.sh` script from the specified repository.