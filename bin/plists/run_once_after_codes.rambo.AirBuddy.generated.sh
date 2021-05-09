#!/usr/bin/env bash
# GENERATED FILE, DO NOT TOUCH
# Edit plist_export or create a file without generated.sh in its name.

defaults write codes.rambo.AirBuddy "SUAutomaticallyUpdate" -boolean true
defaults write codes.rambo.AirBuddy "hasCompletedOnboarding" -boolean true
start_application -r -a "AirBuddy"