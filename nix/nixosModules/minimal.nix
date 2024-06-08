{ inputs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./security.nix
    ./networking.nix
    ./usb.nix
  ];

  environment.variables = {
    EDITOR = "hx";
  };
}
