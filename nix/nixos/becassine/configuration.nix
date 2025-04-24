# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, inputs, ... }: {
  imports =
    [
      inputs.nixos-wsl.nixosModules.wsl
      inputs.self.nixosModules.common
      inputs.self.nixosModules.nebula
      {
        _module.args = {
          inherit (inputs.self.lib.network) publicIP;
          LHMeshIP = (inputs.self.lib.network.lighthouseItf "popeye").addr;
          isLH = false;
        };
      }
    ];

  my = {
    user = "as";
  };
  networking = {
    hostName = "becassine";
    networkmanager.enable = false;
    useNetworkd = true;
  };
  time.timeZone = "Europe/Paris";
  wsl = {
    enable = true;
    defaultUser = "as";
    startMenuLaunchers = true;
    wslConf.automount.root = "/mnt";
    wslConf.network.generateResolvConf = false;
    interop.includePath = false;
  };
  systemd = {
    network.networks."10-eth0" = {
      matchConfig.Name = "eth0";
      linkConfig.Unmanaged = true;
    };
    # wsl main interface is not managed by networkd
    # but I need to set DNS on this interface...
    services.setup-dns = {
      description = "setup DNS for main WSL interface";
      serviceConfig = {
        ExecStart = "${pkgs.systemd}/bin/resolvectl dns eth0 1.1.1.1";
        Type = "oneshot";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
  services.resolved = {
    enable = true;
    llmnr = "false";
    dnssec = "true";
    fallbackDns = [ "8.8.8.8" ];
    dnsovertls = "opportunistic";
  };

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
}
