{
  # config,
  pkgs,
  lib,
  user,
  inputs,
  private,
  isMac,
  ...
}: let
  prefix =
    if isMac
    then "Users"
    else "home";
  homeDir = "/${prefix}/${user}";
in {
  programs.home-manager.enable = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.bash.enable = true;
  home.shell.enableShellIntegration = true;

  imports = [
    ./programs/fish.nix
    ./programs/general.nix
    ./programs/git.nix
    ./programs/gitui.nix
    ./programs/helix.nix
    inputs.nixvim.homeManagerModules.nixvim
    ./programs/neovim.nix
    ./programs/nushell.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/zellij.nix
    ./programs/zsh.nix
    ./shell-aliases.nix
  ];

  xdg.configFile = {
    "ghostty/config".source = ./files/ghostty;
  };

  home = {
    username = user;
    homeDirectory = homeDir;
    stateVersion = "22.05";

    sessionVariables = import ./environment_variables.nix {
      homeDirectory = homeDir;
      lib = lib;
      private = private;
    };

    # this sometimes doesn't work with fish
    # https://github.com/LnL7/nix-darwin/issues/122
    sessionPath = pkgs.callPackage ./environment_path.nix {
      user = user;

      homeDirectory = homeDir;
    };

    packages = pkgs.callPackage ./packages.nix {
      lib = lib;
      private = private;
    };

    file = {
      # ".mongorc.js".text = builtins.readFile ./files/.mongorc.js;
      # ".swiftformat".text = builtins.readFile ./files/.swiftformat;
      # ".swiftlint.yml".text = builtins.readFile ./files/.swiftlint.yml;
      # ".vim/ftdetect/toml.vim".text = "autocmd BufNewFile,BufRead *.toml set filetype=toml";

      # for right now, seems more effective to just copy .npmrc
      # link instead of make a real file because this needs to be modified to login/etc
      # ".npmrc".source = config.lib.file.mkOutOfStoreSymlink ./files/.npmrc;

      # ".config/rclone/rclone.conf".source = pkgs.substituteAll {
      #   name = "rclone.conf";
      #   src = ./files/rclone.conf;
      #   user = "${private.borgUser}";
      # };
      # ".ssh/authorized_keys".source = ./files/authorized_keys;
    };

    activation = {
      createDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
        DIRS=(
        	"${homeDir}/.ssh/control"
        	"${homeDir}/Screenshots"
        	"${homeDir}/projects/sheeley"
        	"${homeDir}/bin"
        	"${homeDir}/scratch"
        )
        for DIR in "''${DIRS[@]}"; do
        	mkdir -p "$DIR"
        	chown -R ${user} "$DIR"
        done
      '';

      authorizedKeys = lib.hm.dag.entryAfter ["writeBoundary"] ''
        cp -f ${homeDir}/dotfiles/files/authorized_keys ~/.ssh/
        chmod 640 ~/.ssh/authorized_keys
      '';
    };
  };
}
