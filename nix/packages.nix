{ pkgs }:

with pkgs; [
  _1password
  # _1password-gui
  atool
  bat
  broot
  chezmoi
  coreutils-prefixed
  dockutil
  du-dust
  duf
  entr
  fd
  fish
  fzf
  git
  gitui
  go
  gron
  jid
  jq
  neovim
  nerdfonts
  nixpkgs-fmt
  pv
  python311
  rclone
  ripgrep
  rsync
  shellcheck
  shfmt
  silver-searcher
  ssh-copy-id
  starship
  tldr
  vim-vint
  vscode
  wget
  fishPlugins.done
  # fishPlugins.fzf-fish
  # fishPlugins.forgit
]
