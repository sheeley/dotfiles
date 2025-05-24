{
  homeDirectory,
  user,
  ...
}: [
  "/bin"
  "/usr/bin"
  "/usr/sbin"
  "/etc/profiles/per-user/${user}/bin"

  "${homeDirectory}/bin"
  "${homeDirectory}/dotfiles/bin"
  "${homeDirectory}/.local/bin"

  "${homeDirectory}/projects/sheeley/infrastructure/bin"
  "${homeDirectory}/projects/sheeley/infrastructure/scripts"
  "${homeDirectory}/go/bin"
  "${homeDirectory}/.cargo/bin"
  "${homeDirectory}/non-nix-bin"

  "${homeDirectory}/.npm-packages/bin"
  "${homeDirectory}/.n/bin"

  "/opt/homebrew/bin"
  "/Applications/Xcode.app/Contents/Developer/usr/bin"
]
