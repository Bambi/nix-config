{ pkgs, config, lib, inputs, ... }: {
  # Bootloader.
  options.my.grub.enable = inputs.self.lib.mkBoolOpt false "Use Grub for boot.";

  config = lib.mkMerge [
    {
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
        plymouth = {
          enable = false;
          font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
          themePackages = [ pkgs.catppuccin-plymouth ];
          theme = "catppuccin-macchiato";
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
    }
    (lib.mkIf config.my.desktop.enable {
      console = {
        earlySetup = false;
        # console fonts in /etc/kbd/consolefonts
        font = "Lat2-Terminus16";
        colors = [
          "24273a"
          "ed8796"
          "a6da95"
          "eed49f"
          "8aadf4"
          "f5bde6"
          "8bd5ca"
          "cad3f5"
          "5b6078"
          "ed8796"
          "a6da95"
          "eed49f"
          "8aadf4"
          "f5bde6"
          "8bd5ca"
          "a5adcb"
        ];
      };
    })
  ];
}
