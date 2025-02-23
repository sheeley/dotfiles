{pkgs}:
pkgs.stdenv.mkDerivation rec {
  pname = "coredns-custom";
  version = "1.10.1"; # Replace with the desired CoreDNS version

  src = pkgs.fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "sha256-/+D/jATZhHSxLPB8RkPLUYAZ3O+/9l8XIhgokXz2SUQ=";
  };

  nativeBuildInputs = [pkgs.go];

  # Commands to build the plugin
  buildPhase = ''
     export GOCACHE=$TMPDIR/go-build
     export GOMODCACHE=$TMPDIR/go-mod-cache
     export GOPROXY=direct
     export GO111MODULE=on

     mkdir -p $GOCACHE
     mkdir -p $GOMODCACHE
     mkdir -p $out

    echo "building plugin..."
    echo "mdns:github.com/coredns/mdns" > plugin.cfg
    go generate
    go build -o $out/coredns .
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv $out/coredns $out/bin/
  '';

  meta = with pkgs.lib; {
    description = "Custom CoreDNS build with the mdns plugin";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
