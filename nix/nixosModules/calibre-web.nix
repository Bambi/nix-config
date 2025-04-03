{ publicIP, ... }:
let
  mediaPath = "/data/media/library";
in
{
  services.calibre-web = {
    enable = true;
    listen = {
      ip = publicIP;
    };
    options = {
      calibreLibrary = mediaPath;
      enableBookUploading = true;
      # enableBookConversion = true;
    };
    openFirewall = true;
  };
  systemd.tmpfiles.rules = [
    "d ${mediaPath} 0770 calibre-web calibre-web -"
  ];
  services.fail2ban.jails = {
    calibre-web = ''
      enabled = true
      filter = calibre-web
      port = http,https
    '';
  };
  environment.etc = {
    "fail2ban/filter.d/calibre-web.conf".text = ''
      [Definition]
      failregex = ^.*Login failed for user ".*" IP-address: <HOST>$
      journalmatch = _SYSTEMD_UNIT=calibre-web.service
    '';
  };
}
