{ pkgs, inputs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./bootloader.nix
    ./ssh.nix
    ./users.nix
    ./security.nix
    ./usb.nix
    ./networking.nix
    ./system.nix
    ./services.nix
  ];
}
