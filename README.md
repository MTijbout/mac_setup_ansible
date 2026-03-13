# macOS Tahoe Setup

This repository contains my personal Ansible automation for setting up a clean macOS Tahoe environment. It handles everything from SSH keys and Homebrew to specific configurations for iTerm2 and VS Code.

## 🚀 Quick Start (Mint Machine)
If you are on a brand-new Mac, follow these steps to bootstrap your environment:

1. Install Xcode Command Line Tools:
```bash
xcode-select --install
```
Use code with caution.

2. Clone this repository (Requires manual SSH key setup on GitHub first):
```bash
mkdir -p ~/GitHub && cd ~/GitHub
git clone git@github.com:MTijbout/dotfiles.git
```
Use code with caution.

3. Run the Bootstrap Script (Installs Homebrew and Ansible):
```bash
chmod +x bootstrap.sh
./bootstrap.sh
```
Use code with caution.

4. Run the Playbook:
```bash
ansible-playbook main.yml
```
Use code with caution.

## 📂 Project Structure
- main.yml: The main entry point (playbook logic).
- vars.yml: All personal configuration, repo paths, and app lists.
- requirements.yml: External Ansible collections (community.general).
- tasks/: Modular task files for specific components:
  - ssh_github.yml: Configures SSH and macOS Keychain.
  - homebrew.yml: Installs Casks (Chrome, VS Code, iTerm2, etc.).
  - symlinks_dotfiles.yml: Clones private repos and links shell configs.
  - vscode.yml: Installs extensions and links settings.json.
  - iterm2.yml: Syncs .plist preferences and handles app restarts.

## ⚙️ Customization
To modify which apps or settings are applied, edit vars.yml. You can toggle entire sections using the setup_* variables:
```yaml
setup_ssh: true
setup_homebrew: true
setup_vscode: true
setup_iterm2: true
setup_dotfiles: true
```
Use code with caution.

## 🛠 Maintenance
To update your setup after making changes to your configurations or dotfiles repositories:
```bash
ansible-playbook main.yml
```
Use code with caution.

To run only a specific part of the setup (e.g., just VS Code), use Tags (if configured) or toggle the vars.yml flags to false.