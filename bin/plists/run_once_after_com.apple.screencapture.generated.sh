#!/usr/bin/env bash
# GENERATED FILE, DO NOT TOUCH
# Edit plist_export or create a file without generated.sh in its name.

defaults write com.apple.screencapture "location" -string '~/Screenshots'
defaults write com.apple.screencapture "location-last" -string '~/Screenshots'
start_application -r -a "SystemUIServer"