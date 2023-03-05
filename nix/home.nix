{ pkgs, ... }:
{
  imports = [
    # <home-manager/nix-darwin>
    ./dock
  ];

  local.dock.enable = true;
  local.dock.entries = [
    { path = "/Applications/iTerm.app/"; }
    { path = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"; }
    { path = "/System/Applications/Mail.app/"; }
    { path = "/System/Applications/Calendar.app/"; }
    { path = "/System/Applications/Messages.app/"; }
    { path = "/System/Applications/Reminders.app/"; }
    { path = "/Applications/Obsidian.app/"; }
    { path = "/System/Applications/Music.app/"; }
    { path = "/Applications/Slack.app/"; }

    {
      path = "/Applications";
      section = "others";
      options = "--sort name --view grid --display folder";
    }
    {
      path = "/Users/sheeley/Downloads";
      section = "others";
      options = "--sort dateadded --view fan --display stack";
    }
    {
      path = "/Users/sheeley/Screenshots";
      section = "others";
      options = "--sort dateadded --view fan --display stack";
    }
  ];

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
        EDITOR = "nvim";
      };

      sessionPath = [
        "$HOME/bin"
        "$HOME/projects/sheeley/infrastructure/bin"
        "$HOME/projects/sheeley/infrastructure/scripts"
        # "/run/current-system/sw/bin"
        "$HOME/go/bin"
        "$HOME/.cargo/bin"
        # "/opt/homebrew/bin"
        # "/opt/homebrew/sbin"
        "/usr/local/bin"
        "/usr/local/sbin"
        "/Applications/Xcode.app/Contents/Developer/usr/bin"
        "/sbin"
        "/usr/sbin"
        "/bin"
        "/usr/bin"
      ];

      packages = pkgs.callPackage ./packages.nix { };
    };

    programs.fish = {
      enable = true;
      interactiveShellInit = builtins.readFile ./init.fish;
    };

    programs.neovim = {
      enable = true;
      extraConfig = builtins.readFile ../dot_config/nvim/local_init.vim;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs; [
        vimPlugins.vim-sensible
        vimPlugins.vim-easymotion
        vimPlugins.vim-clap

        # languages
        vimPlugins.vim-fish
        vimPlugins.vim-shellcheck
        vimPlugins.vim-terraform
        vimPlugins.editorconfig-vim



        # Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
        # Plug 'neoclide/coc.nvim', {'branch': 'release'}
        # Plug 'jremmen/vim-ripgrep'
        # Plug 'stefandtw/quickfix-reflector.vim'

        # " languages
        # Plug 'hashivim/vim-terraform', { 'for': 'tf' }
        # Plug 'itspriddle/vim-shellcheck'
        # Plug 'dag/vim-fish', { 'for': 'fish' }
        # Plug 'editorconfig/editorconfig-vim', { 'for': 'editorconfig' }
        # Plug 'keith/swift.vim'
        # Plug 'junegunn/vim-easy-align'
        # Plug 'ron-rs/ron.vim'
      ];
    };
  };
}
