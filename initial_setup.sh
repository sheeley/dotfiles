#! /usr/bin/env bash
set -euo pipefail

# FYI: proxmox/debian don't install sudo by default
# apt-get install sudo
# vim /etc/sudoers
# sheeley ALL=(ALL:ALL) ALL

export PATH=$PATH:~/bin:~/.nix-profile/bin/

OS=$(uname -a)
IS_MAC=
IS_NIX=
IS_LINUX=
NOT_NIX=true
NOT_MAC=true
if [[ "$OS" == *"NixOS"* ]]; then
	IS_NIX=true
	NOT_NIX=
elif [[ "$OS" == *"Linux"* ]]; then
	IS_LINUX=true
elif [[ "$OS" == *"Darwin"* ]]; then
	IS_MAC=true
	NOT_MAC=
fi

YELLOW="\033[1;33m"
RESET="\033[0m"
confirm() {
	echo -n "${1:-Continue?} [y/N] "
	read -r CONFIRM
	if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "yes" ]; then
		return 1
	fi
}

set_hostname() {
	echo -n "New hostname: "
	read -r NEW_HOST

	if confirm "Set hostname to $NEW_HOST?"; then
		if [[ "$IS_MAC" ]]; then
			sudo scutil --set ComputerName "$NEW_HOST"
			sudo scutil --set HostName "$NEW_HOST"
		elif [[ "$IS_NIX" ]]; then
			echo "put in /etc/nixos/configuration.nix: "
			echo "networking.hostName = \"$NEW_HOST\";"
			echo "sudo nixos-rebuild switch"
			echo "sudo reboot"
		fi
	else
		return 1
	fi
}

if [[ "sheeley" != $(whoami) ]]; then
	if confirm "username is $(whoami), change to sheeley?"; then
		sudo useradd -m -G wheel -s /run/current-system/sw/bin/bash
		sudo passwd sheeley
		sudo su sheeley
		cd "$HOME"
	fi
fi

if [[ "$NOT_NIX" ]]; then
	if ! command -v nix &>/dev/null; then
		echo "installing nix"
		curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
		# shellcheck disable=SC1091
		. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

		# create /run
		if [[ "$IS_MAC" && ! -f /run ]]; then
			echo "creating /run"
			set +x
			printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
			/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
			set -x
		fi
	fi
fi

if [[ "$NOT_MAC" ]]; then
	PREFIX="nixos"
	if [[ "$NOT_NIX" ]]; then
		PREFIX="nixpkgs"
		nix-channel --add https://nixos.org/channels/nixpkgs-unstable
		nix-channel --update
	fi
	# git to clone the repo, ripgrep to run ./apply
	if ! command -v git &>/dev/null; then
		nix-env -iA "$PREFIX.git"
	fi

	if ! command -v rg &>/dev/null; then
		nix-env -iA "$PREFIX.ripgrep"
	fi
fi

HOST=$(hostname)
if [[ "$IS_MAC" ]]; then
	# nix-darwin can't install brew.
	if ! command -v brew &>/dev/null; then
		echo "brew is required - if you don't have it and don't want it installed this way, install it your way now."
		if confirm "Install brew "; then
			echo "installing brew"
			bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
			eval "\$(/opt/homebrew/bin/brew shellenv)"
			brew install --cask 1password 1password/tap/1password-cli
		fi
	fi

	if ! xcode-select -p; then
		echo "installing xcode"
		xcode-select --install
		confirm "Hit enter when install finished" || exit 1
	fi

	if command -v scutil &>/dev/null; then
		HOST=$(scutil --get HostName)
	fi

	if confirm "Change from current hostname: $HOST?"; then
		while true; do
			set_hostname && break
		done
	fi
fi

EMAIL=""
# generate ssh key
if [ ! -f ~/.ssh/id_ed25519 ]; then
	if [ "$EMAIL" == "" ]; then
		echo "Enter email to use for ssh key"
		read -r EMAIL
	fi
	echo "At this point, XCode doesn't like ed25519. Maybe generate more than one? Hrm."
	set -x
	ssh-keygen -t ed25519 -C "$EMAIL"
	eval "$(ssh-agent -s)"
	if ! ssh-add -l -E sha256 | grep ED25519; then
		if [[ "$IS_MAC" ]]; then
			ssh-add -K ~/.ssh/id_ed25519
		else
			ssh-add ~/.ssh/id_ed25519
		fi
	fi
	set +x
else
	EMAIL=$(cut -d' ' -f3 <~/.ssh/id_ed25519.pub)
fi

if [ ! -f ~/.gh_done ]; then
	# store key in github
	echo -e "$YELLOW"
	cat ~/.ssh/id_ed25519.pub
	echo 'Input SSH Key: https://github.com/settings/keys'
	echo -e "$RESET"
	if confirm "Copy public key to clipboard and open browser ^?"; then
		if command -v pbcopy &>/dev/null; then
			pbcopy <~/.ssh/id_ed25519.pub
		fi
		open https://github.com/settings/keys
	fi
	touch ~/.gh_done
fi

if command -v op &>/dev/null; then
	HOMEBREW_GITHUB_API_TOKEN=$(op read 'op://Personal/Homebrew Github Token/password')
fi
set +u
if [ "$HOMEBREW_GITHUB_API_TOKEN" == "" ]; then
	if [ -f ~/.gh_token ]; then
		# store token for repeat runs
		HOMEBREW_GITHUB_API_TOKEN=$(cat ~/.gh_token)
	fi
	if [ "$HOMEBREW_GITHUB_API_TOKEN" == "" ]; then

		echo 'Generate a token at https://github.com/settings/tokens/new?scopes=gist,public_repo,workflow&description=Homebrew'
		if confirm "open a browser to go to github to create a token for homebrew?"; then
			set -x
			open 'https://github.com/settings/tokens/new?scopes=gist,public_repo,workflow&description=Homebrew'
			set +x
		fi
		echo "Enter Github token"
		read -r HOMEBREW_GITHUB_API_TOKEN
		export HOMEBREW_GITHUB_API_TOKEN
		echo "$HOMEBREW_GITHUB_API_TOKEN" >~/.gh_token
	fi
fi
set -u

if [ -d ~/dotfiles ]; then
	echo "pulling latest dotfiles"
	(
		cd ~/dotfiles
		git pull
	)
else
	git clone git@github.com:sheeley/dotfiles.git ~/dotfiles
fi

if [ ! -f ~/.nix-private/private.nix ]; then
	mkdir -p ~/.nix-private
	cp ~/dotfiles/private.nix ~/.nix-private/private.nix
	echo "set values in ~/.nix-private/private.nix"
	if [[ "$IS_MAC" ]]; then
		sed -i "" "s/EMAIL_HERE/$EMAIL/g" ~/.nix-private/private.nix
		sed -i "" "s/EMAIL_HERE/$EMAIL/g" ~/.nix-private/private.nix
	else
		sed -i "s/GH_TOKEN_HERE/$HOMEBREW_GITHUB_API_TOKEN/g" ~/.nix-private/private.nix
		sed -i "s/EMAIL_HERE/$EMAIL/g" ~/.nix-private/private.nix
	fi
	echo "BLAH" >~/.gh_token
fi

if [[ "$IS_MAC" ]]; then
	confirm "Log in to App Store then hit enter"
fi

if [[ "$IS_NIX" && ! -d "$HOME/dotfiles/$(hostname)" ]]; then
	if confirm "Change from current hostname: $HOST?"; then
		while true; do
			set_hostname && break
		done
	fi
	if confirm "Make a new directory for this host?"; then
		echo "mkdir $(hostname)"
		echo "cp /etc/nixos/*.nix ./$(hostname)/"
		echo ""
		echo "ensure configuration.nix has:"
		echo "networking.hostName = \"$(hostname)\";"
		echo ""
		if confirm "apply changes and reboot?"; then
			sudo nixos-rebuild switch
			sudo reboot
		else
			echo "sudo nixos-rebuild switch"
			echo "sudo reboot"
			exit 1
		fi
	fi
fi

echo ""
if confirm "Customize private.nix"; then
	$EDITOR --wait ~/.nix-private/private.nix
fi

(
	cd ~/dotfiles || exit
	./apply
)

if [[ "$IS_MAC" ]]; then
	if [[ "$SHELL" != "/run/current-system/sw/bin/fish" ]]; then
		echo "Shell isn't fish - may want to chsh!"
		# if cat /etc/shells | grep /run/current-system/sw/bin/fish; then
		# 	chsh -s /run/current-system/sw/bin/fish
		# else
		# 	echo "couldn't set shell to fish"
		# fi
	fi
fi
