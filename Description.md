# Project: macOS Setup Automation (Ansible)

This is a personal Ansible framework for automating macOS workstation setup. Everything is modular and toggled via `vars.yml`.

---

## Root Files

| File | Purpose |
|---|---|
| `main.yml` | Main playbook — orchestrates all tasks based on toggles |
| `vars.yml` | Central config — all variables, paths, app lists, and on/off switches |
| `requirements.yml` | Ansible Galaxy dependencies (community.general collection) |
| `bootstrap.sh` | First-run script for fresh Macs — installs Xcode CLT, Homebrew, Ansible |
| `ansible.cfg` | Ansible configuration (paths for collections, roles, inventory) |
| `README.md` | Quick-start instructions |
| `Documentation.md` | Full technical documentation of the project architecture |
| `.gitignore` | Excludes `.DS_Store`, logs, vault secrets, tests dir |

---

## `tasks/` — Modular Task Files

| File | Purpose |
|---|---|
| `homebrew.yml` | Installs apps via Homebrew casks (iTerm2, VS Code, Chrome, etc.) |
| `symlinks_dotfiles.yml` | Clones private dotfiles repo and symlinks shell configs to `~` |
| `app_conf.yml` | Orchestrator — pulls config repo and runs app-specific configs |
| `ssh_conf_enable_github.yml` | Configures SSH for GitHub access using macOS Keychain |
| `ssh_client_config-.yml` | Manages SSH client config, HashKnownHosts, and hashed known_hosts |
| `vscode-.yml` | Installs VS Code extensions, symlinks settings, sets file associations |
| `iterm2-.yml` | Symlinks iTerm2 preferences and enables custom config folder |
| `espanso-.yml` | Symlinks Espanso config from Dropbox and restarts the service |

---

## `tests/` — Reference/Test Playbooks

Standalone playbooks for testing specific tasks in isolation (dock settings, Spotify install, MarkEdit install, legacy dotfiles).

---

## How It Works

1. Run `bootstrap.sh` on a fresh Mac
2. Adjust toggles in `vars.yml` to select what to install/configure
3. Run `ansible-playbook main.yml` — it conditionally executes only what's enabled
