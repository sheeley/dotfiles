#!/usr/bin/env bash

defaults write com.apple.screencapture "location" -string '/Users/sheeley/Screenshots'
defaults write com.apple.screencapture "location-last" -string '~/Screenshots'
start_application -r -a "SystemUIServer"