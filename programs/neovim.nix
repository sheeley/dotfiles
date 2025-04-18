{
  pkgs,
  # inputs,
  config,
  # user,
  # helpers,
  # vimUtils,
  # fetchFromGitHub,
  ...
}: let
  vim-ripgrep = pkgs.vimUtils.buildVimPlugin {
    name = "vim-ripgrep-2021-11-30";
    src = pkgs.fetchFromGitHub {
      owner = "jremmen";
      repo = "vim-ripgrep";
      rev = "2bb2425387b449a0cd65a54ceb85e123d7a320b8";
      sha256 = "sha256-OvQPTEiXOHI0uz0+6AVTxyJ/TUMg6kd3BYTAbnCI7W8=";
    };
    dependencies = [];
  };
  vim-swift = pkgs.vimUtils.buildVimPlugin {
    name = "vim-swift";
    src = pkgs.fetchFromGitHub {
      owner = "keith";
      repo = "swift.vim";
      rev = "ba6f6cef58d08ac741aaf1626d3799d476cd43b6";
      sha256 = "sha256-A91OR+54Uie9i0nlfuIuh2JTMNyJ9rtABoJAvOefS2w=";
    };
    dependencies = [];
  };
in {
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.tokyonight = {
      settings = {
        style = "night";
      };
      enable = true;
    };

    globals = {
      neo_tree_remove_legacy_commands = 1;
    };

    opts = {
      cmdheight = 2;
      clipboard = "unnamed";
      cot = ["menu" "menuone" "noselect"];
      foldmethod = "syntax";
      foldlevel = 10;
      hidden = true;
      number = true;
      scrolloff = 7;
      shiftwidth = 4;
      signcolumn = "yes";
      spell = false;
      tabstop = 4;
      termguicolors = true;
      undodir = "${config.home.homeDirectory}/.nvim/undodir";
      undofile = true;
      updatetime = 100;
      shortmess = "c";
      shell = "${pkgs.fish}/bin/fish";
      # can't use this with noice
      # lazyredraw = true;
    };

    plugins.cmp-path = {enable = true;};
    plugins.toggleterm = {
      enable = true;
      settings = {
        open_mapping = "[[<c-/>]]";
        start_in_insert = true;
      };
    };

    plugins.nix = {
      enable = true;
    };

    autoCmd = [
      {
        event = ["BufWritePre"];
        command = "lua vim.lsp.buf.format()";
      }
      {
        event = ["BufEnter" "FocusGained" "InsertLeave"];
        command = "set relativenumber";
        group = "numberToggle";
      }
      {
        event = ["BufLeave" "FocusLost" "InsertEnter"];
        command = "set norelativenumber";
        group = "numberToggle";
      }
      # {
      #   event = ["BufWritePost"];
      #   command = "set filetype=nothing | filetype detect";
      # }
    ];

    filetype = {
      extension = {
        "nu" = "nu";
      };
      pattern = {
        "#! /usr/bin/env nu" = "nu";
      };
    };

    autoGroups = {
      numberToggle = {
        clear = true;
      };
    };

    keymaps = [
      {
        mode = "i";
        key = ";;";
        action = "<Esc>";
      }
      {
        mode = "v";
        key = "<Space>";
        action = "zf";
        options = {
          remap = false;
        };
      }
      # (un)indent with Tab
      {
        mode = "v";
        key = "<Tab>";
        action = "<C-t>";
      }
      {
        mode = "v";
        key = "<S-Tab>";
        action = "<C-d>";
      }
      # folding
      {
        mode = "n";
        key = "<Space>";
        action = "@=(foldlevel('.')?'za':\"\<Space>\")<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      # windows/splits
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options = {
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options = {
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options = {
          remap = false;
        };
      }
      # automatically create a split if none doesn't exist, otherwise navigate
      {
        mode = "n";
        key = "<C-l>";
        action = "winnr('l') == winnr() ? ':vsp<CR>' : '<C-w>l'";
        options = {
          expr = true;
          remap = false;
        };
      }
    ];

    plugins.todo-comments = {
      enable = true;
    };

    plugins.none-ls = {
      enable = true;
      sources = {
        diagnostics = {
          # shellcheck.enable = true;
          # cppcheck.enable = true;
          gitlint.enable = true;
        };
        #        code_actions = {
        #          shellcheck.enable = true;
        #        };
        formatting = {
          alejandra.enable = true;
          black.enable = true;
          # stylua.enable = true;
          goimports.enable = true;
          cbfmt.enable = true;
          shfmt.enable = true;
          # taplo.enable = true;
          prettier.enable = true;
          swiftformat = {
            enable = true;
            package = null;
          };
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

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          # "<Tab>" = {
          #   action = ''
          #     function(fallback)
          #       if cmp.visible() then
          #         cmp.select_next_item()
          #       elseif luasnip.expandable() then
          #         luasnip.expand()
          #       elseif luasnip.expand_or_jumpable() then
          #         luasnip.expand_or_jump()
          #       elseif check_backspace() then
          #         fallback()
          #       else
          #         fallback()
          #       end
          #     end
          #   '';
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          # modes = ["i" "s"];
          # };
        };
        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';

        completion = {
          autocomplete = [
            "require('cmp.types').cmp.TriggerEvent.TextChanged"
          ];
        };

        sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
        ];
      };
    };

    # mapping = {
    #   "<C-d>" = "cmp.mapping.scroll_docs(-4)";
    #   "<C-f>" = "cmp.mapping.scroll_docs(4)";
    #   "<C-Space>" = "cmp.mapping.complete()";
    #   "<C-e>" = "cmp.mapping.close()";
    #   "<Tab>" = {
    #     modes = ["i" "s"];
    #     action = "cmp.mapping.select_next_item()";
    #   };
    #   "<S-Tab>" = {
    #     modes = ["i" "s"];
    #     action = "cmp.mapping.select_prev_item()";
    #   };
    # "<CR>" = "cmp.mapping.confirm({ select = true })";
    # };

    plugins.web-devicons = {
      enable = true;
    };

    plugins.telescope = {
      enable = true;
      enabledExtensions = ["ui-select"];
      # extensionConfig = {
      #   ui-select = {
      #     __raw = ''
      #       require("telescope.themes").get_dropdown {
      #         -- even more opts
      #       }
      #     '';
      #   };
      # };
    };

    plugins.treesitter = {
      enable = true;
      settings = {
        indent = {
          enable = true;
        };
      };

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
        # help
        html
        json
        markdown
        markdown_inline
        nix
        # python
        regex
        toml
        vim
        # yaml
      ];
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
      treesitter = {
        enable = true;
        include_match_words = true;
      };
      enable = true;
    };

    plugins.comment = {
      enable = true;
    };

    plugins.neo-tree = {
      enable = true;

      closeIfLastWindow = true;
      enableGitStatus = false;
      filesystem.filteredItems = {
        hideDotfiles = false;
        # hideGitIgnored = true;
        visible = true;
      };
    };

    plugins.plantuml-syntax.enable = true;

    plugins.indent-blankline = {
      enable = true;

      # useTreesitter = true;
      settings = {
        scope = {
          enabled = true;
          show_start = true;
        };
      };
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
            formatting.command = ["alejandra" "--quiet"];
          };
        };
        bashls.enable = true;
        helm_ls.enable = true;
        nushell.enable = true;
        # sourcekit.enable = true;
        terraformls.enable = true;
        yamlls.enable = true;
        jsonls.enable = true;
        gopls.enable = true;
        eslint.enable = true;
        ruff.enable = true;
        # dartls.enable = true;
      };
    };

    plugins.lsp-format = {
      enable = true;
    };

    # vim.lsp.set_log_level("debug")
    # extraConfigLua = ''
    #   require'lspconfig'.sourcekit.setup {
    #     cmd = {"/usr/bin/sourcekit-lsp"}
    #   }
    # '';

    plugins.lspkind = {
      enable = true;
      cmp = {
        enable = true;
      };
    };

    plugins.nvim-lightbulb = {
      enable = true;
      settings = {
        autocmd.enabled = true;
      };
    };

    plugins.inc-rename = {
      enable = true;
    };

    plugins.lualine = {
      enable = true;
    };

    plugins.trouble = {
      enable = true;
      settings = {
        auto_close = true;
      };
    };

    plugins.noice = {
      enable = true;

      settings = {
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
    };

    extraPlugins = with pkgs.vimPlugins; [
      editorconfig-nvim
      ron-vim
      telescope-ui-select-nvim
      vim-fish
      vim-nix
      vim-prettier
      vim-sensible
      vim-shellcheck
      vim-terraform
      vim-ripgrep
      vim-swift
    ];

    extraPackages = with pkgs; [
      shfmt
      # yaml-language-server
      nodePackages.bash-language-server
      nil
      # pyright
      # python310Packages.python-lsp-server
      # python310Packages.flake8
      # python310Packages.autopep8
    ];
  };
}
