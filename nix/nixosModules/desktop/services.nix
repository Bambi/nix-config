{ pkgs, ... }: {
  services = {
    dbus.packages = with pkgs; [
      xfce.xfconf
      gnome2.GConf
    ];
    tumbler.enable = true;
    flatpak.enable = true;
  };
  programs.thunar.enable = true;

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
  };

  environment.systemPackages = with pkgs; [
    qutebrowser
    kitty
  ];
}
