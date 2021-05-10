#! /usr/bin/env bash

OUT="$(xcode-select --install 2>&1)"
SC=$?
if [[ $SC -ne 0 ]] && [[ "$OUT" != *"command line tools are already installed"* ]]; then
	echo "Couldn't install xcode tools"
	exit 1
fi

if ! command -v brew &>/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle --file=- <<-EOS

tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"
tap "homebrew/core"
tap "muesli/tap"
brew "python@3.9"
brew "fish"
brew "fzf"
brew "git"
brew "gitui"
brew "go"
brew "hub"
brew "hugo"
brew "jid"
brew "jq"
brew "lunchy"
brew "m-cli"
brew "mas"
brew "neovim"
brew "pv"
brew "ripgrep"
brew "shellcheck"
brew "shfmt"
brew "ssh-copy-id"
brew "starship"
brew "terraform"
brew "the_silver_searcher"
brew "tree"
brew "wget"
brew "yarn"
brew "muesli/tap/duf"
cask "1password-cli"
cask "bartender"
cask "diffmerge"
cask "font-fira-code-nerd-font"
cask "font-hack-nerd-font"
cask "font-profont-nerd-font"
cask "font-space-mono-nerd-font"
cask "iterm2"
cask "krisp"
cask "muzzle"
cask "qlstephen"
cask "shiftit"
mas "Amphetamine", id: 937984704
mas "Be Focused", id: 973134470
mas "Bear", id: 1091189122
mas "Clocker", id: 1056643111
mas "Expressions", id: 913158085
mas "iA Writer", id: 775737590
mas "Patterns", id: 429449079
mas "The Unarchiver", id: 425424353
EOS

if ! pip3 show neovim2 &>/dev/null; then
	pip3 install neovim
fi
# open /Applications/Bartender\ 4.app
# open /Applications/ShiftIt.app
# open /Applications/Amphetamine.app
# open /Applications/Krisp.app
