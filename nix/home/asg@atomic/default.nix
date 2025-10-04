{ inputs, ... }: {
  system = "x86_64-linux";
  modules = [
    ../as-minimal/home.nix
    ./home.nix
    inputs.self.homeModules.tui
    { home.stateVersion = "25.05"; }
    inputs.sops-nix.homeManagerModules.sops
  ];
}
