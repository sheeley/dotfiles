{...}: let
  # TODO: swap these for dynamic IPs
  localIp = "192.168.1.17";
  resolverIp = "8.8.8.8";
  cacheDirectory = "/var/cache/nginx/";
in {
  networking.firewall.allowedTCPPorts = [80];
  services.nginx = {
    enable = true;
    appendHttpConfig = ''
      proxy_cache_path ${cacheDirectory} levels=1:2 keys_zone=cachecache:100m max_size=75g inactive=365d use_temp_path=off;

      # Cache only success status codes; in particular we don't want to cache 404s.
      # See https://serverfault.com/a/690258/128321
      map $status $cache_header {
        200     "public";
        302     "public";
        default "no-cache";
      }
      access_log /var/log/nginx/access.log;
    '';

    virtualHosts."${localIp}" = {
      locations."/" = {
        root = cacheDirectory;
        extraConfig = ''
          expires max;
          add_header Cache-Control $cache_header always;
          # Ask the upstream server if a file isn't available locally
          error_page 404 = @fallback;
        '';
      };

      extraConfig = ''
        # Using a variable for the upstream endpoint to ensure that it is
        # resolved at runtime as opposed to once when the config file is loaded
        # and then cached forever (we don't want that):
        # see https://tenzer.dk/nginx-with-dynamic-upstreams/
        # This fixes errors like
        #   nginx: [emerg] host not found in upstream "upstream.example.com"
        # when the upstream host is not reachable for a short time when
        # nginx is started.
        resolver ${resolverIp};
        set $upstream_endpoint http://cache.nixos.org;
      '';

      locations."@fallback" = {
        proxyPass = "$upstream_endpoint";
        extraConfig = ''
          proxy_cache cachecache;
          proxy_cache_valid  200 302  60d;
          expires max;
          add_header Cache-Control $cache_header always;
        '';
      };

      # We always want to copy cache.nixos.org's nix-cache-info file,
      # and ignore our own, because `nix-push` by default generates one
      # without `Priority` field, and thus that file by default has priority
      # 50 (compared to cache.nixos.org's `Priority: 40`), which will make
      # download clients prefer `cache.nixos.org` over our binary cache.
      locations."= /nix-cache-info" = {
        # Note: This is duplicated with the `@fallback` above,
        # would be nicer if we could redirect to the @fallback instead.
        proxyPass = "$upstream_endpoint";
        extraConfig = ''
          proxy_cache cachecache;
          proxy_cache_valid  200 302  60d;
          expires max;
          add_header Cache-Control $cache_header always;
        '';
      };
    };
  };

  # nix.settings.substituters = ["http://${localIp}/"];
}