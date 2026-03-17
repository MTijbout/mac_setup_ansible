# macOS Tahoe Setup

This repository contains my personal Ansible automation for setting up a clean macOS Tahoe environment. It handles everything from SSH keys and Homebrew to specific configurations for iTerm2, VS Code, Espanso, and SSH.

## Quick Start (Fresh Machine)

If you are on a brand-new Mac, follow these steps to bootstrap your environment:

1. Install Xcode Command Line Tools:
```bash
xcode-select --install
```

2. Clone this repository (requires manual SSH key setup on GitHub first):
```bash
mkdir -p ~/GitHub && cd ~/GitHub
git clone git@github.com:MTijbout/mac_setup_ansible.git
```

3. Run the Bootstrap Script (installs Homebrew and Ansible):
```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

4. Install Ansible dependencies:
```bash
ansible-galaxy install -r requirements.yml
```

5. Run the playbook:
```bash
ansible-playbook main.yml
```

## Project Structure

- `main.yml` — Main entry point; orchestrates all tasks based on toggles in `vars.yml`
- `vars.yml` — All personal configuration, repo paths, app lists, and setup toggles
- `requirements.yml` — External Ansible collections (`community.general`)
- `bootstrap.sh` — First-run script for fresh Macs
- `Description.md` — Detailed description of all files and their purpose
- `tasks/` — Modular task files:
  - `ssh_conf_enable_github.yml` — Configures SSH access to GitHub via macOS Keychain
  - `homebrew.yml` — Installs applications via Homebrew casks
  - `symlinks_dotfiles.yml` — Clones private dotfiles repo and symlinks shell configs
  - `app_conf.yml` — Pulls configurations repo and manages app-specific setup (VS Code, iTerm2, Espanso, SSH client config)

## Customization

Edit `vars.yml` to control which components run. Top-level toggles:

```yaml
setup_ssh_github: false    # Configure SSH key for GitHub access
setup_homebrew: true       # Install Homebrew casks
setup_app_conf: false      # Run application configurations
setup_dotfiles: false      # Clone and symlink dotfiles
```

When `setup_app_conf` is enabled, additional toggles control sub-tasks:

```yaml
setup_vscode_extensions: true      # Install VS Code extensions
setup_vscode_user_settings: false  # Symlink VS Code settings.json
setup_vscode_file_handling: true   # Set VS Code as default for md/json/yaml
setup_ssh_conf: true               # Configure SSH client settings
setup_ssh_conf_hashknownhosts: true
setup_iterm2: false                # Symlink iTerm2 preferences
setup_espanso: false               # Symlink Espanso config from Dropbox
```

## Homebrew Casks Installed

- espanso
- iterm2
- visual-studio-code
- google-chrome
- font-jetbrains-mono
- node
- obsidian

## Maintenance

To re-run the playbook after making changes:
```bash
ansible-playbook main.yml
```

To run only a specific part, toggle the relevant `setup_*` variables in `vars.yml` and re-run.
