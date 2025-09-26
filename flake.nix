{
  description = "NixOS/home-manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/v1.11.0";
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
      url = "github:nix-community/nixos-wsl/2411.6.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi-plugins = {
      url = "github:yazi-rs/plugins?rev=9a095057d698aaaedc4dd23d638285bd3fd647e9";
      flake = false;
    };
    yazi-starship = {
      url = "github:Rolv-Apneseth/starship.yazi?rev=6fde3b2d9dc9a12c14588eb85cf4964e619842e6";
      flake = false;
    };
    namaka = {
      url = "github:nix-community/namaka/v0.2.1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    plymouth-themes = {
      url = "github:adi1090x/plymouth-themes";
      flake = false;
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-sweep = {
      url = "github:jzbor/nix-sweep/v0.7.0";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flakelight, ... }@inputs:
    flakelight ./.
      {
        inherit inputs;
        lib.network = import ./network.nix inputs.nixpkgs.lib;
        systems = [ "x86_64-linux" ];
        withOverlays = [
          inputs.self.overlays.overrides
          inputs.nur.overlays.default
        ];
        formatter = pkgs: pkgs.nixpkgs-fmt;
      } // {
      deploy = import ./deploy.nix { inherit inputs; };
      checks = import ./tests.nix { inherit self; inherit inputs; };
    };
}
