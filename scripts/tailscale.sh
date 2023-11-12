
# TODO: for some reason JQ isn't in the path.
jq="/etc/profiles/per-user/$(whoami)/bin/jq"

# check if we are already authenticated to tailscale
status="$(tailscale status -json | $jq -r .BackendState)"

if [ "$status" = "Running" ]; then # if so, then do nothing
    exit 0
fi

# otherwise authenticate with tailscale
tailscale up -authkey @tailscaleKey@