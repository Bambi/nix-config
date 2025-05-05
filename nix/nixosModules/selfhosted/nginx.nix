{ config, pkgs, ... }: {
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
    virtualHosts."${config.networking.fqdn}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        extraConfig = ''
          auth_request /auth/validate;
          auth_request_set $auth_user $upstream_http_x_vouch_user;
          auth_request_set $auth_roles $upstream_http_x_vouch_idp_claims_roles;

          auth_request_set $auth_cookie $upstream_http_set_cookie;
          add_header Set-Cookie $auth_cookie;
          auth_request_set $auth_status $upstream_status;
        '';
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "asgambato@gmail.com";
    defaults.group = "nginx";
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # /var/lib/acme/.challenges must be writable by the ACME user
  # and readable by the Nginx user. The easiest way to achieve
  # this is to add the Nginx user to the ACME group.
  users.users.nginx.extraGroups = [ "acme" ];

  # Defines a filter that detects URL probing by reading the Nginx access log
  environment.etc = {
    "fail2ban/filter.d/nginx-url-probe.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [Definition]
      failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
    '');
  };
  services.fail2ban.jails = {
    nginx-url-probe.settings = {
      enabled = true;
      filter = "nginx-url-probe";
      logpath = "/var/log/nginx/access.log";
      action = ''nftables[type=multiport, name=HTTP, port="http,https"]'';
      backend = "auto"; # Do not forget to specify this if your jail uses a log file
    };
    nginx-bad-request.settings = {
      enable = true;
      filter = "nginx-bad-request";
      logpath = "/var/log/nginx/access.log";
      action = ''nftables[type=multiport, name=HTTP, port="http,https"]'';
      backend = "auto";
    };
  };
}
