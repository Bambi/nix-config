{ pkgs, inputs, wanItf, bindItfs, allowedIps, ... }: {
  services.unbound = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      server = {
        # listening interfaces
        interface = [ "lo" ] ++ bindItfs;
        access-control = (map (x: x + " allow") allowedIps)
          ++ [
          "0.0.0.0/0 refuse"
          "2a01:e0a:34f:f6c0::/64 allow"
          "fe80::/10 allow"
          "fd00::/8 allow"
          "::0/0 refuse"
          "::1 allow"
          "127.0.0.0/8 allow"
        ];
        verbosity = 1;
        # Other settings
        cache-max-ttl = 86400;
        # Security
        # Harden against algorithm downgrade when multiple algorithms are
        # advertised in the DS record.
        harden-algo-downgrade = "yes";

        # RFC 8020. returns nxdomain to queries for a name below another name that
        # is already known to be nxdomain.
        harden-below-nxdomain = "yes";

        # Require DNSSEC data for trust-anchored zones, if such data is absent, the
        # zone becomes bogus. If turned off you run the risk of a downgrade attack
        # that disables security for a zone.
        harden-dnssec-stripped = "yes";

        # Only trust glue if it is within the servers authority.
        harden-glue = "yes";

        # Ignore very large queries.
        harden-large-queries = "yes";

        # Perform additional queries for infrastructure data to harden the referral
        # path. Validates the replies if trust anchors are configured and the zones
        # are signed. This enforces DNSSEC validation on nameserver NS sets and the
        # nameserver addresses that are encountered on the referral path to the
        # answer. Experimental option.
        harden-referral-path = "no";

        # Ignore very small EDNS buffer sizes from queries.
        harden-short-bufsize = "yes";

        # Refuse id.server and hostname.bind queries
        hide-identity = "yes";

        # Refuse version.server and version.bind queries
        hide-version = "yes";

        # TLS for upstream requests
        tls-system-cert = "yes";
      };
      forward-zone = [
        {
          name = ".";
          forward-tls-upstream = "yes";
          forward-addr = [
            "2620:fe::fe@853#dns.quad9.net"
            "9.9.9.9@853#dns.quad9.net"
            "2620:fe::9@853#dns.quad9.net"
            "149.112.112.112@853#dns.quad9.net"
            "2606:4700:4700::1111@853#cloudflare-dns.com"
            "1.1.1.1@853#cloudflare-dns.com"
            "2606:4700:4700::1001@853#cloudflare-dns.com"
            "1.0.0.1@853#cloudflare-dns.com"
          ];
        }
      ];
      include = "/etc/unbound/blocklist";
      remote-control.control-enable = true;
    };
  };
  environment = {
    etc."unbound/blocklist".source = "${inputs.unbound-block-list}/unbound/pro.blacklist.conf";
    systemPackages = [ pkgs.cacert ];
  };
}
