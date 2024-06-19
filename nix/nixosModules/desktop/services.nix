{ pkgs, ... }: {
  console.useXkbConfig = true; # use xkbOptions in tty.
  services = {
    xserver = {
      enable = false;
      xkb = {
        layout = "us";
        variant = "intl";
      };
    };
    dbus.packages = with pkgs; [
      xfce.xfconf
      gnome2.GConf
    ];
    tumbler.enable = true;
    flatpak.enable = true;
    geoclue2.enable = true;
  };
  programs = {
    thunar.enable = true;
    direnv.enable = true;
    fish.enable = true;
  };
  location.provider = "geoclue2";

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
    git
    tig
    jq
    ipcalc
    nvme-cli
    dterm
    at-spi2-atk
    psi-notify
    psmisc
    clipboard-jh
    qutebrowser
    foot
    nuspell
    hyphen
    hunspell
    hunspellDicts.en_US
    hunspellDicts.fr-any
  ];
}
