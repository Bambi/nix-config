{ pkgs, stdenv, ... }:
let
  version = "2012-12-08";
in
stdenv.mkDerivation {
  name = "bootloadhid-${version}";
  src = pkgs.fetchurl {
    url = "https://www.obdev.at/downloads/vusb/bootloadHID.${version}.tar.gz";
    sha256 = "sha256-FU5+OGKaOi7sLfZm7foe4vLppXAY8X2fD48GTMINh1Q=";
  };
  buildPhase = ''
    cd commandline
    make
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp bootloadHID $out/bin
  '';
  buildInputs = [ pkgs.libusb-compat-0_1 ];
}
