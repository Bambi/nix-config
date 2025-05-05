{ config, ... }:
let
  mediaPath = "/data/media/library";
in
{
  services = {
    calibre-web = {
      enable = true;
      options = {
        calibreLibrary = mediaPath;
        enableBookUploading = true;
        # enableBookConversion = true;
      };
    };
    nginx.virtualHosts = {
      "${config.networking.fqdn}" = {
        locations = {
          "/calibre/" = {
            proxyPass = "http://[::1]:8083";
            extraConfig = ''
              proxy_set_header     X-Scheme        $scheme;
              proxy_set_header     X-Script-Name   /calibre;  # IMPORTANT: path has NO trailing slash
            '';
          };
          "/calibre".return = "301 $scheme://$host/calibre/";
        };
      };
    };
    fail2ban.jails = {
      calibre-web.settings = {
        enabled = true;
        filter = "calibre-web";
        port = "http,https";
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d ${mediaPath} 0770 calibre-web calibre-web -"
  ];
  environment.etc = {
    "fail2ban/filter.d/calibre-web.conf".text = ''
      [Definition]
      failregex = ^.*Login failed for user ".*" IP-address: <HOST>$
      journalmatch = _SYSTEMD_UNIT=calibre-web.service
    '';
  };
}
