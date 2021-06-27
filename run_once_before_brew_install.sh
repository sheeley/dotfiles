#! /usr/bin/env bash
if [ "$VIM" != "" ]; then
    echo "No install within VIM"
    exit 0
fi

OUT="$(xcode-select --install 2>&1)"
SC=$?
if [[ $SC -ne 0 ]] && [[ "$OUT" != *"command line tools are already installed"* ]]; then
    echo "Couldn't install xcode tools"
    exit 1
fi

if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
