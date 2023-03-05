{ pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.sheeley = { pkgs, ... }: {
    programs.bash.enable = true;
    programs.zsh.enable = true;
    programs.home-manager.enable = true;

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
      };

      sessionPath = [
        "$HOME/bin"
        "$HOME/projects/sheeley/infrastructure/bin"
        "$HOME/projects/sheeley/infrastructure/scripts"
        "/run/current-system/sw/bin"
        "$HOME/go/bin"
        "$HOME/.cargo/bin"
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        "/usr/local/bin"
        "/usr/local/sbin"
        "/Applications/Xcode.app/Contents/Developer/usr/bin"
        "/sbin"
        "/usr/sbin"
        "/bin"
        "/usr/bin"
      ];

      packages = with pkgs; [
        pkgs._1password
        # pkgs._1password-gui
        pkgs.atool
        pkgs.bat
        pkgs.broot
        pkgs.chezmoi
        pkgs.coreutils-prefixed
        pkgs.du-dust
        pkgs.duf
        pkgs.entr
        pkgs.fd
        pkgs.fish
        pkgs.fzf
        pkgs.git
        pkgs.gitui
        pkgs.go
        pkgs.gron
        pkgs.jid
        pkgs.jq
        pkgs.neovim
        pkgs.nerdfonts
        pkgs.nixpkgs-fmt
        pkgs.pv
        pkgs.python311
        pkgs.rclone
        pkgs.ripgrep
        pkgs.rsync
        pkgs.shellcheck
        pkgs.shfmt
        pkgs.silver-searcher
        pkgs.ssh-copy-id
        pkgs.starship
        pkgs.tldr
        pkgs.vim-vint
        pkgs.vscode
        pkgs.wget
        fishPlugins.done
        # fishPlugins.fzf-fish
        # fishPlugins.forgit
      ];

      #   programs.git = {
      #   enable = true;
      #   includes = [{ path = "~/.config/nixpkgs/gitconfig"; }];
      # };
    };
  };
}
