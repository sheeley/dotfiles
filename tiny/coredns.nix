{pkgs, ...}: let
  corednsMDNS = pkgs.coredns.override {
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
        mdns local.aigee.org
      }
    '';
  };
}
