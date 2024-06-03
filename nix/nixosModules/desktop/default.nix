{ config, lib, pkgs, ... }:

{
  imports = [
    ./screen-brightness.nix
    ./services.nix
    ./opengl.nix
    ./security.nix
  ];

  environment.systemPackages = with pkgs; [
    libva-utils
  ];
}
