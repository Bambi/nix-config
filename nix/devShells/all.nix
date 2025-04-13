pkgs: with pkgs; {
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
}
