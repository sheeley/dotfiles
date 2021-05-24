#! /usr/bin/env bash
if [ "$VIM" != "" ]; then
    echo "No install within VIM"
    exit 0
fi

brew bundle --file=- <<-EOS
brew "awscli"
brew "docker"
EOS
