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
      inputs.self.nixosModules.nebula
      inputs.self.nixosModules.unbound
      inputs.self.nixosModules.syncthing
      inputs.self.nixosModules.wanaccess
      inputs.self.nixosModules.wifiaccess
      inputs.self.nixosModules.calibre-web
      # inputs.self.nixosModules.paperless
      ./git-user.nix
      {
        _module.args = rec {
          # wanaccess
          lanItf = "lan";
          wanItf = "wan1";
          # nebula
          inherit (inputs.self.lib.network) publicIP;
          LHMeshIP = (inputs.self.lib.network.lighthouseItf "popeye").addr;
          isLH = true;
          # unbound
          bindItfs = [ lanItf "wlan" ];
          allowedIps = [ inputs.self.lib.network.lan.cidrv4 "192.168.1.0/24" ];
        };
      }
    ];

  environment.systemPackages = with pkgs; [ tshark ghostty.terminfo ];

  my = {
    user = "as";
    interfaces = {
      lan2 = {
        networkAccess = true;
        trusted = true;
      };
    };
    syncthing.id = "L4ZJKOD-FZQWQDK-PHEFKVT-5ZJ4HUJ-THDMOJ4-A7LVI6Q-432XAZQ-5PRLYQI";
    syncthing.backup = true;
  };
  networking = {
    hostName = "popeye";
    networkmanager.enable = false;
  };
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
