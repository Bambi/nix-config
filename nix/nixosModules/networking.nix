{ pkgs, lib, config, ... }: {
  systemd.network = {
    enable = true;
    networks = lib.mapAttrs'
      (
        itf: val: lib.nameValuePair "10-${itf}" {
          matchConfig.Name = itf;
          networkConfig = {
            DHCP = "ipv4";
            DNSSEC = true;
            DNSOverTLS = false;
            MulticastDNS = true;
            LLMNR = false;
            Domains = "~.";
          };
          linkConfig = {
            Multicast = true;
          };
        }
      )
      config.networking.interfaces;
    wait-online.anyInterface = true;
  };
  networking = {
    extraHosts = ''
      192.168.0.1 musclor
      192.168.0.2 cubie
    '';
  };
  services.resolved = {
    enable = true;
    llmnr = "false";
    dnssec = "true";
    fallbackDns = [ "8.8.8.8" "2001:4860:4860::8844" ]; # fbx: fd0f:ee:b0::1
    dnsovertls = "opportunistic";
  };
  networking.firewall.allowedUDPPorts = [ 5353 ];
}
