{pkgs, ...}: let
  # REVIEW: https://github.com/NixOS/nixpkgs/pull/359426
  coreDNS = pkgs.coredns.overrideAttrs (_oldAttrs: {
    modBuildPhase = ''
      for plugin in ${builtins.toString (attrsToPlugins externalPlugins)}; do echo $plugin >> plugin.cfg; done
      for src in ${builtins.toString (attrsToSources externalPlugins)}; do go get $src; done
      GOOS= GOARCH= go generate
      go mod tidy
      go mod vendor
    '';
  });
  corednsMDNS = coreDNS.override {
    externalPlugins = [
      {
        name = "mdns";
        repo = "github.com/sheeley/coredns-mdns";
        version = "master"; #4662567616a002983caf85130514261b382dde12";
      }
    ];
    vendorHash = "";
  };
in {
  services.coredns = {
    enable = true;
    package = corednsMDNS;
    config = ''
      local.aigee.org {
        mdns sheeley.house
      }
    '';
  };
}
