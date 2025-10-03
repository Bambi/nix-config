_: {
  system = "x86_64-linux";
  modules = [
    ./home.nix
    { home.stateVersion = "24.11"; }
  ];
  home = {
    username = "as";
    homeDirectory = "/home/as";
  };
}
