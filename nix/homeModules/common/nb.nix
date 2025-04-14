{ pkgs, ... }: {
  home.packages = [ pkgs.nb pkgs.w3m pkgs.socat ];
  xdg.configFile."fish/completions/nb.fish".source = "${pkgs.nb}/share/fish/vendor_completions.d/nb.fish";
}
