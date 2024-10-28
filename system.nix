{...}: {
  nix = {
    settings = {
      auto-optimise-store = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes

      # Ensure we can still build when missing-server is not accessible
      fallback = true
    '';
  };
}
