{ pkgs, config, lib, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };
  # conf files from https://github.com/7KIR7/dots.git
  home.file.".config/waybar" = {
    source = ./minimal;
    recursive = true;
  };
}
