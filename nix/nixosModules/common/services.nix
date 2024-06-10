# Enable Services & utilities
{ pkgs, lib, config, ... }: {
  programs.dconf.enable = true;
  services.dbus.enable = true;
  services.fwupd.enable = true;
  environment.systemPackages = with pkgs; [
    helix
    curl
    bat
    ripgrep
    fd
    lsof
    file
    lm_sensors
    ethtool
    htop
    kmon
    tcpdump
  ];
}
