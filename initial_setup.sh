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

if ! which brew; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# install 1Password and chezmoi - should be all the initial dependencies needed
brew install 1password 1password-cli mas

if ! mas account; then
	echo "Sign in to app store"
	mas open
	confirm || exit 1
fi

if ! which nix; then
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
	./result/bin/darwin-installer
fi

if ! which chezmoi; then
	sh -c "$(curl -fsLS git.io/chezmoi)" || exit 1
fi

# login to 1password, setting token for futher usage
# shellcheck disable=2034
eval "$(op signin my.1password.com "$EMAIL")"

confirm || exit 1
# run the actual setup
~/bin/chezmoi init --apply git@github.com:sheeley/dotfiles.git
