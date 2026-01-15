# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, lib, ... }:
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
      inputs.self.nixosModules.virtualisation
      inputs.self.nixosModules.desktop
      inputs.self.nixosModules.gnome
      inputs.self.nixosModules.dispm-gdm
      inputs.self.nixosModules.printing
      ./dm-user.nix
      {
        _module.args = {
          LHMeshIP = inputs.self.lib.network.lighthouseItf.addr;
          bindIps = inputs.self.lib.network.nebulaBindIps;
          isLH = false;
          bootTheme = "cuts";
        };
      }
    ];

  my = {
    interfaces.eno1 = { };
  };
  networking = {
    hostName = "bianca";
    networkmanager.enable = false;
  };
  time.timeZone = "Europe/Paris";
  boot.kernelParams = [ "fbcon=nodefer" "vt.global_cursor_default=0" "video4linux" ];
  services.displayManager.autoLogin = {
    enable = true;
    user = "dm";
  };
  programs.ssh.startAgent = lib.mkForce false;

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
  system.stateVersion = "24.11"; # Did you read the comment?
}
