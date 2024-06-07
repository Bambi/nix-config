{ inputs, ... }: {
  imports = [
    ./minimal.nix
    ./tpm.nix
    ./sound.nix
    ./display-manager.nix
    ./utils.nix
    ./python.nix
  ];
}
