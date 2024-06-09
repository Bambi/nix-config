# Enable Services & utilities
{ pkgs, lib, config, ... }: {
  config = lib.mkMerge [
    {
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
    (lib.mkIf config.my.desktop.enable {
      services.geoclue2.enable = true;
      programs.direnv.enable = true;
      programs.fish.enable = true;
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
      ];
    })
    (lib.mkIf config.my.laptop.enable {
      services.upower.enable = true;
      services.auto-cpufreq.enable = true;
    })
  ];
}
