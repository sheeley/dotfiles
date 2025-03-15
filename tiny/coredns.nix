{pkgs, ...}: let
in {
  # nixpkgs.overlays = [
  #   (self: super: {
  #     coredns = super.stdenv.mkDerivation {
  #       pname = "coredns";
  #       version = "custom";
  #
  #       src = ../tools/coredns/bin/coredns;
  #
  #       # Explicitly skip unpacking
  #       unpackPhase = "true";
  #
  #       installPhase = ''
  #         mkdir -p $out/bin
  #         cp $src $out/bin/coredns
  #         chmod +x $out/bin/coredns
  #       '';
  #     };
  #   })
  #   # (self: super: {
  #   #   coredns = super.stdenv.mkDerivation {
  #   #     pname = "coredns";
  #   #     version = "custom";
  #   #
  #   #     # src = ../tools/coredns;
  #   #     # buildInputs = [super.go];
  #   #
  #   #     # buildPhase = ''
  #   #     #   mkdir -p bin
  #   #     #   # go build -o bin/coredns .
  #   #     #   cp ./coredns-sdns bin/coredns
  #   #     # '';
  #   #   };
  #   # })
  # ];
  #
  # services.coredns = {
  #   enable = true;
  #   # package = corednsMDNS;
  #   config = ''
  #     local.aigee.org {
  #       mdns sheeley.house
  #     }
  #   '';
  # };
}
