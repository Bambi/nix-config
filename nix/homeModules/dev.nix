{ pkgs, ... }: {
  home.packages = with pkgs; [
    mold
    gcc13
    gnumake
  ];
}
