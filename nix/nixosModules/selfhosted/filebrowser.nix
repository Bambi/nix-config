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
      baseURL = "/fb/";
    };
  };
  services.caddy.virtualHosts."${config.networking.fqdn}" = {
    extraConfig = ''
      rewrite /fb /fb/
      handle /fb/* {
        reverse_proxy localhost:${toString port}
      }
    '';
  };
  # systemd.services.filebrowser.serviceConfig.ExecStartPre = "";
}
