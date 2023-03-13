{ config, pkgs, lib, ... }:
let
  private = pkgs.callPackage ~/.nix-private/private.nix { };
  user = "johnnysheeley";
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
        PRIVATE_CMD_DIR = "$HOME/projects/${user}/infrastructure/cmd";
        PRIVATE_DATA_DIR = "$HOME/projects/${user}/infrastructure/data";
        PRIVATE_TOOLS_DIR = "$HOME/projects/${user}/infrastructure";
        TOOLS_DIR = "$HOME/projects/${user}/tools";
        NOTES_DIR = "$HOME/projects/${user}/notes";
        GITHUB_TOKEN = "${private.githubSecret}";
        EDITOR = "nvim";
      };

      sessionPath = [
        "$HOME/bin"
        "$HOME/projects/${user}/infrastructure/bin"
        "$HOME/projects/${user}/infrastructure/scripts"
        "$HOME/go/bin"
        "$HOME/.cargo/bin"

        "/etc/profiles/per-user/${user}/bin/"

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
        "projects/${user}/.keep".text = "";

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

        "bin".source = config.lib.file.mkOutOfStoreSymlink ./bin;
      };
    };
  };
}
