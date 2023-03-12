{ config, pkgs, lib, ... }:
let
  private = pkgs.callPackage ~/.nix-private/private.nix { };
  user = "sheeley";
in
{
  imports = [
    ./dock.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # verbose = true;
  };

  home-manager.users.${user} = { config, lib, pkgs, ... }: {
    programs.bash.enable = true;
    programs.zsh.enable = true;
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
        PRIVATE_CMD_DIR = "$HOME/projects/sheeley/infrastructure/cmd";
        PRIVATE_DATA_DIR = "$HOME/projects/sheeley/infrastructure/data";
        PRIVATE_TOOLS_DIR = "$HOME/projects/sheeley/infrastructure";
        TOOLS_DIR = "$HOME/projects/sheeley/tools";
        NOTES_DIR = "$HOME/projects/sheeley/notes";
        GITHUB_TOKEN = "${private.githubSecret}";
      };

      sessionPath = [
        "$HOME/bin"
        "$HOME/projects/sheeley/infrastructure/bin"
        "$HOME/projects/sheeley/infrastructure/scripts"
        "$HOME/go/bin"
        "$HOME/.cargo/bin"

        "/etc/profiles/per-user/sheeley/bin/"

        "/opt/homebrew/bin"
        "/Applications/Xcode.app/Contents/Developer/usr/bin"

        "/sbin"
        "/usr/sbin"
        "/bin"
        "/usr/bin"
      ];

      packages = pkgs.callPackage ./packages.nix { };

      file = {
        ".ssh/control/.keep".text = "";
        "Screenshots/.keep".text = "";
        "projects/sheeley/.keep".text = "";

        ".swiftformat".text = builtins.readFile ./files/.swiftformat;
        ".swiftlint.yml".text = builtins.readFile ./files/.swiftlint.yml;
        ".mongorc.js".text = builtins.readFile ./files/.mongorc.js;
        ".vim/ftdetect/toml.vim".text = "autocmd BufNewFile,BufRead *.toml set filetype=toml";

        ".config/borgmatic/config.yaml".source = pkgs.substituteAll {
          name = "config.yaml";
          src = ./files/borgmatic/config.yaml;
          secret = "${private.borgSecret}";
          repo = "${private.borgRepo}";
        };

        "bin".source = config.lib.file.mkOutOfStoreSymlink ./bin;
      };
    };
  };
}
