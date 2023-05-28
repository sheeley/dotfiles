#! /usr/bin/env bash

export PATH=$PATH:~/bin

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
	if confirm; then
		sudo scutil --set ComputerName "$NEW_HOST"
		sudo scutil --set HostName "$NEW_HOST"
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

	ssh-keygen -t ed25519 -C "$EMAIL"
	eval "$(ssh-agent -s)"
	if ! ssh-add -l -E sha256 | grep ED25519; then
		ssh-add -K ~/.ssh/id_ed25519
	fi
else
	EMAIL=$(cut -d' ' -f3 <~/.ssh/id_ed25519.pub)
fi

# nix doesn't install brew. Yay.
if ! which brew; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "\$(/opt/homebrew/bin/brew shellenv)"
	brew install --cask 1password
fi

if [ ! -f ~/.gh_done ]; then
	# store key in github
	echo "Open Github to create token and save SSH key?"
	if confirm; then
		pbcopy <~/.ssh/id_ed25519.pub
		open 'https://github.com/settings/tokens/new?scopes=gist,public_repo,workflow&description=Homebrew'
		open https://github.com/settings/keys
		touch ~/.gh_done
	fi
fi

if [ "$HOMEBREW_GITHUB_API_TOKEN" == "" ]; then
	echo "Enter Github token"
	read -r HOMEBREW_GITHUB_API_TOKEN
	export HOMEBREW_GITHUB_API_TOKEN
fi

if ! xcode-select -p; then
	xcode-select --install
	confirm "Hit enter when install finished" || exit 1
fi

if ! which nix; then
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
	
	# create /run
	if [ ! -f /run ]; then
		printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
		/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
	fi
fi

HOST=$(sudo scutil --get HostName)
if confirm "Change from current hostname: $HOST?"; then
	while true; do
		set_hostname && break
	done
fi

if [ ! -d ~/dotfiles ]; then
	git clone git@github.com:sheeley/dotfiles.git ~/dotfiles
fi

if [ ! -f ~/.nix-private/private.nix ]; then
	mkdir -p ~/.nix-private
	cp ~/dotfiles/private.nix ~/.nix-private/private.nix
	echo "set values in ~/.nix-private/private.nix"
	confirm
fi

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
