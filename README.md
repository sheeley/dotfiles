# Nix-darwin based Dotfiles

## Usage

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sheeley/dotfiles/main/initial_setup.sh)"
```

```sh
./update

# just apply config changes
./apply

# apply including downloads
./apply --online
```

## Explanation

Nix flake based dotfiles. Starts with [flake.nix](flake.nix).
TODO: add more guidance here.

## TODO

- [ ] notifications settings
- [ ] nightshift
- [ ] various FUTUREs spread throughout repo
- [ ] enable apple watch for sudo
- [ ] opt in to downloading icloud docs
- [ ] enable filevault
- [ ] finder sidebar and toolbar, default as list view
- [ ] share screentime across devices
- [ ] obsidian sync
