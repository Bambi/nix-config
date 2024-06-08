# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }: {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.disko.nixosModules.disko
      ./disk-config.nix
      inputs.self.nixosModules.common
      inputs.self.nixosModules.profiles
    ];

  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  my = {
    user = "as";
    grub = inputs.self.lib.enabled;
  };
  networking = {
    hostName = "musclor";
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

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

