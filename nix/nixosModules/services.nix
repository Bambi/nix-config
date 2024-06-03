{ pkgs, ... }:

{
  # Systemd services setup
  systemd.packages = with pkgs; [
    auto-cpufreq
  ];

  # Enable Services
  services.geoclue2.enable = true;
  programs.direnv.enable = true;
  services.upower.enable = true;
  programs.fish.enable = true;
  programs.dconf.enable = true;
  services.dbus.enable = true;
  services.fwupd.enable = true;
  services.auto-cpufreq.enable = true;

  environment.systemPackages = with pkgs; [
    at-spi2-atk
    psi-notify
    psmisc
    clipboard-jh
  ];
}
