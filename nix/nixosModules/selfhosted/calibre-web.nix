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
    caddy.virtualHosts."calibre.${config.networking.domain}" = {
      logFormat = ''
        output file ${config.services.caddy.logDir}/access-calibre.${config.networking.domain}.log {
          mode 0644
        }
      '';
      extraConfig = ''
        handle * {
          reverse_proxy [::1]:8083 {
            header_up +X-Scheme        {http.request.scheme}
          }
        }
      '';
    };
  };
  systemd.tmpfiles.rules = [
    "d ${mediaPath} 0770 calibre-web calibre-web -"
  ];
}
