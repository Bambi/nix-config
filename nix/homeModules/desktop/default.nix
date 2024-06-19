{ config, lib, pkgs, inputs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./firefox.nix
    ./hyprland.nix
    ./waybar
    ./rofi.nix
    ./gammastep.nix
    ./theme.nix
    ./emanote.nix
    ./foot.nix
  ];
  colorScheme = lib.mkDefault colorSchemes.catppuccin-macchiato;
  home = {
    packages = with pkgs; [
      xdg-utils
      grim
      slurp
      swappy
      wlrctl
      gifsicle
      hyprpicker
      libnotify
      wf-recorder
      wl-clipboard
      ffmpeg_6-full
      cliphist
      imagemagick
      zathura
      mpv
      imv
      zeal
      syncthing
      magic-wormhole
      # docs
      zettlr
    ];
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Amber";
      size = 20;
    };
  };
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/Documents";
      music = "${config.home.homeDirectory}/Musique";
      pictures = "${config.home.homeDirectory}/Photos";
      videos = "${config.home.homeDirectory}/Vidéos";
      download = "${config.home.homeDirectory}/Téléchargements";
    };
  };
  # connect virt-manager with qemu hypervisor
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
