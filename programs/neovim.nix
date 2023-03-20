{ pkgs
, inputs
, config
, helpers
, ...
}: {

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.tokyonight = {
      style = "night";
      enable = true;
    };

    globals = {
      neo_tree_remove_legacy_commands = 1;
    };

    options = {
      cmdheight = 2;
      colorcolumn = "100";
      cot = [ "menu" "menuone" "noselect" ];
      foldmethod = "syntax";
      hidden = true;
      number = true;
      scrolloff = 7;
      shiftwidth = 4;
      signcolumn = "yes";
      spell = true;
      tabstop = 4;
      termguicolors = true;
      undodir = ~/.nvim/undodir;
      undofile = true;
      updatetime = 100;
      shortmess = "c";
      shell = "${pkgs.zsh}/bin/zsh";
      # can't use this with noice
      # lazyredraw = true; 
    };

    plugins.nix = {
      enable = true;
    };

    autoCmd = [
      {
        event = [ "BufWritePre" ];
        command = "lua vim.lsp.buf.formatting_sync()";
      }
      {
        event = [ "BufEnter" "FocusGained" "InsertLeave" ];
        command = "set relativenumber";
        group = "numberToggle";
      }
      {
        event = [ "BufLeave" "FocusLost" "InsertEnter" ];
        command = "set norelativenumber";
        group = "numberToggle";
      }
    ];

    autoGroups = {
      numberToggle = {
        clear = true;
      };
    };

    maps = {
      insert = {
        ";;" = "<Esc>";
      };
      visual = {
        # TODO: folding
        # "<Space>" = "zf"; #folding
      };
      normal = {
        # (un)indent with Tab
        "<Tab>" = "<C-t>";
        "<S-Tab>" = "<C-d>";
        # TODO: folding
        # "<Space>" = {
        #   silent = true;
        #   command = "@=(foldlevel('.')?'za':\"\<Space>\")<CR>";
        # };

        # windows
        # automatically create a split if none doesn't exist, otherwise navigate in
        # TODO: these do not work.
        # "<C-j>" = { 
        #   command = "<C-w>j"; # noremap <C-j> <C-w>j
        #   remap = true;
        #   };
        # "<C-k>" = { 
        #   command = "<C-w>k"; # noremap <C-k> <C-w>k
        #   remap = true;
        #   };
        # "<C-h>" = { 
        #   command = "<C-w>h"; # noremap <C-h> <C-w>h
        #   remap = true;
        #   };
        # "<expr>" ={ 
        #   command =  "<C-l> winnr('l') == winnr() ? ':vsp<CR>' : '<C-w>l'"; # nnoremap <expr> <C-l> winnr('l') == winnr() ? ':vsp<CR>' : '<C-w>l'
        #   remap = true;
        #   };
        # this one is separate 
        # "<expr>" = "<C-k> winnr('k') == '1' ? ':sp<CR>' : '<C-w>k'"; # nnoremap <expr> <C-k> winnr('k') == '1' ? ':sp<CR>' : '<C-w>k'
      };
    };

    plugins.null-ls = {
      enable = true;
      sources = {
        diagnostics = {
          shellcheck.enable = true;
          cppcheck.enable = true;
          gitlint.enable = true;
        };
        code_actions = {
          shellcheck.enable = true;
        };
        formatting = {
          alejandra.enable = true;
          black.enable = true;
          stylua.enable = true;
          cbfmt.enable = true;
          shfmt.enable = true;
          taplo.enable = true;
          prettier.enable = true;
        };
      };
    };

    plugins.luasnip = {
      enable = true;
    };
    extraConfigLuaPost = ''
      require("luasnip.loaders.from_snipmate").lazy_load()
    '';

    extraConfigLuaPre = ''
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local luasnip = require("luasnip")
    '';

    plugins.nvim-cmp = {
      enable = true;

      snippet.expand = "luasnip";

      mapping = {
        "<CR>" = "cmp.mapping.confirm({select = true })";
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<Tab>" = ''
          cmp.mapping(function(fallback)
          if cmp.visible() then
          cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
          elseif has_words_before() then
          cmp.complete()
          else
          fallback()
          end
          end, { "i", "s" })
        '';
        "<S-Tab>" = ''
          cmp.mapping(function(fallback)
          if cmp.visible() then
          cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
          else
          fallback()
          end
          end, { "i", "s" })
        '';
        "<Down>" = "cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'})";
        "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'})";
      };

      sources = [
        { name = "luasnip"; }
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "calc"; }
      ];
    };

    plugins.telescope = {
      enable = true;
      enabledExtensions = [ "ui-select" ];
      extensionConfig = {
        ui-select = {
          __raw = ''
            require("telescope.themes").get_dropdown {
              -- even more opts
            }
          '';
        };
      };
    };

    plugins.treesitter = {
      enable = true;
      indent = true;

      grammarPackages = with config.programs.nixvim.plugins.treesitter.package.passthru.builtGrammars; [
        arduino
        bash
        c
        cpp
        cuda
        dart
        devicetree
        diff
        dockerfile
        gitattributes
        gitignore
        git_rebase
        help
        html
        json
        markdown
        markdown_inline
        nix
        python
        regex
        toml
        vim
        yaml
      ];
    };

    # TODO: completion
    # " " Use tab for trigger completion with characters ahead and navigate.
    # " " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    # " " other plugin before putting this into your config.
    # " inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()
    # " inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    # " 
    # " function! s:check_back_space() abort
    # " 	let col = col('.') - 1
    # " 	return !col || getline('.')[col - 1]  =~# '\s'
    # " endfunction
    # " 
    # " " Use <c-space> to trigger completion.
    # " if has('nvim')
    # " 	inoremap <silent><expr> <c-space> coc#refresh()
    # " else
    # " 	inoremap <silent><expr> <c-@> coc#refresh()
    # " endif
    # " 
    # " " Make <CR> auto-select the first completion item and notify coc.nvim to
    # " " format on enter, <cr> could be remapped by other vim plugin
    # " inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    plugins.treesitter-refactor = {
      enable = true;
      highlightDefinitions = {
        enable = true;
        clearOnCursorMove = true;
      };
      smartRename = {
        enable = true;
      };
      navigation = {
        enable = true;
      };
    };

    plugins.treesitter-context = {
      enable = true;
    };

    plugins.vim-matchup = {
      treesitterIntegration = {
        enable = true;
        includeMatchWords = true;
      };
      enable = true;
    };

    plugins.comment-nvim = {
      enable = true;
    };

    plugins.neo-tree = {
      enable = true;
    };

    plugins.plantuml-syntax.enable = true;

    plugins.indent-blankline = {
      enable = true;

      useTreesitter = true;

      showCurrentContext = true;
      showCurrentContextStart = true;
    };

    plugins.lsp = {
      enable = true;

      keymaps = {
        silent = true;

        lspBuf = {
          "gd" = "definition";
          "gD" = "declaration";
          "ca" = "code_action";
          "ff" = "format";
          "K" = "hover";
        };
      };

      servers = {
        # nil_ls = {
        #   enable = true;
        #   settings = {
        #     formatting.command = [ "alejandra" "--quiet" ];
          # };
        # };
        bashls.enable = true;
        dartls.enable = true;
      };
    };

    plugins.lspkind = {
      enable = true;
      cmp = {
        enable = true;
      };
    };

    plugins.nvim-lightbulb = {
      enable = true;
      autocmd.enabled = true;
    };

    plugins.inc-rename = {
      enable = true;
    };

    plugins.lualine = {
      enable = true;
    };

    plugins.trouble = {
      enable = true;
    };

    plugins.noice = {
      enable = true;

      messages = {
        view = "mini";
        viewError = "mini";
        viewWarn = "mini";
      };

      lsp.override = {
        "vim.lsp.util.convert_input_to_markdown_lines" = true;
        "vim.lsp.util.stylize_markdown" = true;
        "cmp.entry.get_documentation" = true;
      };

      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = true;
        lsp_doc_border = false;
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      editorconfig-nvim
      ron-vim
      telescope-ui-select-nvim
      vim-clap
      vim-fish
      vim-nix
      vim-prettier
      vim-sensible
      vim-shellcheck
      vim-terraform

      # TODO: more vim plugins
      #   # Plug 'jremmen/vim-ripgrep'
      #   # Plug 'keith/swift.vim'
    ];

    extraPackages = with pkgs; [
      shfmt
      yaml-language-server
      nodePackages.bash-language-server
      rnix-lsp
      nil
      pyright
      python310Packages.python-lsp-server
      python310Packages.flake8
      python310Packages.autopep8
    ];
  };
}
