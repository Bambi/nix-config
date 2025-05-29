_: {
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    settings = {
      font-family = "JetBrainsMono";
      font-size = 12;
      theme = "GruvboxDark";
      background-opacity = 0.8;
      minimum-contrast = 1.1;
    };
  };
}
