{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    casign
    helix
    curl
    git
    tig
    bat
    ripgrep
    fd
    jq
    htop
    kmon
    lsof
    file
    lm_sensors
    ipcalc
    ethtool
    nvme-cli
    dterm
  ];
}
