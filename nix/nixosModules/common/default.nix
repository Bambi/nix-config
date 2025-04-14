{ inputs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./ssh.nix
    ./users.nix
    ./security.nix
    ./usb.nix
    ./system.nix
    ./services.nix
  ];
}
