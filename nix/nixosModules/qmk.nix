{ pkgs, ... }: {
  services.udev = {
    enable = true;
    packages = [ pkgs.qmk-udev-rules pkgs.vial ];
  };
  environment.systemPackages = [ pkgs.qmk_hid pkgs.qmk pkgs.vial pkgs.bootloadhid ];
}
