{ inputs, ... }: {
  system = "x86_64-linux";
  modules = [
    ./home.nix
    inputs.self.homeModules.common
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
