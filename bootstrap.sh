#!/bin/bash


## 1. Install Xcode Command Line Tools
# a. Create a temporary "placeholder" file that makes macOS think an install is requested
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

# b. Find the exact name of the Command Line Tools update from Apple's servers
PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')

# c. Install that specific product
sudo softwareupdate -i "$PROD" --verbose

# d. Remove the temporary placeholder
rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

# e. Automated EULA Acceptance - Might require password
sudo xcodebuild -license accept


## 2. Install Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Ensure brew is in PATH for Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi


## 3. Install Ansible
if ! command -v ansible &>/dev/null; then
    echo "Installing Ansible..."
    brew install ansible
fi


## 4. Install Ansible Requirements
echo "Installing Ansible collections..."
ansible-galaxy install -r requirements.yml

echo "Bootstrap complete! You can now run: ansible-playbook main.yml"
