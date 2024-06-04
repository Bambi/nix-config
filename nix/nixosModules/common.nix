{ inputs, ... }: {
  imports = [
    ./minimal.nix
    ./tpm.nix
    ./sound.nix
    ./display-manager.nix
    ./services.nix
    ./utils.nix
    ./gc.nix
    ./python.nix
    ./virtualization.nix
  ];
}
