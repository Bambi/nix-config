{ inputs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./i18n.nix
    ./console.nix
    ./users.nix
    ./security.nix
    ./networking.nix
    ./usb.nix
    ./utils.nix
  ];

  environment.variables = {
    EDITOR = "hx";
  };
}
