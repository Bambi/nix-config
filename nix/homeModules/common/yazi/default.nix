{ pkgs, ... }: {
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
  home = {
    packages = [ pkgs.opener ];
    file = {
      # https://github.com/agryphus/archrice.git
      ".config/yazi" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
