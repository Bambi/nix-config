{ config, pkgs, ... }: {
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/mholt/caddy-webdav@v0.0.0-20250609161527-33ba3cd2088c"
      ];
      hash = "sha256-Qbu+xrIz8JywcbIJx+jHQ5pLdYdKPbOVz/HXO5qHNB0=";
    };
    email = "asgambato@gmail.com";
    logFormat = ''
      level DEBUG
    '';
    globalConfig = ''
      debug
      order webdav after basic_auth
    '';
    virtualHosts."${config.networking.fqdn}" = {
      logFormat = ''
        output file ${config.services.caddy.logDir}/access-${config.networking.fqdn}.log {
          mode 0644
        }
      '';
      extraConfig = ''
        rewrite /dav /dav/
        handle /dav/* {
          basic_auth {
            gribouille $2a$10$OZ1dEJL4dJzTfB1mf9QrpenUa87UwxnbDcgu5bNTasVqYWvqCAFhG
          }
          webdav {
            root /data/webdav
            prefix /dav
          }
        }
        rewrite /kor /kor/
        handle_path /kor/* {
          reverse_proxy 127.0.0.1:8082
        }
        handle {
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
