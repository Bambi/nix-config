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
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
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
  };

  outputs = { flakelight, ... }@inputs:
    flakelight ./.
      {
        inherit inputs;
        systems = [ "x86_64-linux" ];
        # withOverlays = [ inputs.self.overlays.nebula ];
        devShell = pkgs: {
          env.NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
          packages = with pkgs; [
            helix
            pkgs.home-manager
            nixos-rebuild
            bat
            just
            bitwarden-cli
            jq
            sops
            ssh-to-age
            pv
            deploy-rs
            nebula
            nh
          ];
        };
        formatter = pkgs: pkgs.nixpkgs-fmt;
      } // {
      deploy = import ./deploy.nix { inherit inputs; };
    };
}
