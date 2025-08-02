{ config, pkgs, ... }: {
  sops.secrets.crowdsec_apik = {
    owner = "caddy";
    mode = "0400";
  };
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/mholt/caddy-webdav@v0.0.0-20250609161527-33ba3cd2088c"
        "github.com/hslatman/caddy-crowdsec-bouncer@v0.9.2"
      ];
      hash = "sha256-wZP58jJ07D1ftrJteW8/VynGokbvxK237rPC8TN6jpQ=";
    };
    email = "asgambato@gmail.com";
    logFormat = ''
      level DEBUG
    '';
    globalConfig = ''
      debug
      order webdav after basic_auth
      order crowdsec before header
      crowdsec {
        import ${config.sops.secrets.crowdsec_apik.path}
        api_url http://[::]:8081 # see crowdsec api_uri
      }
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
      source = "file";
      filenames = ["/var/log/caddy/*.log"];
      labels.type = "caddy";
    }
  ];
}
