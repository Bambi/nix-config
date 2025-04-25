{ inputs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./lix.nix
    ./ssh.nix
    ./as-user.nix
    ./security.nix
    ./usb.nix
    ./system.nix
    ./services.nix
  ];
}
