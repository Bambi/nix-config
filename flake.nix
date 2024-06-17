{
  description = "NixOS/home-manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    unbound-block-list = {
      url = "github:hagezi/dns-blocklists?ref=12024.163.1";
      flake = false;
    };
  };

  outputs = { flakelight, ... }@inputs:
    flakelight ./.
      {
        inherit inputs;
        devShell = pkgs: {
          env.NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
          packages = with pkgs; [
            nix
            pkgs.home-manager
            nixos-rebuild
            git
            bat
            just
            bitwarden-cli
            jq
            sops
            ssh-to-age
            pv
            deploy-rs
          ];
        };
        formatter = pkgs: pkgs.nixpkgs-fmt;
      } // {
      deploy = import ./deploy.nix { inherit inputs; };
    };
}
