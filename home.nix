{ config, pkgs, lib, ... }:
let
  private = pkgs.callPackage ~/.nix-private/private.nix { };
in
{
  imports = [
    # <home-manager/nix-darwin>
    ./dock
  ];

  #TODO: dovecot
  #   "/opt/homebrew/etc/dovecot/dovecot.conf"
  #   "mail_home=/srv/mail/%Lu
  # mail_location=sdbox:~/Mail
  # managesieve_sieve_capability = comparator-i;octet comparator-i;ascii-casemap fileinto reject envelope encoded-character vacation subaddress comparator-i;ascii-numeric relational regex imap4flags copy include variables body enotify environment mailbox date
  # ## this is sometimes needed
  # #first_valid_uid = uid-of-vmail-user
  # # if you want to use system users
  # passdb {
  #   driver = pam
  # }
  # userdb {
  #   driver = passwd
  #   args = blocking=no
  #   override_fields = uid=vmail gid=vmail
  # }
  # ssl=yes
  # ssl_cert=</path/to/cert.pem
  # ssl_key=</path/to/key.pem
  # # if you are using v2.3.0-v2.3.2.1 (or want to support non-ECC DH algorithms)
  # # since v2.3.3 this setting has been made optional.
  # #ssl_dh=</path/to/dh.pem
  # namespace {
  #   inbox = yes
  #   separator = /
  # }
  # plugin {
  #   # Use editheader
  #   sieve_extensions = +copy +body +environment +variables +vacation +relational +imap4flags +subaddress +spamtest +virustest +date +index +editheader +reject +enotify +ihave +mailbox +mboxmetadata +servermetadata +foreverypart +mime +extracttext +include +duplicate +regex 
  # }"

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
    # verbose = true;
  };

  home-manager.users.sheeley = { config, lib, pkgs, ... }: {
    # programs.bash.enable = true;
    # programs.zsh.enable = true;
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
        GITHUB_TOKEN = "${private.githubSecret}";
      };

      sessionPath = [
        "$HOME/bin"
        "/etc/profiles/per-user/sheeley/bin/"
        "$HOME/projects/sheeley/infrastructure/bin"
        "$HOME/projects/sheeley/infrastructure/scripts"
        "$HOME/go/bin"
        "$HOME/.cargo/bin"
        # TODO: can this be injected by the homebrew program setup?
        "/opt/homebrew/bin"
        "/usr/local/bin"
        "/usr/local/sbin"
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

    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPath = "~/.ssh/control/%r@%h:%p";
      controlPersist = "10m";
      extraConfig = "
IdentityFile ~/.ssh/id_ed25519
AddKeysToAgent yes";
    };

    programs.helix = {
      enable = true;

      settings = {
        editor = {
          shell = [ "fish" ];
          cursorline = true;
        };

        "keys.normal" = {
          "g" = {
            "c" = {
              "c" = "toggle_comments";
            };
          };
          # "Ctrl-/" = "toggle_comments"
        };

        "keys.insert" = {
          ";" = {
            ";" = "normal_mode";
          };
        };
      };
    };


    programs.fish = {

      enable = true;
      interactiveShellInit = builtins.readFile ./files/init.fish;
      plugins = with pkgs; [
        { name = "foreign-env"; src = fishPlugins.foreign-env.src; }
        { name = "done"; src = fishPlugins.done.src; }
        # {
        #   # TODO: robbyrussell theme?
        #   name = "robbyrussell";
        #   src = pkgs.fetchFromGitHub
        #     {
        #       owner = "oh-my-fish/";
        #       repo = "theme-robbyrussell";
        #       rev = "93944745b7a2ede0be548e0c8fc160d7f2cc6af7";
        #       sha256 = "l/fctaS58IZKM5/MsYC+WQZ0GWZGZ6SWT+bA5QoODbU=";
        #     };
        # }
      ];

      functions = {
        __fish_describe_command_handler = {
          body = "";
          onEvent = "__fish_describe_command";
        };
      };
    };

    programs.git = {
      enable = true;

      attributes = [
        "*.plist diff=plist"
      ];

      delta.enable = true;

      extraConfig = {
        init.defaultBranch = "main";

        branch = {
          autosetuprebase = "always";
        };

        color = {
          ui = "auto";

          branch = {
            current = "yellow reverse";
            local = "yellow";
            remote = "green";
          };

          diff = {
            meta = "yellow bold";
            frag = "magenta bold";
            old = "red bold";
            new = "green bold";
            whitespace = "red reverse";
          };

          status = {
            added = "yellow";
            changed = "green";
            untracked = "cyan";
          };
        };

        core = {
          whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol,space-before-tab";
          autocrlf = "input";
          editor = "nvim";
        };

        delta = {
          "side-by-side" = true;
          plus-style = "syntax #012800";
          minus-style = "syntax #340001";
          syntax-theme = "Monokai Extended";
          navigate = true;
        };

        diff = {
          plist = {
            textconv = "plutil -convert xml1 -o -";
          };
        };

        pull.rebase = true;
        push.default = "simple";
        # url = {
        #   "ssh://git@github.com" = {
        #     insteadOf = "https://github.com/";
        #   };
        # };
      };

      ignores = [
        ### Vim ###
        # Swap
        "[._]*.s[a-v][a-z]"
        "[._]*.sw[a-p]"
        "[._]s[a-rt-v][a-z]"
        "[._]ss[a-gi-z]"
        "[._]sw[a-p]"

        # Session
        "Session.vim"
        "Sessionx.vim"

        # Temporary
        ".netrwhist"
        "*~"
        # Auto-generated tag files
        "tags"
        # Persistent undo
        "[._]*.un~"

        # End of https://www.gitignore.io/api/vim
        # Created by https://www.gitignore.io/api/go,rust,node,swift,xcode,macos,python,carthage,cocoapods,visualstudiocode
        # Edit at https://www.gitignore.io/?templates=go,rust,node,swift,xcode,macos,python,carthage,cocoapods,visualstudiocode

        ### Carthage ###
        # Carthage
        #
        # Add this line if you want to avoid checking in source code from Carthage dependencies.
        # Carthage/Checkouts

        "Carthage/Build"

        ### CocoaPods ###
        ## CocoaPods GitIgnore Template

        # CocoaPods - Only use to conserve bandwidth / Save time on Pushing
        #           - Also handy if you have a large number of dependant pods
        #           - AS PER https://guides.cocoapods.org/using/using-cocoapods.html NEVER IGNORE THE LOCK FILE
        "Pods/"

        ### Go ###
        # Binaries for programs and plugins
        "*.exe"
        "*.exe~"
        "*.dll"
        "*.so"
        "*.dylib"

        # Test binary, build with `go test -c`
        "*.test"

        # Output of the go coverage tool, specifically when used with LiteIDE
        "*.out"

        ### Go Patch ###
        "/vendor/"
        "/Godeps/"

        ### macOS ###
        # General
        ".DS_Store"
        ".AppleDouble"
        ".LSOverride"

        # Icon must end with two \r
        "Icon"

        # Thumbnails
        "._*"

        # Files that might appear in the root of a volume
        ".DocumentRevisions-V100"
        ".fseventsd"
        ".Spotlight-V100"
        ".TemporaryItems"
        ".Trashes"
        ".VolumeIcon.icns"
        ".com.apple.timemachine.donotpresent"

        # Directories potentially created on remote AFP share
        ".AppleDB"
        ".AppleDesktop"
        "Network Trash Folder"
        "Temporary Items"
        ".apdisk"

        ### Node ###
        # Logs
        "logs"
        "*.log"
        "npm-debug.log*"
        "yarn-debug.log*"
        "yarn-error.log*"

        # Runtime data
        "pids"
        "*.pid"
        "*.seed"
        "*.pid.lock"

        # Directory for instrumented libs generated by jscoverage/JSCover
        "lib-cov"

        # Coverage directory used by tools like istanbul
        "coverage"

        # nyc test coverage
        ".nyc_output"

        # Grunt intermediate storage (https://gruntjs.com/creating-plugins#storing-task-files)
        ".grunt"

        # Bower dependency directory (https://bower.io/)
        "bower_components"

        # node-waf configuration
        ".lock-wscript"

        # Compiled binary addons (https://nodejs.org/api/addons.html)
        "build/Release"

        # Dependency directories
        "node_modules/"
        "jspm_packages/"

        # TypeScript v1 declaration files
        "typings/"

        # Optional npm cache directory
        ".npm"

        # Optional eslint cache
        ".eslintcache"

        # Optional REPL history
        ".node_repl_history"

        # Output of 'npm pack'
        "*.tgz"

        # Yarn Integrity file
        ".yarn-integrity"

        # dotenv environment variables file
        ".env"

        # parcel-bundler cache (https://parceljs.org/)
        ".cache"

        # next.js build output
        ".next"

        # nuxt.js build output
        ".nuxt"

        # vuepress build output
        ".vuepress/dist"

        # Serverless directories
        ".serverless"

        # FuseBox cache
        ".fusebox/"

        ### Python ###
        # Byte-compiled / optimized / DLL files
        "__pycache__/"
        "*.py[cod]"
        "*$py.class"

        # C extensions

        # Distribution / packaging
        ".Python"
        "build/"
        "develop-eggs/"
        "dist/"
        "downloads/"
        "eggs/"
        ".eggs/"
        "lib/"
        "lib64/"
        "parts/"
        "sdist/"
        "var/"
        "wheels/"
        "*.egg-info/"
        ".installed.cfg"
        "*.egg"
        "MANIFEST"

        # PyInstaller
        #  Usually these files are written by a python script from a template
        #  before PyInstaller builds the exe, so as to inject date/other infos into it.
        "*.manifest"
        "*.spec"

        # Installer logs
        "pip-log.txt"
        "pip-delete-this-directory.txt"

        # Unit test / coverage reports
        "htmlcov/"
        ".tox/"
        ".nox/"
        ".coverage"
        ".coverage.*"
        "nosetests.xml"
        "coverage.xml"
        "*.cover"
        ".hypothesis/"
        ".pytest_cache/"

        # Translations
        "*.mo"
        "*.pot"

        # Django stuff:
        "local_settings.py"
        "db.sqlite3"

        # Flask stuff:
        "instance/"
        ".webassets-cache"

        # Scrapy stuff:
        ".scrapy"

        # Sphinx documentation
        "docs/_build/"

        # PyBuilder
        "target/"

        # Jupyter Notebook
        ".ipynb_checkpoints"

        # IPython
        "profile_default/"
        "ipython_config.py"

        # pyenv
        ".python-version"

        # celery beat schedule file
        "celerybeat-schedule"

        # SageMath parsed files
        "*.sage.py"

        # Environments
        ".venv"
        "env/"
        "venv/"
        "ENV/"
        "env.bak/"
        "venv.bak/"

        # Spyder project settings
        ".spyderproject"
        ".spyproject"

        # Rope project settings
        ".ropeproject"

        # mkdocs documentation
        "/site"

        # mypy
        ".mypy_cache/"
        ".dmypy.json"
        "dmypy.json"

        # Pyre type checker
        ".pyre/"

        ### Python Patch ###
        ".venv/"

        ### Python.VirtualEnv Stack ###
        # Virtualenv
        # http://iamzed.com/2009/05/07/a-primer-on-virtualenv/
        # [Bb]in
        # [Ii]nclude
        # [Ll]ib
        # [Ll]ib64
        # [Ll]ocal
        # [Ss]cripts
        "pyvenv.cfg"
        "pip-selfcheck.json"

        ### Rust ###
        # Generated by Cargo
        # will have compiled files and executables
        "/target/"

        # Remove Cargo.lock from gitignore if creating an executable, leave it for libraries
        # More information here https://doc.rust-lang.org/cargo/guide/cargo-toml-vs-cargo-lock.html
        "Cargo.lock"

        # These are backup files generated by rustfmt
        "**/*.rs.bk"

        ### Swift ###
        # Xcode
        #
        # gitignore contributors: remember to update Global/Xcode.gitignore, Objective-C.gitignore & Swift.gitignore

        ## Build generated
        "DerivedData/"

        ## Various settings
        "*.pbxuser"
        "!default.pbxuser"
        "*.mode1v3"
        "!default.mode1v3"
        "*.mode2v3"
        "!default.mode2v3"
        "*.perspectivev3"
        "!default.perspectivev3"
        "xcuserdata/"

        ## Other
        "*.moved-aside"
        "*.xccheckout"
        "*.xcscmblueprint"

        ## Obj-C/Swift specific
        "*.hmap"
        "*.ipa"
        "*.dSYM.zip"
        "*.dSYM"

        ## Playgrounds
        "timeline.xctimeline"
        "playground.xcworkspace"

        # Swift Package Manager
        #
        # Add this line if you want to avoid checking in source code from Swift Package Manager dependencies.
        # Packages/
        # Package.pins
        # Package.resolved
        ".build/"

        # CocoaPods
        #
        # We recommend against adding the Pods directory to your .gitignore. However
        # you should judge for yourself, the pros and cons are mentioned at:
        # https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control
        #
        # Pods/
        #
        # Add this line if you want to avoid checking in source code from the Xcode workspace
        # *.xcworkspace

        # Carthage
        #
        # Add this line if you want to avoid checking in source code from Carthage dependencies.
        # Carthage/Checkouts


        # fastlane
        #
        # It is recommended to not store the screenshots in the git repo. Instead, use fastlane to re-generate the
        # screenshots whenever they are needed.
        # For more information about the recommended setup visit:
        # https://docs.fastlane.tools/best-practices/source-control/#source-control

        "fastlane/report.xml"
        "fastlane/Preview.html"
        "fastlane/screenshots/**/*.png"
        "fastlane/test_output"

        # Code Injection
        #
        # After new code Injection tools there's a generated folder /iOSInjectionProject
        # https://github.com/johnno1962/injectionforxcode

        "iOSInjectionProject/"

        ### VisualStudioCode ###
        ".vscode/*"
        "!.vscode/settings.json"
        "!.vscode/tasks.json"
        "!.vscode/launch.json"
        "!.vscode/extensions.json"

        ### VisualStudioCode Patch ###
        # Ignore all local history of files
        ".history"

        ### Xcode ###
        # Xcode
        #
        # gitignore contributors: remember to update Global/Xcode.gitignore, Objective-C.gitignore & Swift.gitignore

        ## Build generated

        ## Various settings

        ## Other

        ## Obj-C/Swift specific

        ## Playgrounds

        # Swift Package Manager
        #
        # Add this line if you want to avoid checking in source code from Swift Package Manager dependencies.
        # Packages/
        # Package.pins
        # Package.resolved

        # CocoaPods
        #
        # We recommend against adding the Pods directory to your .gitignore. However
        # you should judge for yourself, the pros and cons are mentioned at:
        # https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control
        #
        # Pods/
        #
        # Add this line if you want to avoid checking in source code from the Xcode workspace
        # *.xcworkspace

        # Carthage
        #
        # Add this line if you want to avoid checking in source code from Carthage dependencies.
        # Carthage/Checkouts


        # fastlane
        #
        # It is recommended to not store the screenshots in the git repo. Instead, use fastlane to re-generate the
        # screenshots whenever they are needed.
        # For more information about the recommended setup visit:
        # https://docs.fastlane.tools/best-practices/source-control/#source-control


        # Code Injection
        #
        # After new code Injection tools there's a generated folder /iOSInjectionProject
        # https://github.com/johnno1962/injectionforxcode



        ### Xcode Patch ###
        "*.xcodeproj/*"
        "!*.xcodeproj/project.pbxproj"
        "!*.xcodeproj/xcshareddata/"
        "!*.xcworkspace/contents.xcworkspacedata"
        "/*.gcno"
        "**/xcshareddata/WorkspaceSettings.xcsettings"

        # End of https://www.gitignore.io/api/go,rust,node,swift,xcode,macos,python,carthage,cocoapods,visualstudiocode
        ".dirtlock"
        ".dirtlock*"
        "coverage"
      ];

      userName = "Johnny Sheeley";
      userEmail = "${private.email}";

      includes = [{
        condition = "gitdir:~/work";
        contents = {
          user = {
            email = "${private.workEmail}";
          };
        };
      }];
    };

    programs.gitui = {
      enable = true;
      keyConfig = builtins.readFile ./files/gitui/key_bindings.ron;
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      settings = {
        format = lib.concatStrings [
          "$time | "
          "$directory"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "\${custom.git_status_simplified}"
          "$jobs"
          "$cmd_duration"
          "$line_break"
          "$character"
        ];

        git_branch = {
          format = "[$symbol$branch]($style) ";
          style = "";
        };

        aws = {
          format = "[$symbol($profile )(\($region\) )]($style)";
        };

        time = {
          disabled = false;
          style = "bold";
          format = "[$time]($style) ";
        };

        cmd_duration = {
          format = ": [$duration]($style)";
          min_time = 100;
          show_milliseconds = true;
          style = "";
        };

        character = {
          success_symbol = "[➜](bold green) ";
          error_symbol = "[✗](bold red) ";
        };

        directory = {
          truncation_length = 5;
          truncate_to_repo = true;
        };


        custom = {
          git_status_simplified = {
            when = "test - n \"$(git status --porcelain)\"";
            symbol = "●";
            style = "yellow bold";
            format = "[ $symbol ] ($style)";
            shell = [ "bash" ];
          };
        };
      };
    };

    programs.broot = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };

    programs.jq = {
      enable = true;
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };

    programs.neovim = {
      enable = true;
      # defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = builtins.readFile ./files/nvim/local_init.vim;

      coc = {
        enable = true;
        settings = builtins.readFile ./files/nvim/coc-settings.json;
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
  };
}
