{ pkgs, ... }: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 3;
      grub.enable = false;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "max";
      };
    };
    consoleLogLevel = 2;
  };
  environment.systemPackages = [ pkgs.efibootmgr ];
}
