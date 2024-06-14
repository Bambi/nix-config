{ inputs, ... }: {
  system = "x86_64-linux";
  modules = [
    ./common/home.nix
    inputs.self.homeModules.minimal
    inputs.sops-nix.homeManagerModules.sops
    {
      home = {
        username = "as";
        homeDirectory = "/home/as";
      };
    }
  ];
}
