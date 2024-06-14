{ inputs, ... }: {
  system = "x86_64-linux";
  modules = [
    ./common/home.nix
    inputs.self.homeModules.minimal
    inputs.self.homeModules.tui
    inputs.self.homeModules.tui2
    inputs.self.homeModules.desktop
    inputs.sops-nix.homeManagerModules.sops
    {
      home = {
        username = "as";
        homeDirectory = "/home/as";
      };
    }
  ];
}
