{ config, pkgs, ... }:
let
  dcp-7010-ppd = builtins.fetchurl {
    url = "https://www.openprinting.org/ppd-o-matic.php?driver=hl1250&printer=Brother-DCP-7010&show=0";
    name = "brother-dcp-7010.ppd";
    sha256 = "sha256:01i9jijd7iv0w0y8xw07i71rgm7q27h51jibd2sizs9lh1wl4nmd";
  };
  allUsers = builtins.attrNames config.users.users;
  normalUsers = builtins.filter (user: config.users.users.${user}.isNormalUser) allUsers;
in
{
  services = {
    printing = {
      enable = true;
      drivers = [
        (pkgs.writeTextDir "share/cups/model/dcp-7010.ppd" dcp-7010-ppd)
        # pkgs.canon-cups-ufr2
        pkgs.cnijfilter2
      ];
    };
    udev.packages = [ pkgs.sane-airscan ];
  };
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };

  # To install printers manually
  programs.system-config-printer.enable = true;
  # add all users to group scanner and lp
  users.groups.scanner.members = normalUsers;
  users.groups.lp.members = normalUsers;
}
