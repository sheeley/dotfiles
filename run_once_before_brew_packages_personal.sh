#! /usr/bin/env bash

brew bundle --file=- <<-EOS
brew "borgbackup"
brew "hugo"
brew "rclone"
brew "rsync"
mas "Space Gremlin", id: 414515628
mas "Reeder", id: 1529448980
EOS

echo -n "Install Xcode/swift? "
read -r INSTALL
if [ -t 0 ] && [ "$INSTALL" == "y" ]; then
    # swiftlint needs to come after xcode
    brew bundle --file=- <<-EOS
mas "Xcode", id: 497799835
brew "swiftlint"
brew "swiftformat"
cask "swiftformat-for-xcode"
mas "Watchdog", id: 734258109
EOS
    if ! which tuist; then
        bash <(curl -Ls https://install.tuist.io)
    fi
else
    echo "skipped xcode/swift tools install"
fi
