#! /usr/bin/env bash
# check if we are already authenticated to tailscale
status="$(tailscale status -json | jq -r .BackendState)"
if [ "$status" = "Running" ]; then # if so, then do nothing
    exit 0
fi

# otherwise authenticate with tailscale
# TODO: tailscale up -authkey ${private.tailscaleKey}