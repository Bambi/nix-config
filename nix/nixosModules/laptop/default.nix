{ pkgs, ... }: {
  imports = [
    ./services.nix
    ./wireless.nix
  ];
}
