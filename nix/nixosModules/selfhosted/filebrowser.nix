{ config, ... }:
let
  port = 8085;
in
{
  imports = [ ./_filebrowser.nix ];

  services.filebrowser = {
    enable = true;
    settings = {
      inherit port;
      root = "/data/filebrowser/data";
      database = "/data/filebrowser/database.db";
      # baseURL = "/fb/";
    };
  };
  services.caddy.virtualHosts."fb.${config.networking.domain}" = {
    logFormat = ''
      output file ${config.services.caddy.logDir}/access-fb.${config.networking.domain}.log {
        mode 0644
      }
    '';
    extraConfig = ''
      handle * {
        reverse_proxy localhost:${toString port}
      }
    '';
  };
  # systemd.services.filebrowser.serviceConfig.ExecStartPre = "";
}
