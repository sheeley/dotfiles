#! /usr/bin/env bash

export PATH=$PATH:~/bin

confirm() {
	echo -n "Continue?"
	read -r CONFIRM
	if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "yes" ]; then
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
	# store key in github
	echo "Open Github to create token and save SSH key?"
	if confirm; then
		pbcopy <~/.ssh/id_ed25519.pub
		open 'https://github.com/settings/tokens/new?scopes=gist,public_repo,workflow&description=Homebrew'
		open https://github.com/settings/keys
	fi

	if [ "$HOMEBREW_GITHUB_API_TOKEN" == "" ]; then
		echo "Enter Github token"
		read -r HOMEBREW_GITHUB_API_TOKEN
		export HOMEBREW_GITHUB_API_TOKEN
	fi

else
	EMAIL=$(cut -d' ' -f3 <~/.ssh/id_ed25519.pub)
fi

if ! xcode-select -p; then
	xcode-select --install
	confirm || exit 1
fi

if ! which nix; then
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
fi

echo "Log in to App Store"
confirm

# login to 1password, setting token for futher usage
# shellcheck disable=2034
# eval "$(op signin my.1password.com "$EMAIL")"

confirm || exit 1
# # run the actual setup
# chezmoi init --apply git@github.com:sheeley/dotfiles.git

mkdir -p ~/.nix-private
cp private.nix ~/.nix-private/private.nix

echo "set values in ~/.nix-private/private.nix"
confirm

git clone git@github.com:sheeley/dotfiles.git
cd dotfiles
./update-darwin
