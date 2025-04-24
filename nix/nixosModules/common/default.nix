{ inputs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./lix.nix
    ./ssh.nix
    ./users.nix
    ./security.nix
    ./usb.nix
    ./system.nix
    ./services.nix
  ];
}
