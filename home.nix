{ config
, pkgs
, lib
, user
, inputs
, # private,
  ...
}:
let
  # private = inputs.private {};
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

  home-manager.users.${user} =
    { config
    , lib
    , pkgs
    , ...
    }: {
      programs.bash.enable = true;
      programs.home-manager.enable = true;

      imports = [
        inputs.nixvim.homeManagerModules.nixvim

        ./programs/fish.nix
        ./programs/general.nix
        ./programs/git.nix
        ./programs/gitui.nix
        ./programs/helix.nix
        ./programs/neovim.nix
        ./programs/ssh.nix
        ./programs/starship.nix
        ./programs/vscode.nix
        ./programs/zsh.nix
      ] ++ (lib.optionals private.personal [
        ./programs/borgmatic.nix
      ]);

      home = {
        stateVersion = "22.05";

        sessionVariables = {
          WORKMACHINE = "false";
          GOPROXY = "direct";
          GOSUMDB = "off";
          LESS = "-R";
          BORG_REPO = "/Volumes/money/borgbackup";
          GOPATH = toString ~/go;
          DOTFILES_DIR = toString ~/dotfiles;
          PRIVATE_CMD_DIR = toString ~/projects/sheeley/infrastructure/cmd;
          PRIVATE_DATA_DIR = toString ~/projects/sheeley/infrastructure/data;
          PRIVATE_TOOLS_DIR = toString ~/projects/sheeley/infrastructure;
          TOOLS_DIR = toString ~/projects/sheeley/tool;
          NOTES_DIR = toString ~/projects/sheeley/notes;
          GITHUB_TOKEN = "${private.githubSecret}";
          EDITOR = "nvim";
        };

        # this sometimes doesn't work with fish
        # https://github.com/LnL7/nix-darwin/issues/122
        sessionPath = [
          "$HOME/bin"
          "$HOME/dotfiles/bin"

          "$HOME/projects/sheeley/infrastructure/bin"
          "$HOME/projects/sheeley/infrastructure/scripts"
          "$HOME/go/bin"
          "$HOME/.cargo/bin"
          "$HOME/non-nix-bin"

          "/opt/homebrew/bin"
          "/Applications/Xcode.app/Contents/Developer/usr/bin"
        ];

        packages = pkgs.callPackage ./packages.nix { };

        file = {
          ".mongorc.js".text = builtins.readFile ./files/.mongorc.js;
          ".swiftformat".text = builtins.readFile ./files/.swiftformat;
          ".swiftlint.yml".text = builtins.readFile ./files/.swiftlint.yml;
          ".vim/ftdetect/toml.vim".text = "autocmd BufNewFile,BufRead *.toml set filetype=toml";
        };

        shellAliases = {
          cat = "bat";
          cdgo = "cd $GOPATH/src";
          cdicloud = "cd ~/Library/Mobile\ Documents/com~apple~CloudDocs";
          cdinfra = "cd $PRIVATE_TOOLS_DIR";
          cdnotes = "cd $NOTES_DIR";
          cdproj = "cd $HOME/projects/sheeley";
          cdtools = "cd $TOOLS_DIR";
          clone = "git clone";
          cddot = "cd ~/dotfiles";
          cdscratch = "cd ~/scratch";
          la = "ls -la";
        };
      };
    };
}
