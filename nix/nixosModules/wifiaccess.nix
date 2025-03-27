{ wanItf, ... }: {
  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "${wanItf}";
      PASSPHRASE = "12345678";
      SSID = "AS Wifi Hotspot";
      WIFI_IFACE = "wlan";
    };
  };
}
