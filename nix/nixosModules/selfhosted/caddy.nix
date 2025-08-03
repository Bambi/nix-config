{ config, pkgs, ... }: {
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
      order webdav after basic_auth
    '';
    virtualHosts."${config.networking.fqdn}" = {
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

  systemd.services.crowdsec.serviceConfig = {
    ExecStartPre = let
      script = pkgs.writeScriptBin "register-caddy" ''
        #!${pkgs.runtimeShell}
        set -eu
        set -o pipefail

        if ! cscli collections list | grep -q "caddy"; then
          cscli collections install "crowdsecurity/caddy"
        fi
      '';
    in ["${script}/bin/register-caddy"];
  };
  services.crowdsec.acquisitions = [
    {
      filenames = ["/var/log/caddy/*.log"];
      labels.type = "caddy";
    }
  ];
}
