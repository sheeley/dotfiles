#! /usr/bin/env bash

confirm() {
    echo "Continue?"
    read -r CONFIRM
    if [ "$CONFIRM" != "y" ]; then
        return 1
    fi
}

if ! xcode-select -p; then
    xcode-select --install
fi

confirm || exit 1

if ! which brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install 1Password and chezmoi - should be all the initial dependencies needed
sh -c "$(curl -fsLS git.io/chezmoi)"
brew install 1password 1password-cli

confirm || exit 1

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

if [ "$HOMEBREW_GITHUB_API_TOKEN" -eq "" ]; then
    echo "Enter email to use for ssh key"
    read -r HOMEBREW_GITHUB_API_TOKEN
    export HOMEBREW_GITHUB_API_TOKEN
fi

# login to 1password, setting token for futher usage
# shellcheck disable=2034
OP_TOKEN=$(op signin my.1password.com "$EMAIL")

confirm || exit 1
# run the actual setup
~/bin/chezmoi init --apply git@github.com:sheeley/dotfiles.git
