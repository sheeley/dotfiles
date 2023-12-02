{
  pkgs,
  user,
  ...
}: {
  nix = {
    settings = {
      auto-optimise-store = true;
    };
    extraOptions = "experimental-features = nix-command flakes";
  };
}
