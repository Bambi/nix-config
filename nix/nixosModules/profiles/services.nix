# Enable Services
{ pkgs, lib, config, ... }: {
  config = {
    programs.dconf.enable = true;
    services.dbus.enable = true;
    services.fwupd.enable = true;
  } //
  lib.mkIf config.my.desktop.enable {
    services.geoclue2.enable = true;
    programs.direnv.enable = true;
    programs.fish.enable = true;

    environment.systemPackages = with pkgs; [
      at-spi2-atk
      psi-notify
      psmisc
      clipboard-jh
    ];
  } //
  lib.mkIf config.my.laptop.enable {
    services.upower.enable = true;
    services.auto-cpufreq.enable = true;
  };
}
