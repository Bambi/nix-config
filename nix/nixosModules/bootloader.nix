{ pkgs, ... }: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 3;
    grub.enable = false;
    consoleLogLevel = 2;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      consoleMode = "max";
    };
  };
  environment.systemPackages = [ pkgs.efibootmgr ];
}
