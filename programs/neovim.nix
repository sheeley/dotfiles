{ pkgs
, inputs
, config
, helpers
, ...
}: {

  # nixvim.homeManagerModules.nixvim
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
      termguicolors = true;
      number = true;
      tabstop = 4;
      shiftwidth = 4;
      scrolloff = 7;
      signcolumn = "yes";
      cmdheight = 2;
      cot = [ "menu" "menuone" "noselect" ];
      updatetime = 100;
      colorcolumn = "100";
      spell = true;
    };

    # commands = {
    #   "SpellFr" = "setlocal spelllang=fr";
    # };

    # filetype = {
    #   filename = {
    #     Jenkinsfile = "groovy";
    #   };
    #   extension = {
    #     lalrpop = "lalrpop";
    #   };
    # };

    # maps.normal = helpers.mkModeMaps {silent = true;} {
    #   "ft" = "<cmd>Neotree<CR>";
    #   "fG" = "<cmd>Neotree git_status<CR>";
    #   "fR" = "<cmd>Neotree remote<CR>";
    #   "fc" = "<cmd>Neotree close<CR>";
    #   "bp" = "<cmd>Telescope buffers<CR>";

    #   "<C-s>" = "<cmd>Telescope spell_suggest<CR>";
    #   "mk" = "<cmd>Telescope keymaps<CR>";
    #   "fg" = "<cmd>Telescope git_files<CR>";

    #   "gr" = "<cmd>Telescope lsp_references<CR>";
    #   "gI" = "<cmd>Telescope lsp_implementations<CR>";
    #   "gW" = "<cmd>Telescope lsp_workspace_symbols<CR>";
    #   "gF" = "<cmd>Telescope lsp_document_symbols<CR>";
    #   "ge" = "<cmd>Telescope diagnostics bufnr=0<CR>";
    #   "gE" = "<cmd>Telescope diagnostics<CR>";

    #   "<leader>rn" = {
    #     action = ''
    #       function()
    #       	return ":IncRename " .. vim.fn.expand("<cword>")
    #       end
    #     '';
    #     lua = true;
    #     expr = true;
    #   };
    # };

    # plugins.nvim-osc52 = {
    #   enable = true;
    #   package = pkgs.vimPlugins.nvim-osc52;
    #   keymaps.enable = true;
    # };
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
          #gitsigns.enable = true;
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
    plugins.gitsigns.enable = true;
    plugins.gitmessenger.enable = true;

    # plugins.firenvim.enable = false;

    plugins.luasnip = {
      enable = true;
    };

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

      # grammarPackages = with config.plugins.treesitter.package.passthru.builtGrammars; [
      #   arduino
      #   bash
      #   c
      #   cpp
      #   cuda
      #   dart
      #   devicetree
      #   diff
      #   dockerfile
      #   gitattributes
      #   gitcommit
      #   gitignore
      #   git_rebase
      #   help
      #   html
      #   ini
      #   json
      #   lalrpop
      #   latex
      #   lua
      #   make
      #   markdown
      #   markdown_inline
      #   meson
      #   ninja
      #   nix
      #   python
      #   regex
      #   rst
      #   rust
      #   slint
      #   sql
      #   tlaplus
      #   toml
      #   vim
      #   yaml
      # ];
    };

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
    # plugins.headerguard.enable = true;

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
        nil_ls = {
          enable = true;
          settings = {
            formatting.command = [ "alejandra" "--quiet" ];
          };
        };
        bashls.enable = true;
        dartls.enable = true;
      };
    };

    plugins.rust-tools = {
      enable = true;
      inlayHints = {
        maxLenAlign = true;
      };

      server = {
        cargo.features = "all";
        checkOnSave = true;
        check.command = "clippy";
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

    # plugins.lsp_signature = {
    #   #enable = true;
    # };

    plugins.inc-rename = {
      enable = true;
    };

    plugins.clangd-extensions = {
      enable = true;
      enableOffsetEncodingWorkaround = true;

      extensions.ast = {
        roleIcons = {
          type = "";
          declaration = "";
          expression = "";
          specifier = "";
          statement = "";
          templateArgument = "";
        };
        kindIcons = {
          compound = "";
          recovery = "";
          translationUnit = "";
          packExpansion = "";
          templateTypeParm = "";
          templateTemplateParm = "";
          templateParamObject = "";
        };
      };
    };

    # fidget = {
    #   enable = true;
    #
    #   sources.null-ls.ignore = true;
    # };

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

    # plugins.netman = {
    #   enable = true;
    #   package = pkgs.vimPlugins.netman-nvim;
    #   neoTreeIntegration = true;
    # };

    extraConfigLuaPost = ''
      require("luasnip.loaders.from_snipmate").lazy_load()
    '';

    extraPlugins = with pkgs.vimPlugins; [
      telescope-ui-select-nvim
      vim-snippets
      markdown-preview-nvim
    ];






    # maps = { };
    # plugins.lightline.enable = true;

    #     	" this will echo commands as setting them for debugging:
    # 	" :set verbose=9

    # " Important!!
    # if has('termguicolors')
    # set termguicolors
    # endif
    # " The configuration options should be placed before `colorscheme sonokai`.
    # let g:sonokai_style = 'andromeda'
    # let g:sonokai_better_performance = 1
    # colorscheme sonokai

    # if &shell =~# 'fish$'
    # 	set shell=zsh
    # endif

    # set lazyredraw
    # " Turn persistent undo on
    # " means that you can undo even when you close a buffer/VIM
    # try
    # 	set undodir=$HOME/.nvim/undodir
    # 	set undofile
    # catch
    # endtry

    # " prevent gutter (git, checks, etc) from hiding when there's no content
    # set signcolumn=yes

    # " time to respond
    # set timeoutlen=500

    # " windows {{{
    # " automatically create a split if none doesn't exist, otherwise navigate in
    # " the direction
    # noremap <C-j> <C-w>j
    # noremap <C-k> <C-w>k
    # noremap <C-h> <C-w>h
    # nnoremap <expr> <C-l> winnr('l') == winnr() ? ':vsp<CR>' : '<C-w>l'
    # " nnoremap <expr> <C-k> winnr('k') == '1' ? ':sp<CR>' : '<C-w>k'
    # " }}}

    # " Key mappings {{{
    # " run current file
    # nnoremap <leader>r :!%:p<Enter>
    # imap ;; <Esc>
    # " TODO: (un)indent with Tab
    # " nmap <Tab> <C-t>
    # " nmap <S-Tab> <C-d>
    # " }}} end Key mappings

    # " folding {{{
    # set foldmethod=syntax
    # nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
    # vnoremap <Space> zf
    # " }}} folding

    # " line numbering {{{
    # " turn hybrid numbers on, automatically toggle on type
    # set number relativenumber
    # augroup numbertoggle
    # 	autocmd!
    # 	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    # 	autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    # augroup END
    # " }}} end line numbering

    # " File types {{{
    # augroup filetypes
    # 	" this will echo commands as setting them for debugging:
    # 	" :set verbose=9
    # 	autocmd!

    # 	" fish
    # 	" Set up :make to use fish for syntax checking.
    # 	autocmd FileType compiler fish

    # 	" toml
    # 	autocmd FileType toml setlocal commentstring=#\ %s

    # augroup end
    # " }}} end Files

    # " clap {{{
    # let g:clap_insert_mode_only = 1 " close clap on first esc
    # " }}} end clap

    # " go {{{
    # " let g:go_fmt_experimental = 1
    # let g:go_fmt_command='gopls'
    # " }}}

    # " python-mode {{{
    # let g:pep8_ignore='E501'
    # let g:pymode_lint_ignore = ['E501', 'W',]
    # " }}} end python-mode

    # " ale {{{
    # " let g:ale_set_quickfix = 1
    # " let g:ale_set_highlight = 1
    # " " highlight ALEWarning ctermbg=DarkMagenta
    # " let g:ale_sign_column_always = 1
    # " let g:ale_fix_on_save = 1
    # " let g:ale_change_sign_column_color = 1
    # " let g:ale_echo_msg_error_str = 'E'
    # " let g:ale_echo_msg_warning_str = 'W'
    # " let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
    # " let g:ale_open_list = 1
    # " :call extend(g:ale_linters, {
    # "   \    'css': ['eslint', 'prettier'],
    # "   \    'javascript': ['eslint', 'prettier'],
    # "   \    'json': ['jsonlint'],
    # "   \    'markdown': ['remark-lint'],
    # "   \    'python': [],
    # "   \    'rust': ['rls', 'rustfmt'],
    # "   \    'scala': [],
    # "   \    'sh': ['language_server', 'shellcheck'],
    # "   \    'sql': ['sqlint'],
    # "   \    'swift': ['swiftformat'],
    # "   \    'vim': ['vint']
    # "   \})
    # " 
    # " :call extend(g:ale_fixers, {
    # "   \    'css': ['prettier', 'eslint'],
    # "   \    'javascript': ['prettier', 'eslint', 'jq'],
    # "   \    'json': ['prettier', 'eslint', 'jq'],
    # "   \    'markdown': ['remark-lint'],
    # "   \    'python': ['isort', 'black'],
    # "   \    'rust': ['rustfmt'],
    # "   \    'scala': ['scalafmt'],
    # "   \    'sh': ['shfmt'],
    # "   \    'sql': ['sqlformat'],
    # "   \    'swift': ['swiftformat'],
    # "   \    '*': ['remove_trailing_lines', 'trim_whitespace']
    # "   \})
    # " 
    # " let g:vim_swift_format_use_ale = 1
    # " " }}}

    # " " coc {{{
    # " let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-pyright', 'coc-markdownlint',
    # " 			\ 'coc-go', 'coc-css', 'coc-highlight', 'coc-sh', 'coc-sql', 'coc-prettier',
    # " 			\ 'coc-yaml', 'coc-toml', 'coc-tsserver', 'coc-pairs']
    # " 
    # " " Set internal encoding of vim, not needed on neovim, since coc.nvim using some
    # " " unicode characters in the file autoload/float.vim
    # " set encoding=utf-8
    # " 
    # " " TextEdit might fail if hidden is not set.
    # " set hidden
    # " 
    # " " Give more space for displaying messages.
    # " set cmdheight=2
    # " 
    # " " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    # " " delays and poor user experience.
    # " set updatetime=300
    # " 
    # " " Don't pass messages to |ins-completion-menu|.
    # " set shortmess+=c
    # " 
    # " " Always show the signcolumn, otherwise it would shift the text each time
    # " " diagnostics appear/become resolved.
    # " if has('patch-8.1.1564')
    # " 	" Recently vim can merge signcolumn and number column into one
    # " 	set signcolumn=number
    # " else
    # " 	set signcolumn=yes
    # " endif
    # " 
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
    # " 
    # " " Use `[g` and `]g` to navigate diagnostics
    # " " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    # " nmap <silent> [g <Plug>(coc-diagnostic-prev)
    # " nmap <silent> ]g <Plug>(coc-diagnostic-next)
    # " 
    # " " GoTo code navigation.
    # " nmap <silent> gd <Plug>(coc-definition)
    # " nmap <silent> gy <Plug>(coc-type-definition)
    # " nmap <silent> gi <Plug>(coc-implementation)
    # " nmap <silent> gr <Plug>(coc-references)
    # " 
    # " " Use K to show documentation in preview window.
    # " nnoremap <silent> K :call <SID>show_documentation()<CR>
    # " 
    # " function! s:show_documentation()
    # " 	if (index(['vim','help'], &filetype) >= 0)
    # " 		execute 'h '.expand('<cword>')
    # " 	elseif (coc#rpc#ready())
    # " 		call CocActionAsync('doHover')
    # " 	else
    # " 		execute '!' . &keywordprg . ' ' . expand('<cword>')
    # " 	endif
    # " endfunction
    # " 
    # " " Symbol renaming.
    # " nmap <leader>rn <Plug>(coc-rename)
    # " 
    # " " Formatting selected code.
    # " xmap <leader>f  <Plug>(coc-format-selected)
    # " nmap <leader>f  <Plug>(coc-format-selected)
    # " 
    # " augroup coc
    # " 	autocmd!
    # " 	" Setup formatexpr specified filetype(s).
    # " 	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    # " 	" Update signature help on jump placeholder.
    # " 	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    # " 
    # "     " Highlight the symbol and its references when holding the cursor.
    # "     autocmd CursorHold * silent call CocActionAsync('highlight')
    # " augroup end
    # " 
    # " " Applying codeAction to the selected region.
    # " " Example: `<leader>aap` for current paragraph
    # " xmap <leader>a  <Plug>(coc-codeaction-selected)
    # " nmap <leader>a  <Plug>(coc-codeaction-selected)
    # " 
    # " " Remap keys for applying codeAction to the current buffer.
    # " nmap <leader>ac  <Plug>(coc-codeaction)
    # " " Apply AutoFix to problem on the current line.
    # " nmap <leader>qf  <Plug>(coc-fix-current)
    # " 
    # " " Map function and class text objects
    # " " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    # " xmap if <Plug>(coc-funcobj-i)
    # " omap if <Plug>(coc-funcobj-i)
    # " xmap af <Plug>(coc-funcobj-a)
    # " omap af <Plug>(coc-funcobj-a)
    # " xmap ic <Plug>(coc-classobj-i)
    # " omap ic <Plug>(coc-classobj-i)
    # " xmap ac <Plug>(coc-classobj-a)
    # " omap ac <Plug>(coc-classobj-a)
    # " 
    # " " Remap <C-f> and <C-b> for scroll float windows/popups.
    # " if has('nvim-0.4.0') || has('patch-8.2.0750')
    # " 	nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    # " 	nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    # " 	inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    # " 	inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    # " 	vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    # " 	vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    # " endif
    # " 
    # " " Use CTRL-S for selections ranges.
    # " " Requires 'textDocument/selectionRange' support of language server.
    # " nmap <silent> <C-s> <Plug>(coc-range-select)
    # " xmap <silent> <C-s> <Plug>(coc-range-select)
    # " 
    # " " Add `:Format` command to format current buffer.
    # " command! -nargs=0 Format :call CocAction('format')
    # " 
    # " " Add `:Fold` command to fold current buffer.
    # " command! -nargs=? Fold :call     CocAction('fold', <f-args>)
    # " 
    # " " Add `:OR` command for organize imports of the current buffer.
    # " command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
    # " 
    # " " Add (Neo)Vim's native statusline support.
    # " " NOTE: Please see `:h coc-status` for integrations with external plugins that
    # " " provide custom statusline: lightline.vim, vim-airline.
    # " set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
    # " 
    # " " Mappings for CoCList
    # " " Show all diagnostics.
    # " nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
    # " " Manage extensions.
    # " nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
    # " " Show commands.
    # " nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
    # " " Find symbol of current document.
    # " nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
    # " " Search workspace symbols.
    # " nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
    # " " Do default action for next item.
    # " nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
    # " " Do default action for previous item.
    # " nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
    # " " Resume latest coc list.
    # " nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
    # " " }}} end coc

  };

  programs.neovim = {
    enable = false;
    # defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # extraConfig = builtins.readFile ../files/nvim/local_init.vim;

    coc = {
      enable = false;
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
      # coc-sh
      # coc-go
      # coc-yaml
      # coc-json
      # coc-prettier

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
