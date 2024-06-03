{ inputs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./bootloader.nix
    ./linux-kernel.nix
    ./tpm.nix
    ./i18n.nix
    ./console.nix
    ./users.nix
    ./security.nix
    ./ssh.nix
    ./networking.nix
    ./sound.nix
    ./usb.nix
    ./display-manager.nix
    ./services.nix
    ./utils.nix
    ./gc.nix
    ./python.nix
    ./virtualization.nix
  ];

  environment.variables = {
    EDITOR = "hx";
  };
}
