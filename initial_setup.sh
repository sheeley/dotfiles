#! /usr/bin/env bash
set -euo pipefail

export PATH=$PATH:~/bin

OS=$(uname -a)
IS_MAC=
IS_NIX=
if [[ "$OS" == *"NixOS"* ]]; then
	IS_NIX=true
fi
if [[ "$OS" == *"Darwin"* ]]; then
	IS_MAC=true
fi

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
			echo "sudo nixos-build switch"
			echo "sudo reboot"
		fi
	else
		return 1
	fi
}

EMAIL=""
# TODO: XCode doesn't like ed25519. Maybe generate more than one? Hrm.
# generate ssh key
if [ ! -f ~/.ssh/id_ed25519 ]; then
	if [ "$EMAIL" == "" ]; then
		echo "Enter email to use for ssh key"
		read -r EMAIL
	fi
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

if [[ "$IS_NIX" ]]; then
	# git to clone the repo, ripgrep to run ./apply
	echo "installing git and ripgrep"
	nix-env -iA nixos.git nixos.ripgrep
fi

if [[ "$IS_MAC" ]]; then
	# nix-darwin can't install brew.
	if ! command -v brew &>/dev/null; then
		echo "brew is required - if you don't have it and don't want it installed this way, install it your way now."
		if confirm "Install brew "; then
			echo "installing brew"
			bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
			eval "\$(/opt/homebrew/bin/brew shellenv)"
			brew install --cask 1password
		fi
	fi

	if ! xcode-select -p; then
		echo "installing xcode"
		xcode-select --install
		confirm "Hit enter when install finished" || exit 1
	fi

	if ! command -v nix &>/dev/null; then
		echo "installing nix"
		curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
		# shellcheck disable=SC1091
		. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

		# create /run
		if [ ! -f /run ]; then
			echo "creating /run"
			set +x
			printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
			/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
			set -x
		fi
	fi

	HOST=$(hostname)
	if command -v scutil &>/dev/null; then
		HOST=$(scutil --get HostName)
	fi

	if confirm "Change from current hostname: $HOST?"; then
		while true; do
			set_hostname && break
		done
	fi
fi

if [ ! -f ~/.gh_done ]; then
	# store key in github
	cat ~/.ssh/id_ed25519.pub
	echo 'Generate token: https://github.com/settings/tokens/new?scopes=gist,public_repo,workflow&description=Homebrew'
	echo 'SSH Key: https://github.com/settings/keys'
	if confirm "Copy token to clipboard and open browser ^?"; then
		pbcopy <~/.ssh/id_ed25519.pub
		open 'https://github.com/settings/tokens/new?scopes=gist,public_repo,workflow&description=Homebrew'
		open https://github.com/settings/keys
		touch ~/.gh_done
	fi
fi

set +u
if [ "$HOMEBREW_GITHUB_API_TOKEN" == "" ]; then
	if [ -f ~/.gh_token ]; then
		# store token for repeat runs
		HOMEBREW_GITHUB_API_TOKEN=$(cat ~/.gh_token)
	fi
	if [ "$HOMEBREW_GITHUB_API_TOKEN" == "" ]; then
		echo "Enter Github token"
		read -r HOMEBREW_GITHUB_API_TOKEN
		export HOMEBREW_GITHUB_API_TOKEN
		echo "$HOMEBREW_GITHUB_API_TOKEN" >~/.gh_token
	fi
fi
set -u

if [ ! -d ~/dotfiles ]; then
	git clone git@github.com:sheeley/dotfiles.git ~/dotfiles
fi

if [ ! -f ~/.nix-private/private.nix ]; then
	mkdir -p ~/.nix-private
	cp ~/dotfiles/private.nix ~/.nix-private/private.nix
	echo "set values in ~/.nix-private/private.nix"
	sed -i "" "s/EMAIL_HERE/$EMAIL/g" ~/.nix-private/private.nix
fi

if [[ "$IS_MAC" ]]; then
	confirm "Log in to App Store then hit enter"
	(
		cd ~/dotfiles || exit
		./apply
	)

	if [[ "$SHELL" != "/run/current-system/sw/bin/fish" ]]; then
		echo "Shell isn't fish - may want to chsh!"
		# if cat /etc/shells | grep /run/current-system/sw/bin/fish; then
		# 	chsh -s /run/current-system/sw/bin/fish
		# else
		# 	echo "couldn't set shell to fish"
		# fi
	fi
fi

if [[ "$IS_NIX" ]]; then
	echo "mkdir $(hostname)"
	echo "cp /etc/nixos/*.nix ./$(hostname)/"
	echo ""
	echo "maybe change hostname from $(hostname)?"
	echo "put in /etc/nixos/configuration.nix: "
	echo "networking.hostName = \"$NEW_HOST\";"
	echo ""
	echo "sudo nixos-build switch"
	echo "sudo reboot"
fi

echo ""
echo ""
echo "rm ~/.gh_token"
echo ""
echo "Customize private.nix"
echo "$EDITOR ~/.nix-private/private.nix"
echo ""
echo "cd ~/dotfiles"
echo "./apply"
