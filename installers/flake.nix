{
  description = "NixOS installers Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/v1.6.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { flakelight, ... } @ inputs:
    flakelight ./. {
      inherit inputs;
      nixosConfigurations = {
        clochette = {
          system = "x86_64-linux";
          modules = [
            ./clochette/configuration.nix
          ];
        };
        pokemon = {
          system = "x86_64-linux";
          modules = [
            ./pokemon/configuration.nix
          ];
        };
      };
    };
}
