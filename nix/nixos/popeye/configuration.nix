# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, inputs, pkgs, ... }:
let
  disk-config = import ./disk-config.nix;
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.disko.nixosModules.disko
      disk-config
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-intel-disable
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.self.nixosModules.common
      inputs.self.nixosModules.bootloader
      inputs.self.nixosModules.networking
      # inputs.self.nixosModules.nebula
      # inputs.self.nixosModules.unbound
      # inputs.self.nixosModules.syncthing
      inputs.self.nixosModules.wanaccess
      ./git-user.nix
      {
        _module.args = {
          lanItf = "lan";
          wanItf = "wan1";
          boxMacAddr = "9C:24:72:AB:D1:90";
          hostList = import ./network.nix "192.168.0";
          # # hiding my freebox MAC address
          # fbMacAddr = builtins.readFile
          #   (builtins.fetchGit
          #     {
          #       url = "ssh://git@github.com/Bambi/nix-data.git";
          #       ref = "main";
          #       rev = "961605ab3d395657588c996bef67fbede1566aa4";
          #     } + "/freeboxMacAddr");
        };
      }
    ];

  environment.systemPackages = with pkgs; [ tshark ];

  my = {
    # nebula = {
    #   enable = true;
    #   isLighthouse = true;
    #   nodeIP = "192.168.100.1";
    # };
    user = "as";
    interfaces.lan2 = {
      networkAccess = true;
      trusted = true;
    };
    # syncthing.id = "L4ZJKOD-FZQWQDK-PHEFKVT-5ZJ4HUJ-THDMOJ4-A7LVI6Q-432XAZQ-5PRLYQI";
    # syncthing.backup = true;
  };
  networking = {
    hostName = "popeye";
    networkmanager.enable = false;
    # interfaces.enp1s0.ipv4.addresses = [{
    #   address = "192.168.1.1";
    #   prefixLength = 24;
    # }];
  };
  # systemd.network.networks."lan2" = {
  #   matchConfig.Name = "lan2";
  #   networkConfig.DHCP = "ipv4";
  #   # address = [
  #   #   "192.168.1.1/24"
  #   # ];
  #   # routes = [
  #   #   { Gateway = "192.168.1.254"; }
  #   # ];
  # };
  time.timeZone = "Europe/Paris";

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
    interval = "monthly";
  };
}
