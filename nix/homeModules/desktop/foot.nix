{ pkgs, ... }: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Monospace:size=12";
        # dpi-aware = "no";
        # resize-delay-ms = 0;
        # pad = "20x20";
      };
      cursor = {
        style = "beam";
        beam-thickness = "2px";
      };
      colors = {
        foreground = "ffffff";
        background = "242424";
      };
    };
  };
}
