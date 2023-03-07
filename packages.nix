{ pkgs }:

with pkgs; [
  _1password
  #_1password-gui
  atool
  bat
  coreutils-prefixed
  dockutil
  # dovecot
  du-dust
  duf
  entr
  fd
  fzf
  git
  gitui
  go
  gron
  jid
  jq
  nerdfonts
  nixpkgs-fmt
  pv
  python311
  rclone
  ripgrep
  rsync
  shellcheck
  shfmt
  silver-searcher
  ssh-copy-id
  tldr
  vim-vint
  vscode
  wget

  # brew:

  # aom			entr			groff			libidn			libxcb			nushell			rsync			unbound
  # aribb24			exa			gron			libidn2			libxdmcp		oniguruma		rubberband		unibilium
  # atool			fd			guile			libnghttp2		libxext			opencore-amr		scout			vint
  # awscli			fdupes			harfbuzz		libogg			libxrender		openexr			sdl2			visidata
  # bash-language-server	ffmpeg			helix			libpng			libyaml			openjpeg		shellcheck		webp
  # bat			fish			highway			libpthread-stubs	libzip			openssl@1.1		shfmt			wget
  # bdw-gc			flac			hub			librist			little-cms2		openssl@3		six			x264
  # borgbackup		fontconfig		hugo			libsamplerate		luajit			opus			snappy			x265
  # borgbackup-fuse		freetype		icu4c			libsndfile		luajit-openresty	p11-kit			speex			xorgproto
  # borgmatic		frei0r			imath			libsodium		lunchy			pango			sqlite			xvid
  # broot			fribidi			jasper			libsoxr			luv			pcre			srt			xxhash
  # brotli			fzf			jbig2dec		libtasn1		lz4			pcre2			ssh-copy-id		xz
  # c-ares			gdbm			jid			libtermkey		lzo			pixman			starship		yaml-language-server
  # ca-certificates		gettext			jpeg			libtiff			m-cli			pkg-config		svt-av1			yamllint
  # cairo			ghostscript		jpeg-turbo		libtool			m4			popt			swiftformat		yarn
  # choose-rust		giflib			jpeg-xl			libunibreak		mas			psutils			swiftlint		zeromq
  # cjson			git			jq			libunistring		mbedtls			pv			terraform		zimg
  # cmocka			git-delta		lame			libuv			mpdecimal		python@3.10		terraform-ls		zstd
  # coreutils		gitui			leptonica		libvidstab		mpg123			python@3.11		tesseract
  # dav1d			glib			libarchive		libvmaf			msgpack			python@3.9		the_silver_searcher
  # diffsitter		gmp			libass			libvorbis		ncurses			pyyaml			theora
  # docutils		gnutls			libb2			libvpx			neovim			rav1e			tldr
  # dovecot			go			libbluray		libvterm		netpbm			rclone			tree
  # duf			gobject-introspection	libevent		libx11			nettle			readline		tree-sitter
  # dust			graphite2		libffi			libxau			node			ripgrep			uchardet

  # ==> Casks
  # 1password			db-browser-for-sqlite		font-hack-nerd-font		iterm2				muzzle				shiftit
  # 1password-cli			diffmerge			font-profont-nerd-font		krisp				omnifocus			shortcat
  # bartender			font-fira-code-nerd-font	font-space-mono-nerd-font	macfuse				qlstephen			vorta

]

