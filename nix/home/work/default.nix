{ inputs, ... }: {
  system = "x86_64-linux";
  modules = [
    ./home.nix
    inputs.sops-nix.homeManagerModules.sops
    {
      home = {
        username = "as";
        homeDirectory = "/home/as";
      };
    }
  ];
}
