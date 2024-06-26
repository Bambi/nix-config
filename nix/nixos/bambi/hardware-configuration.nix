# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }: {
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelParams = [ "i915.enable_guc=2" "i915.fastboot=1" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/mapper/vg0-nixos";
      fsType = "btrfs";
      options = [ "noatime" "discard=async" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/6538015a-7eae-4076-b7a8-87aff536249b";
      fsType = "btrfs";
      options = [ "noatime" "discard=async" "compress-force=zstd:2" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/DCE9-D759";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/84d48902-bc65-4be9-b80c-ec9d1009e851"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault false;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.virbr0.useDHCP = lib.mkDefault true;
  # just declare main interfaces. They are configured in networking.nix
  networking.interfaces.eno1 = { };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    # Enable all firmware regardless of license.
    enableAllFirmware = true;

    # Enable firmware with a license allowing redistribution.
    enableRedistributableFirmware = true;

    # update the CPU microcode for Intel processors.
    cpu.intel.updateMicrocode = true;
  };
}
