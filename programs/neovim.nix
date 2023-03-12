{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    # defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ../files/nvim/local_init.vim;

    coc = {
      enable = true;
      # settings = {
      #   "suggest.noselect" = true;
      #   "suggest.enablePreview" = true;
      #   "suggest.enablePreselect" = false;
      #   "suggest.disableKind" = true;
      #   "diagnostic.displayByAle" = true;
      #   "coc.preferences.formatOnSaveFiletypes" = [
      #     "css"
      #     "markdown"
      #     "javascript"
      #     "typescript"
      #     "javascriptreact"
      #     "typescriptreact"
      #     "json"
      #     "python"
      #     "go"
      #     "yaml"
      #     "sh"
      #     "toml"
      #     "fish"
      #     "swift"
      #   ];
      #   "diagnostic.checkCurrentLine" = true;
      #   "languageserver" = {
      #     "swift" = {
      #       "command" = "sourcekit-lsp";
      #       "args" = [ ];
      #       "filetypes" = [
      #         "swift"
      #       ];
      #     };
      #   };
      # };
    };


    extraPackages = with pkgs; [
      shfmt
      yaml-language-server
      nodePackages.bash-language-server
      rnix-lsp
      nil
      pyright
      python310Packages.python-lsp-server
      # flake8
      # pycodestyle
      python310Packages.autopep8
    ];

    plugins = with pkgs.vimPlugins; [
      coc-sh
      coc-go
      coc-yaml
      coc-json
      coc-prettier

      vim-sensible
      vim-easymotion
      vim-clap

      # languages
      vim-nix
      vim-fish
      vim-shellcheck
      vim-terraform
      editorconfig-vim

      # theme
      sonokai




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
}
