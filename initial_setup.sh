#! /usr/bin/env bash

if ! xcode-select -p; then
    xcode-select --install
fi

if ! which brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install 1Password and chezmoi - should be all the initial dependencies needed
sh -c "$(curl -fsLS git.io/chezmoi)"
brew install 1password 1password-cli

# generate ssh key
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
    echo "Enter email to use for ssh key"
    read -r EMAIL
    ssh-keygen -t ed25519 -C "$EMAIL"
fi

# store key in github
pbcopy < ~/.ssh/id_ed25519.pub
echo "save your key in Github and and generate a token"
open https://github.com/settings/keys
open https://github.com/settings/tokens

# login to 1password, setting token for futher usage
# shellcheck disable=2034
OP_TOKEN=$(op signin my.1password.com "$EMAIL")

# run the actual setup
~/bin/chezmoi init --apply git@github.com:sheeley/dotfiles.git
