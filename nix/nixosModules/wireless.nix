{ config, lib, pkgs, inputs, ... }: {
  options.my.wireless = {
    enable = inputs.self.lib.mkBoolOpt false "Enable Wifi/Bluetooh support.";
  };

  config = lib.mkIf config.my.wireless.enable {
    # Wireless secrets stored through sops
    sops.secrets.wireless = {
      sopsFile = ../nixos/${config.networking.hostName}/secrets.yaml;
      neededForUsers = true;
    };

    networking.wireless = {
      enable = true;
      fallbackToWPA2 = false;
      # Declarative
      environmentFile = config.sops.secrets.wireless.path;
      networks = {
        "Fripouille_ap" = {
          psk = "@FRIPOUILLE@";
        };
        bambi = {
          psk = "@BAMBI@";
        };
        singoalla = {
          psk = "@SINGOALLA@";
        };
        vagabonde = {
          psk = "@VAGABONDE@";
        };
        vagabonde_EXT = {
          psk = "@VAGABONDE@";
        };
      };

      # Imperative
      allowAuxiliaryImperativeNetworks = true;
      # userControlled = {
      #   enable = true;
      #   group = "network";
      # };
      extraConfig = ''
        update_config=1
      '';
    };

    networking.networkmanager = {
      wifi.powersave = true;
    };

    # Ensure group exists
    users.groups.network = { };

    systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";

    # bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    environment.systemPackages = [
      pkgs.bluez
    ];
  };
}
