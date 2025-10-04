{ inputs, ... }: {
  system = "x86_64-linux";
  modules = [
    ../as-minimal/home.nix
    ../as-tui/home.nix
    ./home.nix
    inputs.self.homeModules.tui
    inputs.self.homeModules.desktop
    inputs.sops-nix.homeManagerModules.sops
    { home.stateVersion = "23.11"; }
  ];
}
