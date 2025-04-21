{ pkgs, config, lib, inputs, ... }: {
  # Bootloader.
  options.my.grub.enable = inputs.self.lib.mkBoolOpt false "Use Grub for boot.";

  config = {
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 6;
        grub =
          if config.my.grub.enable then {
            enable = true;
            device = "nodev";
            efiSupport = true;
            useOSProber = true;
            configurationLimit = 5;
            gfxmodeEfi = "1920x1080";
            extraEntries = ''
              menuentry "Reboot" {
                reboot
              }
              menuentry "Poweroff" {
                halt
              }
            '';
          } else {
            enable = false;
          };
        # Use systemd if no grub
        systemd-boot =
          if (!config.my.grub.enable) then {
            enable = true;
            configurationLimit = 10;
            consoleMode = "max";
          } else {
            enable = false;
          };
      };
      tmp = {
        useTmpfs = true;
        tmpfsSize = "20%";
      };
      binfmt.registrations.appimage = {
        wrapInterpreterInShell = false;
        interpreter = "${pkgs.appimage-run}/bin/appimage-run";
        recognitionType = "magic";
        offset = 0;
        mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
        magicOrExtension = ''\x7fELF....AI\x02'';
      };
    };
    environment.systemPackages = [ pkgs.efibootmgr ];
  };
}
