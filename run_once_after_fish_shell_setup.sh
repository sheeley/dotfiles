#!/usr/bin/env bash

FISH="/usr/local/bin/fish"

if grep -qv "$FISH" /etc/shells; then
    echo "$FISH" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$FISH" ]]; then
    chsh -s /usr/local/bin/fish
fi
