# Nix-based Dotfiles

A declarative system configuration using Nix that manages:
- **macOS systems** via nix-darwin (personal and work machines)
- **NixOS systems** (servers)
- **Home directory** via home-manager (Linux/macOS)

Includes:
- 70+ CLI tools (ripgrep, fzf, gitui, etc.)
- Development environments (Go, Python/uv, Swift)
- Text editors (Neovim, Helix, VS Code)
- Shell configurations (Fish, Zsh, Starship)
- Git settings and aliases
- System preferences and automation

## Installation

```sh
# One-line install - clones repo and configures your system
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sheeley/dotfiles/refs/heads/main/initial_setup.sh)"
```

The script will:
1. Install Nix if needed
2. Clone this repository to `~/dotfiles`
3. Apply the configuration for your hostname
4. Set up all tools and preferences

After installation, use `./apply` to update your system with any changes.

## To Check Out

### nix-inspect
https://github.com/bluskript/nix-inspect
Interactive TUI for browsing Nix configurations with fuzzy search and bookmarks

### nix-init & nurl
https://github.com/nix-community/nix-init
https://github.com/nix-community/nurl
Generate Nix packages from URLs with hash prefetching and dependency inference

### nh
https://github.com/viperML/nh
Modern nixos-rebuild replacement with integrated nvd diffs and nom build output

### nix-output-monitor (nom)
https://github.com/maralorn/nix-output-monitor
Enhanced build output with progress tracking, emojis, and parallel build visualization

### nix-du
https://github.com/symphorien/nix-du
Visualize gc-roots disk usage to help identify what to delete
