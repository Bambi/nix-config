{ config, ... }: {
  services.flameshot = {
    enable = true;

    settings = {
      General = {
        drawColor = "#ff0000";
        drawFontSize = 23;
        drawThickness = 3;

        # flameshot does not support UTF-8 characters in config file
        # savePath = config.xdg.userDirs.download;
        savePath = config.xdg.userDirs.desktop;
        savePathFixed = false;

        disabledTrayIcon = true;
        showDesktopNotification = false;
        showHelp = false;

        uiColor = "#ffffff";
      };
    };
  };
}
