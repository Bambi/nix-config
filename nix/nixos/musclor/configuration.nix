# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
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
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.self.nixosModules.common
      inputs.self.nixosModules.bootloader
      inputs.self.nixosModules.networking
      inputs.self.nixosModules.nebula
      inputs.self.nixosModules.tpm2
      inputs.self.nixosModules.virtualization
      inputs.self.nixosModules.desktop
      inputs.self.nixosModules.syncthing
      inputs.self.nixosModules.qmk
    ];

  my = {
    user = "as";
    nebula.enable = true;
    grub.enable = false;
    interfaces.eno1 = {
      networkAccess = true;
    };
    syncthing.id = "LUAVW4J-L3ZAIHO-IWH34V3-DRPJUCC-6RESAJH-NDZJ5M5-R2XRKPO-7X7OSAC";
  };
  networking = {
    hostName = "musclor";
    networkmanager.enable = false;
  };
  time.timeZone = "Europe/Paris";
  boot.kernelParams = [ "fbcon=nodefer" "vt.global_cursor_default=0" "video4linux" ];

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
    interval = "monthly";
  };

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
