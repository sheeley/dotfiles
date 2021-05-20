#! /usr/bin/env bash

brew bundle --file=- <<-EOS
brew "borgbackup"
brew "hugo"
brew "rclone"
brew "rsync"
brew "swiftlint"
brew "swiftformat"
cask "swiftformat-for-xcode"
mas "Space Gremlin", id: 414515628
mas "Reeder", id: 1529448980
mas "Twitter", id: 1482454543
mas "Watchdog", id: 734258109
mas "WhatsApp", id: 1147396723
mas "Xcode", id: 497799835
EOS
