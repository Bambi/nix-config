# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernelParams = [
      "console=ttyS0,115200"
    ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault false;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  networking.interfaces = {
    lan = { };
    wan1 = { };
    enp3s0 = { };
    lan2 = { };
  };
  systemd.network.links = {
    "05-lan" = {
      matchConfig.PermanentMACAddress = "00:07:32:57:92:6c";
      linkConfig.Name = "lan";
    };
    "05-wan1" = {
      matchConfig.PermanentMACAddress = "00:07:32:57:92:6d";
      linkConfig.Name = "wan1";
    };
    "05-lan2" = {
      matchConfig.PermanentMACAddress = "00:07:32:57:92:6f";
      linkConfig.Name = "lan2";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
# hardware specs:
# - Celeron N3350
# - 4 ethernet interfaces
# - 2go ram
# - 1 sata SSD 200go
# - 8Go mmc
# - 2x USB 3.0
