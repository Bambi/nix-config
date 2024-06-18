{ pkgs, ... }: {
  imports = [
    ./libvirt-networking.nix
  ];
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      # dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };

    libvirtd = {
      enable = true;
      qemu.runAsRoot = false;
      allowedBridges = [ "virbr0" ];
      networking = {
        enable = true;
        bridgeName = "virbr0";
        externalInterface = "eno1";
      };
    };
    # spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;
}
