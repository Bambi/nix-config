_: {
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    settings = {
      font-family = "JetBrainsMono NF";
      font-size = 12;
      theme = "Gruvbox Dark";
      background-opacity = 0.8;
      minimum-contrast = 1.1;
    };
  };
}
