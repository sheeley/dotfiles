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
        ./programs/vscode.nix
        ./programs/zsh.nix
      ]
      # ++ ((lib.optionals (lib.hasAttr "personal" private && private.personal)) [
      #   # personal only
      # ])
      ++ ((lib.optionals isMac) [
        ./home-darwin-defaults.nix
      ]);

    programs.zellij = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
      settings = {
        copy_command = "pbcopy";
      };
      #       keybinds {
      #     // keybinds are divided into modes
      #     normal {
      #         // bind instructions can include one or more keys (both keys will be bound separately)
      #         // bind keys can include one or more actions (all actions will be performed with no sequential guarantees)
      #         bind "Ctrl g" { SwitchToMode "locked"; }
      #         bind "Ctrl p" { SwitchToMode "pane"; }
      #         bind "Alt n" { NewPane; }
      #         bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
      #     }
      #     pane {
      #         bind "h" "Left" { MoveFocus "Left"; }
      #         bind "l" "Right" { MoveFocus "Right"; }
      #         bind "j" "Down" { MoveFocus "Down"; }
      #         bind "k" "Up" { MoveFocus "Up"; }
      #         bind "p" { SwitchFocus; }
      #     }
      #     locked {
      #         bind "Ctrl g" { SwitchToMode "normal"; }
      #     }
      # }
    };

    home = {
      stateVersion = "22.05";

      # TODO: pkgs.callPackage ./environment_variables.nix {private = private;};
      sessionVariables = {
        # BORG_PASSPHRASE = "${private.borgSecret}";
        DOTFILES_DIR = "${config.home.homeDirectory}/dotfiles";
        EDITOR = "nvim";
        GITHUB_TOKEN = "${private.githubSecret}";
        GOPATH = "${config.home.homeDirectory}/go";
        GOPROXY = "direct";
        GOSUMDB = "off";
        ICLOUD_DIR = "${config.home.homeDirectory}/Library/Mobile Documents/com~apple~CloudDocs";
        LESS = "-R";
        N_PREFIX = "$HOME/.n";
        NOTES_DIR = "${config.home.homeDirectory}/projects/sheeley/notes";
        PRIVATE_CMD_DIR = "${config.home.homeDirectory}/projects/sheeley/infrastructure/cmd";
        PRIVATE_DATA_DIR = "${config.home.homeDirectory}/projects/sheeley/infrastructure/data";
        PRIVATE_TOOLS_DIR = "${config.home.homeDirectory}/projects/sheeley/infrastructure";
        TOOLS_DIR = "${config.home.homeDirectory}/dotfiles/bin";
        WORK_NOTES_DIR = "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Apple Notes";
        WORKMACHINE = "false";

        # Starship spcific
        STARSHIP_LOG = "error";
      };

      # this sometimes doesn't work with fish
      # https://github.com/LnL7/nix-darwin/issues/122
      sessionPath = pkgs.callPackage ./environment_path.nix {};

      packages = pkgs.callPackage ./packages.nix {
        lib = lib;
        private = private;
      };

      file = {
        ".mongorc.js".text = builtins.readFile ./files/.mongorc.js;
        ".swiftformat".text = builtins.readFile ./files/.swiftformat;
        # ".swiftlint.yml".text = builtins.readFile ./files/.swiftlint.yml;
        # ".vim/ftdetect/toml.vim".text = "autocmd BufNewFile,BufRead *.toml set filetype=toml";

        # TODO: this always changes?
        # link instead of make a real file because this needs to be modified to login/etc
        # ".npmrc".source = config.lib.file.mkOutOfStoreSymlink ./files/.npmrc;

        # ".config/rclone/rclone.conf".source = pkgs.substituteAll {
        #   name = "rclone.conf";
        #   src = ./files/rclone.conf;
        #   user = "${private.borgUser}";
        # };
      };

      shellAliases = {
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
        v = "vim .";
      };
    };
  };
}
