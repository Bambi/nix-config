{ pkgs, inputs, lib, config, ... }: {
  options.my.networkAccess = inputs.self.lib.mkOpt lib.types.str null "Interface used for Internet access.";

  config = {
    services.unbound = {
      enable = true;
      resolveLocalQueries = true;
      settings = {
        server = {
          interface = [ "${config.my.networkAccess}" "lo" "nebula.mesh" ];
          access-control = [
            "192.168.0.0/24 allow"
            "2a01:e0a:34f:f6c0::/64 allow"
            "fe80::/10 allow"
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
          tls-upstream = "yes";
          tls-system-cert = "yes";
        };
        include = "/etc/unbound/blocklist";
        remote-control.control-enable = true;
      };
    };
    environment = {
      etc."unbound/blocklist".source = "${inputs.unbound-block-list}/unbound/pro.blacklist.conf";
      systemPackages = [ pkgs.cacert ];
    };
    networking.firewall.interfaces."${config.my.networkAccess}" = {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };
  };
}
