{ config, pkgs, ... }: {

  systemd.services.vouch-proxy =
    let
      vouchConfig = {
        vouch = {
          logLevel = "info";
          listen = "[::1]";
          port = 30746;
          document_root = "/auth";

          domains = [ "bambi.nex.sh" "gmail.com" ];
          allowAllUsers = false;
          cookie = {
            domain = "bambi.nex.sh";
          };
        };
        oauth = {
          provider = "google";
          callback_urls = [
            "https://bambi.nex.sh/auth/auth"
          ];
        };
      };
    in
    {
      description = "Vouch-proxy";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.vouch-proxy}/bin/vouch-proxy \
            -config ${(pkgs.formats.yaml {}).generate "config.yml" vouchConfig}
        '';
        EnvironmentFile = config.sops.secrets.vouch_env.path;
        Restart = "on-failure";
        RestartSec = 5;
        WorkingDirectory = "/var/lib/vouch-proxy";
        StateDirectory = "vouch-proxy";
        RuntimeDirectory = "vouch-proxy";
        User = "vouch-proxy";
        Group = "vouch-proxy";
        StartLimitBurst = 3;
      };
    };

  sops.secrets.vouch_env = {
    sopsFile = ../../nixos/${config.networking.hostName}/secrets.yaml;
    owner = "vouch-proxy";
    mode = "0400";
  };

  users.users.vouch-proxy = {
    isSystemUser = true;
    group = "vouch-proxy";
  };
  users.groups.vouch-proxy = { };

  services.nginx.virtualHosts."${config.networking.fqdn}" = {
    locations = {
      "/auth" = {
        proxyPass = "http://[::1]:30746";
        extraConfig = ''
          proxy_pass_request_body off;
          proxy_set_header Content-Length "";
          # these return values are used by the @error401 call
          auth_request_set $auth_resp_jwt $upstream_http_x_vouch_jwt;
          auth_request_set $auth_resp_err $upstream_http_x_vouch_err;
          auth_request_set $auth_resp_failcount $upstream_http_x_vouch_failcount;
          # add_header Access-Control-Allow-Origin https://auth.erictapen.name;
        '';
      };
      "@error401".return = "302 https://bambi.nex.sh/auth/login?url=$scheme://$http_host$request_uri&vouch-failcount=$auth_resp_failcount&X-Vouch-Token=$auth_resp_jwt&error=$auth_resp_err";
    };
    extraConfig = ''
      # if /auth/validate returns `401 not authorized` then forward the request to the error401block
      error_page 401 = @error401;
    '';
  };
}
