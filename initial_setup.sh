#! /usr/bin/env bash

# TODO: test with xcode-select -p
xcode-select --install

# TODO: test for brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install 1Password and chezmoi - should be all the initial dependencies needed
brew install 1password-cli chezmoi

# generate key
# TODO: test if ~/.ssh/id_ed25519 exists
echo "Enter email to use for ssh key"
read -r EMAIL
ssh-keygen -t ed25519 -C "$EMAIL"
pbcopy < ~/.ssh/id_ed25519.pub

echo "save your key in Github and and generate a token"
open https://github.com/settings/keys
open https://github.com/settings/tokens

# login to 1password
eval "$(op signin my)"

# run the actual setup
chezmoi init --apply git@github.com:sheeley/dotfiles.git
