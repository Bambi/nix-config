# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, inputs, ... }:
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
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      inputs.self.nixosModules.profiles
      inputs.self.nixosModules.common
      inputs.self.nixosModules.virtualization
      inputs.self.nixosModules.desktop
      inputs.self.nixosModules.zerotier
    ];

  my = {
    nebula.enable = true;
    laptop.enable = true;
    wireless.enable = true;
  };
  networking = {
    hostName = "babar";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
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
