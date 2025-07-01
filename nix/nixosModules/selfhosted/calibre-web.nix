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
  };
  systemd.tmpfiles.rules = [
    "d ${mediaPath} 0770 calibre-web calibre-web -"
  ];
}
