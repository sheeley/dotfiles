{
  pkgs,
  lib,
  private,
  ...
}: {
  system.activationScripts.postUserActivation.text = ''
        echo >&2 "I am: $(whoami)"

    # check if we are already authenticated to tailscale
    status="$(tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"

    if [ "$status" = "Running" ]; then # if so, then do nothing
        exit 0
    fi

    # otherwise authenticate with tailscale
    tailscale up -authkey ${private.tailscaleKey}
  '';
}
