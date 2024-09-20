{
  lib,
  private,
  pkgs,
}:
with pkgs; [
  # _1password
  # _1password-gui
  alejandra
  atool
  bat
  coreutils-prefixed
  # dovecot
  du-dust
  duf
  entr
  fd
  findutils
  fzf
  git
  gitui
  # go
  gron
  jid
  jq
  kubectl
  kubernetes-helm
  ldns
  lz4
  mosh
  nerdfonts
  nix-diff
  nix-tree
  # nodejs_20
  nvd
  pv
  # python3
  rclone
  rename
  ripgrep
  rsync
  sd
  shellcheck
  shfmt
  silver-searcher
  ssh-copy-id
  sshfs
  tldr
  wget
  # yarn
  yq-go
  zellij
]
# ++ ((lib.optionals (lib.hasAttr "homebase" private)) [
#   borgmatic
# ])
# ++ ((lib.optionals (pkgs.system == "aarch64-darwin")) [
#   obsidian
#   # dockutil
# ])

