{ inputs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./bootloader.nix
    ./linux-kernel.nix
    ./i18n.nix
    ./console.nix
    ./users.nix
    ./security.nix
    ./ssh.nix
    ./networking.nix
    ./usb.nix
    ./utils.nix
    ./gc.nix
  ];

  environment.variables = {
    EDITOR = "hx";
  };
}
