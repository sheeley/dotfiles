{
  # config,
  pkgs,
  # lib,
  user,
  inputs,
  private,
  ...
}: let
  isMac = pkgs.system == "aarch64-darwin";
in {
  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      private = private;
    };
  };
  # verbose = true;

  home-manager.users.${user} = {
    config,
    lib,
    pkgs,
    ...
  }: {
    programs.bash.enable = true;
    programs.home-manager.enable = true;

    imports =
      [
        inputs.nixvim.homeManagerModules.nixvim
        ./programs/fish.nix
        ./programs/general.nix
        ./programs/git.nix
        ./programs/gitui.nix
        ./programs/helix.nix
        ./programs/neovim.nix
        ./programs/nushell.nix
        ./programs/ssh.nix
        ./programs/starship.nix
        ./programs/zellij.nix
        ./programs/zsh.nix
      ]
      # ++ ((lib.optionals (lib.hasAttr "personal" private && private.personal)) [
      #   # personal only
      # ])
      ++ ((lib.optionals isMac) [
        # ./programs/ghostty.nix
        ./programs/vscode.nix
        ./home-darwin-defaults.nix
      ]);

    xdg.configFile = {
      "ghostty/config".source = ./files/ghostty;
    };

    home = {
      stateVersion = "22.05";

      sessionVariables = import ./environment_variables.nix {
        homeDirectory = config.home.homeDirectory;
        lib = lib;
        private = private;
      };

      # this sometimes doesn't work with fish
      # https://github.com/LnL7/nix-darwin/issues/122
      sessionPath = pkgs.callPackage ./environment_path.nix {user = user;};

      packages = pkgs.callPackage ./packages.nix {
        lib = lib;
        private = private;
      };

      file = {
        ".mongorc.js".text = builtins.readFile ./files/.mongorc.js;
        ".swiftformat".text = builtins.readFile ./files/.swiftformat;

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
      };

      shellAliases = {
        a = "./apply";
        cat = "bat";
        cddot = "cd ~/dotfiles";
        cdgo = "cd $GOPATH/src";
        cdicloud = "cd $ICLOUD_DIR";
        cdinfra = "cd $PRIVATE_TOOLS_DIR";
        cdnotes = "cd $NOTES_DIR";
        cdproj = "cd $HOME/projects/sheeley";
        cdscratch = "cd ~/scratch";
        cdtools = "cd $TOOLS_DIR";
        cdwork = "cd ~/work";
        cdworknotes = "cd $WORK_NOTES_DIR";
        clone = "git clone";
        la = "ls -la";
        vdot = "vim ~/dotfiles";
      };
    };
  };
}
