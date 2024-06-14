{ config, pkgs, ... }: {
  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" ];
    historyFileSize = 4000;
    shellAliases = { };
  };
}
