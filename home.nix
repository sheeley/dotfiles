{
  config,
  pkgs,
  lib,
  user,
  inputs,
  private,
  ...
}: let
in {
  imports = [
    ./dock.nix
  ];

  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      private = private;
    };
    # verbose = true;
  };

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
      ++ ((lib.optionals (lib.hasAttr "personal" private && private.personal)) [
        # personal only
      ]);

    home = {
      stateVersion = "22.05";

      # TODO: pkgs.callPackage ./environment_variables.nix {private = private;};
      sessionVariables = {
        # BORG_PASSPHRASE = "${private.borgSecret}";
        BORG_REPO = "/Volumes/money/borgbackup";
        DOTFILES_DIR = toString ~/dotfiles;
        EDITOR = "nvim";
        GITHUB_TOKEN = "${private.githubSecret}";
        GOPATH = toString ~/go;
        GOPROXY = "direct";
        GOSUMDB = "off";
        ICLOUD_DIR = toString (~/Library + "/Mobile Documents/com~apple~CloudDocs");
        LESS = "-R";
        N_PREFIX = "$HOME/.n";
        NOTES_DIR = toString ~/projects/sheeley/notes;
        PRIVATE_CMD_DIR = toString ~/projects/sheeley/infrastructure/cmd;
        PRIVATE_DATA_DIR = toString ~/projects/sheeley/infrastructure/data;
        PRIVATE_TOOLS_DIR = toString ~/projects/sheeley/infrastructure;
        TOOLS_DIR = toString ~/dotfiles/bin;
        WORK_NOTES_DIR = toString (~/Library + "/Mobile Documents/iCloud~md~obsidian/Documents/Apple Notes");
        WORKMACHINE = "false";
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
        ".swiftlint.yml".text = builtins.readFile ./files/.swiftlint.yml;
        ".vim/ftdetect/toml.vim".text = "autocmd BufNewFile,BufRead *.toml set filetype=toml";

        # link instead of make a real file because this needs to be modified to login/etc
        ".npmrc".source = config.lib.file.mkOutOfStoreSymlink ./files/.npmrc;

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
      };
    };
  };
}
