{ pkgs, ... }: {
  nix = {
    package = pkgs.lix;
    settings = {
      build-dir = "/var/tmp";
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };
  environment.systemPackages = [ pkgs.cachix ];
}
