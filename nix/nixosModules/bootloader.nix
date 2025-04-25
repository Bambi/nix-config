{ pkgs, ... }: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 6;
    grub.enable = false;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      consoleMode = "max";
    };
  };
  environment.systemPackages = [ pkgs.efibootmgr ];
}
