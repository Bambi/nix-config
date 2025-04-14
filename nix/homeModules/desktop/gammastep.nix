_: {
  services.gammastep = {
    enable = true;
    temperature.day = 6500;
    temperature.night = 3600;
    # provider = "geoclue2";
    latitude = 48.7;
    longitude = 2.3;
    settings = {
      general = {
        fade = true;
        brightness-day = 1;
        brightness-night = 0.75;
        adjustment-method = "wayland";
      };
    };
  };
}
