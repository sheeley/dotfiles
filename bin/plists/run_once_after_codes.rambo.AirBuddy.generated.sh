#!/usr/bin/env bash

defaults write codes.rambo.AirBuddy "SUAutomaticallyUpdate" -boolean true
defaults write codes.rambo.AirBuddy "hasCompletedOnboarding" -boolean true
start_application -r -a "AirBuddy"