pkgs: with pkgs; {
  packages = with pkgs; [
    deploy-rs
    nh
    statix
    deadnix
  ];
}
