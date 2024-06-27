{ inputs, ... }: {
  system = "x86_64-linux";
  modules = [
    ../as-minimal/home.nix
    inputs.self.homeModules.tui
    inputs.self.homeModules.desktop
    { home.stateVersion = "23.11"; }
  ];
}
