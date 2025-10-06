{ pkgs, ... }: {
  programs.navi = {
    enable = true;
    enableFishIntegration = true;
  };
  home.packages = [ pkgs.tlrc ];
  xdg.configFile."tlrc/config.toml".text = ''
    [output]
    compact = true
  '';
}
