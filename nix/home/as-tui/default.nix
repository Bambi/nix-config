{ inputs, ... }: {
  system = "x86_64-linux";
  modules = [
    ../as-minimal/home.nix
    inputs.self.homeModules.tui
    { home.stateVersion = "23.11"; }
  ];
}
