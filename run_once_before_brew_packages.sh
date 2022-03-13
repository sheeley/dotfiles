#! /usr/bin/env bash

if [ "$VIM" != "" ]; then
    echo "No install within VIM"
    exit 0
fi

brew bundle --file=- <<-EOS
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"
tap "homebrew/core"
tap "muesli/tap"
brew "atool"
brew "bat"
brew "broot"
brew "dust"
brew "entr"
brew "fd"
brew "fish"
brew "fzf"
brew "git"
brew "git-delta"
brew "gitui"
brew "go"
brew "gron"
brew "jid"
brew "jq"
brew "neovim"
brew "pv"
brew "ripgrep"
brew "shellcheck"
brew "shfmt"
brew "ssh-copy-id"
brew "starship"
brew "the_silver_searcher"
brew "tldr"
brew "vint"
brew "wget"
brew "muesli/tap/duf"
cask "bartender"
cask "diffmerge"
cask "font-fira-code-nerd-font"
cask "font-hack-nerd-font"
cask "font-profont-nerd-font"
cask "font-space-mono-nerd-font"
cask "iterm2"
cask "krisp"
cask "shiftit"
mas "Amphetamine", id: 937984704
mas "Clocker", id: 1056643111
mas "Expressions", id: 913158085
mas "iA Writer", id: 775737590
mas "Kindle", id: 405399194
mas "Patterns", id: 429449079
mas "Slack", id: 803453959
mas "The Unarchiver", id: 425424353 
EOS

if ! pip3 show neovim2 &>/dev/null; then
    pip3 install neovim
fi
