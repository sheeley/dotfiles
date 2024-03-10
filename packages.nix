{
  lib,
  private,
  pkgs,
}:
with pkgs;
  [
    # _1password
    # _1password-gui
    alejandra
    atool
    bat
    coreutils-prefixed
    dockutil
    # dovecot
    du-dust
    duf
    entr
    fd
    findutils
    fzf
    git
    gitui
    go
    gron
    jid
    jq
    kubectl
    kubernetes-helm
    ldns
    lz4
    nerdfonts
    nix-diff
    nodejs_20
    nvd
    obsidian
    pv
    # python311
    rclone
    rename
    ripgrep
    rsync
    shellcheck
    shfmt
    silver-searcher
    ssh-copy-id
    sshfs
    tldr
    vim-vint
    wget
    yarn
  ]
  ++ ((lib.optionals (lib.hasAttr "homebase" private)) [
    borgmatic
  ])
