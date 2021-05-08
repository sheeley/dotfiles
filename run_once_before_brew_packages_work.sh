#! /usr/bin/env bash

brew bundle --file=- <<-EOS
brew "awscli"
brew "docker"
EOS