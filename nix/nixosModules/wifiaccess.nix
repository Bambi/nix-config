{ ... }: {
  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "byteldata";
      PASSPHRASE = "12345678";
      SSID = "AS Wifi Hotspot";
      WIFI_IFACE = "wlan";
    };
  };
}
