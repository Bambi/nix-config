{ config, lib, pkgs, inputs, ... }: {
  options.my.wireless = {
    enable = inputs.self.lib.mkBoolOpt false "Enable Wifi/Bluetooh support.";
  };

  config = lib.mkIf config.my.wireless.enable {
    # Wireless secrets stored through sops
    sops.secrets.wireless = {
      sopsFile = ../../nixos/${config.networking.hostName}/secrets.yaml;
      neededForUsers = false;
    };

    networking.wireless = {
      enable = true;
      fallbackToWPA2 = true;
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
        ctrl_interface=DIR=/run/wpa_supplicant.sock GROUP=wheel
      '';
    };

    networking.networkmanager = {
      wifi.powersave = true;
      unmanaged = [ "*,except:type:wifi,except:type:wwan,except:type:ethernet" ];
    };

    # Ensure group exists
    users.groups.network = { };

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
