{ inputs, ... }: {
  system = "x86_64-linux";
  modules = [
    ./common/home.nix
    inputs.self.homeModules.minimal
    {
      home = {
        username = "as";
        homeDirectory = "/home/as";
      };
    }
  ];
}
