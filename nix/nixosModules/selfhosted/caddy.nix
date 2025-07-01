{ config, pkgs, lib, ... }: {
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/mholt/caddy-webdav@v0.0.0-20250609161527-33ba3cd2088c" ];
      hash = "sha256-omjRThhI8RhRLr7SUp4NY/nHpEV0WX2YIsah0kussz0=";
    };
    email = "asgambato@gmail.com";
    logFormat = ''
      level DEBUG
    '';
    globalConfig = ''
      debug
    '';
    virtualHosts."${config.networking.fqdn}" = {
      extraConfig = ''
        route {
          rewrite /calibre /calibre/
          reverse_proxy /calibre/* [::1]:8083 {
            header_up +X-Scheme        {http.request.scheme}
            header_up +X-Script-Name   /calibre
          }
          rewrite /dav /dav/
          basicauth /dav/* {
            gribouille $2a$10$OZ1dEJL4dJzTfB1mf9QrpenUa87UwxnbDcgu5bNTasVqYWvqCAFhG
          }
          webdav /dav/* {
            root /data/webdav
            prefix /dav
          }
          reverse_proxy /dav/* 127.0.0.1:6065 {
            header_up +X-Real-IP       {http.request.remote}
            header_up +REMOTE-HOST     {http.request.remote}
            header_up Host             {upstream_hostport}
          }
          respond "OK"
        }
      '';
    };
  };
  systemd.tmpfiles.rules = [
    "d /data/webdav 0770 caddy caddy -"
  ];
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
