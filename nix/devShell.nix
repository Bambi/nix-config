pkgs: with pkgs; {
  packages = with pkgs; [
    nh
    statix
    deadnix
    namaka
    nixd
    deploy-rs
  ];
}
