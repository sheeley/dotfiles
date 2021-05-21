#! /usr/bin/env bash

# swiftlint needs to come after xcode
brew bundle --file=- <<-EOS
brew "borgbackup"
brew "hugo"
brew "rclone"
brew "rsync"
mas "Space Gremlin", id: 414515628
mas "Reeder", id: 1529448980
mas "Twitter", id: 1482454543

EOS

# echo -n "Install Xcode/swift? "
# read -r INSTALL
# if [ "$INSTALL" == "y"]; then
#  brew bundle --file=- <<-EOS
#  mas "Xcode", id: 497799835
#  brew "swiftlint"
#  brew "swiftformat"
#  cask "swiftformat-for-xcode"
#  mas "Watchdog", id: 734258109
# EOS
# fi
