# Currently not used as dedyn.io NS records cannot be modified
{ inputs, pkgs, wanItf, ... }:
let
  inherit (inputs.self.lib.network) publicIP publicIP6;
in
 {
  services.bind = {
    enable = true;
    listenOn = [ "${publicIP}" ];
    listenOnIpv6 = [ "${publicIP6}" ];
    zones = {
      "bambi.ftp.sh" = {
        master = true;
        file = pkgs.writeText "zone-bambi.ftp.sh" ''
          $ORIGIN bambi.ftp.sh.
          $TTL    1h
          @       IN      SOA     ns1 asgambato.gmail.com. (
                                      1    ; Serial
                                      3h   ; Refresh
                                      1h   ; Retry
                                      1w   ; Expire
                                      1h)  ; Negative Cache TTL
                  IN      NS      ns1

          @       IN      A       ${publicIP}
                  IN      AAAA    ${publicIP6}

          fb      IN      A       ${publicIP}
                  IN      AAAA    ${publicIP6}

          ns1     IN      A       ${publicIP}
                  IN      AAAA    ${publicIP6}
        '';
      };
    };
    # allow bind data on public interface
    networking.firewall.interfaces."${wanItf}" = {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };
  };
}
