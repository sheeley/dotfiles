#! /usr/bin/env bash
if [ "$VIM" != "" ]; then
    echo "No install within VIM"
    exit 0
fi

brew bundle --file=- <<-EOS
tap "afnanenayet/tap"
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"
tap "homebrew/core"
tap "muesli/tap"
brew "atool"
brew "bat"
brew "diffsitter"
brew "git-delta"
brew "fish"
brew "fzf"
brew "git"
brew "gitui"
brew "go"
brew "gron"
brew "hub"
brew "hugo"
brew "jid"
brew "jq"
brew "lunchy"
brew "m-cli"
brew "mas"
brew "neovim"
brew "nushell"
brew "pv"
brew "python@3.9"
brew "ripgrep"
brew "saulpw/vd/visidata"
brew "shellcheck"
brew "shfmt"
brew "ssh-copy-id"
brew "starship"
brew "terraform"
brew "the_silver_searcher"
brew "tldr"
brew "tree"
brew "vint"
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
cask "qlstephen"
cask "shiftit"
mas "Amphetamine", id: 937984704
mas "Clocker", id: 1056643111
mas "Expressions", id: 913158085
mas "iA Writer", id: 775737590
mas "Patterns", id: 429449079
mas "The Unarchiver", id: 425424353
mas "Slack for Desktop", id: 803453959
EOS

if ! pip3 show neovim2 &>/dev/null; then
    pip3 install neovim
fi
