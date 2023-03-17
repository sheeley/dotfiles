{ config, pkgs, lib, user, ... }:
let
  private = pkgs.callPackage ~/.nix-private/private.nix { };
in
{
  imports = [
    ./dock.nix
  ];

  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    # verbose = true;
  };

  home-manager.users.${user} = { config, lib, pkgs, ... }: {
    programs.bash.enable = true;
    programs.home-manager.enable = true;

    imports = [
      ./programs/fish.nix
      ./programs/general.nix
      ./programs/git.nix
      ./programs/gitui.nix
      ./programs/helix.nix
      ./programs/neovim.nix
      ./programs/ssh.nix
      ./programs/starship.nix
      ./programs/zsh.nix
    ];

    home = {
      stateVersion = "22.05";

      sessionVariables = {
        WORKMACHINE = "false";
        GOPROXY = "direct";
        GOSUMDB = "off";
        LESS = "-R";
        BORG_REPO = "/Volumes/money/borgbackup";
        GOPATH = "$HOME/go";
        PRIVATE_CMD_DIR = "$HOME/projects/${user}/infrastructure/cmd";
        PRIVATE_DATA_DIR = "$HOME/projects/${user}/infrastructure/data";
        PRIVATE_TOOLS_DIR = "$HOME/projects/${user}/infrastructure";
        TOOLS_DIR = "$HOME/projects/${user}/tools";
        NOTES_DIR = "$HOME/projects/${user}/notes";
        GITHUB_TOKEN = "${private.githubSecret}";
        EDITOR = "nvim";
      };

      # TODO: this doesn't actually work
      # https://github.com/LnL7/nix-darwin/issues/122
      sessionPath = [
        "$HOME/bin"
        "$HOME/nix-bin"

        "$HOME/projects/sheeley/infrastructure/bin"
        "$HOME/projects/sheeley/infrastructure/scripts"
        "$HOME/go/bin"
        "$HOME/.cargo/bin"
        "$HOME/non-nix-bin"

        "/opt/homebrew/bin"
        "/Applications/Xcode.app/Contents/Developer/usr/bin"

        # "/sbin"
        # "/usr/sbin"
        # "/bin"
        # "/usr/bin"
      ];

      packages = pkgs.callPackage ./packages.nix { };

      file = {
        # TODO: how to make directories?
        # ".ssh/control/.keep".text = "";
        # "Screenshots/.keep".text = "";
        # "projects/${user}/.keep".text = "";
        # "bin/.keep".text = "";

        ".swiftformat".text = builtins.readFile ./files/.swiftformat;
        ".swiftlint.yml".text = builtins.readFile ./files/.swiftlint.yml;
        ".mongorc.js".text = builtins.readFile ./files/.mongorc.js;
        ".vim/ftdetect/toml.vim".text = "autocmd BufNewFile,BufRead *.toml set filetype=toml";

        # TODO: if personal
        ".config/borgmatic/config.yaml".source = pkgs.substituteAll {
          name = "config.yaml";
          src = ./files/borgmatic/config.yaml;
          secret = "${private.borgSecret}";
          repo = "${private.borgRepo}";
        };

        "nix-bin".source = config.lib.file.mkOutOfStoreSymlink ./bin;
      };

      shellAliases = {
        cdgo = "cd $GOPATH/src";
        cdproj = "cd $HOME/projects/sheeley";
        cdinfra = "cd $PRIVATE_TOOLS_DIR";
        cdtools = "cd $TOOLS_DIR";
        cdnotes = "cd $NOTES_DIR";
        cdicloud = "cd ~/Library/Mobile\ Documents/com~apple~CloudDocs";
        dotfiles = "cd ~/dotfiles";
        clone = "git clone";
      };
    };
  };
}
