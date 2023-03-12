{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    # defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ../files/nvim/local_init.vim;

    coc = {
      enable = true;
      settings = builtins.readFile ../files/nvim/coc-settings.json;
    };

    extraPackages = with pkgs; [
      shfmt
    ];

    plugins = with pkgs.vimPlugins; [
      vim-sensible
      vim-easymotion
      vim-clap

      # languages
      vim-nix
      vim-fish
      vim-shellcheck
      vim-terraform
      editorconfig-vim

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
