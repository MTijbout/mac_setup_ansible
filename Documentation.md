# macOS Tahoe Automation with Ansible: Complete Guide
This document outlines the structure and logic for a modular Ansible setup designed to automate a macOS workstation. It covers SSH configuration, Homebrew applications, VS Code extensions, iTerm2 preferences, and dotfile management across multiple private repositories.

## 1. Project Structure
To maintain a "Mint" ready environment, organize your files as follows:
```text
.
├── main.yml                 # Main entry point (Logic)
├── vars.yml                 # Configuration data (Variables)
├── requirements.yml         # Ansible dependencies
├── bootstrap.sh             # Initial setup script for new Macs
└── tasks/                   # Modular task files
    ├── ssh_github.yml        # SSH keys & macOS Keychain config
    ├── homebrew.yml          # Casks, Apps, and Fonts
    ├── vscode.yml            # Extensions & settings.json symlink
    ├── iterm2.yml            # Plist syncing & preference loading
    ├── symlinks_dotfiles.yml # Repo cloning & shell symlinks
    ├── create_folders.yml    # Creates directories from directories_to_create
    └── create_links.yml      # Creates symlinks from symlinks_to_create
```
Use code with caution.

## 2. Configuration (vars.yml)
Separating your data from your logic allows you to update your app list or repo paths without touching the code.
```yaml
# --- Directory Config ---
github_base_dir: "{{ ansible_facts['env']['HOME'] }}/GitHub"
ssh_key_path: "{{ ansible_facts['env']['HOME'] }}/.ssh/id_github_mtijbout_sparky_user_auth"

# --- Repository Config ---
dotfiles_repo: "git@github.com:MTijbout/dotfiles.git"
dotfiles_dest: "{{ github_base_dir }}/dotfiles"

configs_repo: "git@github.com:MTijbout/configurations.git"
configs_dest: "{{ github_base_dir }}/configurations"

# --- App Specifics ---
homebrew_casks: [iterm2, visual-studio-code, google-chrome, font-jetbrains-mono]

vscode_extensions: [redhat.ansible, ms-python.python, eamodio.gitlens, esbenp.prettier-vscode]
vscode_config_dir: "{{ ansible_facts['env']['HOME'] }}/Library/Application Support/Code/User"
vscode_settings_file: "{{ configs_dest }}/vscode/settings.json"

iterm_config_dir: "{{ ansible_facts['env']['HOME'] }}/.config/iterm2"
iterm_config_file: "com.googlecode.iterm2.plist"
iterm_repo_src: "{{ configs_dest }}/iterm2/{{ iterm_config_file }}"

dotfiles_to_link: [.aliases-darwin, .vimrc]

# --- Toggles ---
setup_ssh: true
setup_homebrew: true
setup_vscode: true
setup_iterm2: true
setup_dotfiles: true
setup_create_folders: false
setup_create_links: false

# --- Folders and Symlinks ---
directories_to_create:
  - "{{ ansible_facts['user_dir'] }}/Projects"

symlinks_to_create:
  - src: "{{ ansible_facts['user_dir'] }}/Dropbox/notes"
    dest: "{{ ansible_facts['user_dir'] }}/Documents/notes"
  - src: /Volumes/Backup/dotfiles
    dest_dir: "{{ ansible_facts['user_dir'] }}/Projects"
```
Use code with caution.

## 3. The Main Playbook (main.yml)
The "Engine" that executes tasks based on your toggles.
```yaml
---
- name: macOS Tahoe Full Setup
  hosts: localhost
  connection: local
  gather_facts: yes

  vars_files:
    - vars.yml

  tasks:
    - name: Run SSH Setup
      ansible.builtin.include_tasks: tasks/ssh_github.yml
      when: setup_ssh

    - name: Run Homebrew Installation
      ansible.builtin.include_tasks: tasks/homebrew.yml
      when: setup_homebrew

    - name: Run Dotfile and Config Symlinking
      ansible.builtin.include_tasks: tasks/symlinks_dotfiles.yml
      when: setup_dotfiles

    - name: Run VS Code Configuration
      ansible.builtin.include_tasks: tasks/vscode.yml
      when: setup_vscode

    - name: Run iTerm2 Configuration
      ansible.builtin.include_tasks: tasks/iterm2.yml
      when: setup_iterm2
```
Use code with caution.

## 4. Creating Folders and Symlinks

### Folders (`create_folders.yml`)
Iterates over `directories_to_create` and ensures each path exists with mode `0755`:
```yaml
- name: Create directories
  ansible.builtin.file:
    path: "{{ item }}"
    state: directory
    mode: '0755'
  loop: "{{ directories_to_create }}"
```

### Symlinks (`create_links.yml`)
Supports two patterns — explicit `dest` (full path) or `dest_dir` (directory, link name taken from source basename). When `dest_dir` is used, the directory is created automatically before the link:

```yaml
symlinks_to_create:
  # Pattern 1: explicit full destination path
  - src: "{{ ansible_facts['user_dir'] }}/Dropbox/notes"
    dest: "{{ ansible_facts['user_dir'] }}/Documents/notes"

  # Pattern 2: dest_dir — link placed in directory, named after source basename
  # Result: ~/Projects/dotfiles -> /Volumes/Backup/dotfiles
  - src: /Volumes/Backup/dotfiles
    dest_dir: "{{ ansible_facts['user_dir'] }}/Projects"
```

## 6. Key Task Highlights

### VS Code (Handling Spaces in Paths)
Use quoted paths to prevent shell errors with the code binary:
```yaml
- name: Install VS Code extensions
  ansible.builtin.shell:
    cmd: "'/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' --install-extension {{ item }}"
  loop: "{{ vscode_extensions }}"
```
Use code with caution.

### iTerm2 (Graceful Syncing)
Quit the app via AppleScript before syncing the .plist to prevent it from overwriting your changes:
```yaml
- name: Quit iTerm2
  ansible.builtin.shell: osascript -e 'quit app "iTerm"'
  failed_when: false
```
Use code with caution.

## 7. Bootstrapping a New Machine
1. Clone your repo.
2. Manually add your SSH key to GitHub (since the repo is private).
3. Run `ansible-galaxy install -r requirements.yml` to get the community.general collection.
4. Execute: `ansible-playbook main.yml`


---
My help: https://share.google/aimode/AHYvvcL5dF1E8tmyY 