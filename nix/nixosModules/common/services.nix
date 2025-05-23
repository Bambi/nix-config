# Enable Services & utilities
{ pkgs, ... }: {
  programs.dconf.enable = true;
  programs.nix-ld.enable = true;
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
    trim-generations
    nix-tree
  ];
}
