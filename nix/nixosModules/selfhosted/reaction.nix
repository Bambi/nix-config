{ config, ... }: {
  imports = [ ./_reaction.nix ];
  services.reaction = {
    enable = true;
    runAsRoot = true;
    loglevel = "WARN";
    settings = {
      patterns = {
        ip = {
          regex = ''((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])|(([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}|([0-9A-Fa-f]{1,4}:){1,7}:|:(:[0-9A-Fa-f]{1,4}){1,7}|([0-9A-Fa-f]{1,4}:){1,6}:[0-9A-Fa-f]{1,4}|([0-9A-Fa-f]{1,4}:){1,5}(:[0-9A-Fa-f]{1,4}){1,2}|([0-9A-Fa-f]{1,4}:){1,4}(:[0-9A-Fa-f]{1,4}){1,3}|([0-9A-Fa-f]{1,4}:){1,3}(:[0-9A-Fa-f]{1,4}){1,4}|([0-9A-Fa-f]{1,4}:){1,2}(:[0-9A-Fa-f]{1,4}){1,5}|[0-9A-Fa-f]{1,4}:(:[0-9A-Fa-f]{1,4}){1,6}|:(:[0-9A-Fa-f]{1,4}){1,6}))'';
          ignore = [
            "127.0.0.1"
            "::1"
          ];
        };
      };
      start = [
        [ "nft" ''
          table inet reaction {
            set ipv4bans {
              type ipv4_addr
              flags interval
              auto-merge
            }
            set ipv6bans {
              type ipv6_addr
              flags interval
              auto-merge
            }
            chain input {
              type filter hook input priority 0
              policy accept
              ip saddr @ipv4bans drop
              ip6 saddr @ipv6bans drop
            }
          }
        '']
      ];
      stop = [
        [ "nft" "delete table inet reaction" ]
      ];
      streams =
      let
        nftablesBan   = [ "${config.services.reaction.package}/bin/nft46" "add element inet reaction ipvXbans { <ip> }" ];
        nftablesUnban = [ "${config.services.reaction.package}/bin/nft46" "delete element inet reaction ipvXbans { <ip> }" ];
        banFor = duration: {
          ban = {
            cmd = nftablesBan;
          };
          unban = {
            cmd = nftablesUnban;
            after = duration;
          };
        };
      in
      {
        ssh = {
          cmd = [ "${config.systemd.package}/bin/journalctl" "-fn0" "-u" "sshd.service" ];
          filters = {
            failedlogin = {
              regex = [
                "authentication failure;.*rhost=<ip>(?: |$)"
                "Failed password for .* from <ip> port"
                "Invalid user .* from <ip> "
                "Connection (?:reset|closed) by invalid user .* <ip> port"
              ];
              retry = 3;
              retryperiod = "6h";
              actions = banFor "48h";
            };
            connectionreset = {
              regex = [
                "Connection (?:reset|closed) by(?: authenticating user .*)? <ip> port"
                "Received disconnect from <ip> port .*[preauth]"
                "Timeout before authentication for connection from <ip> to"
              ];
              retry = 2;
              retryperiod = "6h";
              actions = banFor "${toString (7 * 24)}h";
            };
          };
        };
        kernel = {
          cmd = [ "${config.systemd.package}/bin/journalctl" "-fn0" "-k" ];
          filters.portscan = {
            regex = [ "refused connection: .*SRC=<ip>" ];
            retry = 4;
            retryperiod = "1h";
            actions = banFor "${toString (30 * 24)}h";
          };
        };
        caddy = {
          cmd = [ "tail" "-n0" "-F" ] ++
            (builtins.map (vh: "/var/log/caddy/access-${vh}.log") [
              "calibre.as.dedyn.io"
              "fb.as.dedyn.io"
              "bambi.as.dedyn.io"
            ]);
          filters.bots = {
            regex = (builtins.map (bot: ''^.*"remote_ip":"<ip>",.*?"User-Agent":\[".*${bot}.*"\],.*$'') [
              "Googlebot/"
              "GPTBot/"
              "WanScannerBot/"
              "TurnitinBot"
            ]);
            actions = banFor "${toString (30 * 24)}h";
          };
        };
      };
    };
  };
}
