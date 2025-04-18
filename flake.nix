{
  description = "NixOS/home-manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/v1.6.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf/v0.7";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    unbound-block-list = {
      url = "github:hagezi/dns-blocklists";
      flake = false;
    };
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi-plugins = {
      url = "github:yazi-rs/plugins?rev=02d18be03812415097e83c6a912924560e4cec6d";
      flake = false;
    };
    yazi-starship = {
      url = "github:Rolv-Apneseth/starship.yazi?rev=f6939fbdbc3fdfcdc2a80251841e429e0cd5cf3c";
      flake = false;
    };
  };

  outputs = { flakelight, ... }@inputs:
    flakelight ./.
      {
        inherit inputs;
        lib.network = import ./network.nix inputs.nixpkgs.lib;
        systems = [ "x86_64-linux" ];
        withOverlays = [ inputs.self.overlays.overrides ];
        formatter = pkgs: pkgs.nixpkgs-fmt;
      } // {
      deploy = import ./deploy.nix { inherit inputs; };
    };
}
