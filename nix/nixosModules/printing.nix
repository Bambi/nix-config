{ pkgs, ... }:
let
  dcp-7010-ppd = builtins.fetchurl {
    url = "https://www.openprinting.org/ppd-o-matic.php?driver=hl1250&printer=Brother-DCP-7010&show=0";
    name = "brother-dcp-7010.ppd";
    sha256 = "sha256:01i9jijd7iv0w0y8xw07i71rgm7q27h51jibd2sizs9lh1wl4nmd";
  };
in
{
  services.printing = {
    enable = true;
    drivers = [
      (pkgs.writeTextDir "share/cups/model/dcp-7010.ppd" dcp-7010-ppd)
    ];
  };
}
