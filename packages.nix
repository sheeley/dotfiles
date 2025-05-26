{
  lib,
  private,
  pkgs,
}:
with pkgs; [
  alejandra # Code formatter for Nix expressions
  atool # Archiving utility; useful for extracting various archive types
  bat # Enhanced `cat` command with syntax highlighting and paging
  borgmatic # Backup, bb!
  bottom # btm ~ better top, htop, cpu, mem, etc
  coreutils-prefixed # GNU Coreutils with commands prefixed (e.g., `gfind`, `gsed`)
  du-dust # Disk usage visualization tool
  dua # disk usage, interactively
  duf # User-friendly disk usage/free space utility
  entr # Automatically run commands when files change
  eza # Modern, enhanced `ls` command with Git integration
  f2 # Command-line batch renaming tool
  fd # Fast, user-friendly alternative to `find`
  fend # better CLI calculator
  findutils # Basic utilities for searching files (e.g., `find`, `xargs`)
  fx # cli json viewer
  fzf # Command-line fuzzy finder for interactive filtering
  git # Version control system
  gitui # Terminal-based Git user interface
  go # best language ever
  gron # Convert JSON into a grep-able format and back
  gnused # gnu sed replace text
  jid # Interactive JSON query tool
  jq # Lightweight JSON processor
  kubectl # Kubernetes command-line tool for managing clusters
  kubernetes-helm # Kubernetes package manager
  ldns # DNS library and utilities (e.g., `drill` for DNS lookups)
  lnav # log file navigator
  lz4 # Fast compression/decompression utility
  moreutils # Collection of additional Unix utilities (e.g., `ts`, `sponge`)
  ncdu # Disk usage analyzer with an interactive interface
  nerd-fonts.fira-mono
  nerd-fonts.fira-code
  nix-diff # Tool for showing differences between Nix derivations
  nix-tree # Visualize Nix dependency trees
  nvd # Nix/NixOS package version diff tool
  osc # Command line tool to access the system clipboard from anywhere using the ANSI OSC52 sequence
  oils-for-unix # bash-compatible new terminal
  procs # better ps
  pv # Monitor data flow through a pipe
  rclone # Cloud storage synchronization and file management
  rename # Rename multiple files based on patterns
  ripgrep # High-performance text searching tool
  rsync # File synchronization and transfer tool
  sd # Modern find and replace tool (simpler than `sed`)
  shellcheck # Linter for shell scripts
  shfmt # Formatter for shell scripts
  # silver-searcher # Fast code searching tool (`ag`)
  ssh-copy-id # Add SSH public key to a remote machine
  sshfs # Mount remote directories over SSH
  tldr # Community-driven man pages with practical examples
  # tailspin # Log file highlighter
  tre-command # Modern `tree` command alternative
  ugrep # Ultra-fast grep alternative with additional features
  uv # Disk usage analyzer
  viddy # better watch file change
  wget # Command-line utility for retrieving files via HTTP/HTTPS
  yq-go # YAML processor (like `jq`, but for YAML)
]
# ++ ((lib.optionals (pkgs.system == "aarch64-darwin")) [
#   obsidian
#   # dockutil
# ])

