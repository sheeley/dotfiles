{user, ...}: [
  "/bin"
  "/usr/bin"
  "/usr/sbin"
  "/etc/profiles/per-user/${user}/bin"

  "$HOME/bin"
  "$HOME/dotfiles/bin"

  "$HOME/projects/sheeley/infrastructure/bin"
  "$HOME/projects/sheeley/infrastructure/scripts"
  "$HOME/go/bin"
  "$HOME/.cargo/bin"
  "$HOME/non-nix-bin"

  "$HOME/.npm-packages/bin"
  "$HOME/.n/bin"

  "/opt/homebrew/bin"
  "/Applications/Xcode.app/Contents/Developer/usr/bin"
]
