# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, inputs, ... }: {
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
  };
  time.timeZone = "Europe/Paris";
  wsl = {
    enable = true;
    defaultUser = "as";
    startMenuLaunchers = true;
    wslConf.automount.root = "/mnt";
    wslConf.network.generateResolvConf = true;
    nativeSystemd = true;
    interop.includePath = false;
  };

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
}
