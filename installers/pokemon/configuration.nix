{ inputs, config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
      inputs.disko.nixosModules.disko
      ./disk-config.nix
    ];

  boot = {
    initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    loader.grub = {
      enable = true;
      efiSupport = false;
    };
  };

  environment.systemPackages = [ pkgs.helix pkgs.git ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    extraConfig = "PermitUserEnvironment yes";
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519";
        type = "ed25519";
      }
    ];
  };

  programs.ssh.startAgent = true;

  services.sshd.enable = true;

  security.pam = {
    enableSSHAgentAuth = true;
    services.sudo.sshAgentAuth = true;
  };

  users = {
    mutableUsers = false;
    users.as = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "keys" ];
      openssh.authorizedKeys.keyFiles = [
        ../../identities/id_ed25519_as.pub
      ];
      hashedPassword = "$y$j9T$5z.blnJWISrsCPyU6Li5.0$OyJ01uHXr.piHLHBesWg/LLPufFTLoS5jVYLGVqLNL3";
    };
    users.root.hashedPassword = "*";
  };

  nix.settings.trusted-users = [ "root" "as" ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
  networking.hostName = "pokemon";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "24.05";
}
