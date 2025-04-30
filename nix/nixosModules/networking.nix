{ lib, config, inputs, ... }:
let
  interfaceOpts = {
    options = {
      address = inputs.self.lib.mkOpt (lib.types.nullOr lib.types.str) null "Set interface IP address (DHCP otherwise)";
    };
  };
in
{
  options.my = {
    interfaces = inputs.self.lib.mkOpt (lib.types.attrsOf (lib.types.submodule interfaceOpts)) { } "Interfaces to configure.";
  };

  config = {
    systemd.network = {
      enable = true;
      networks = lib.mapAttrs'
        (
          itf: val: lib.nameValuePair "40-${itf}"
            (if val.address != null then {
              # static configuration
              matchConfig.Name = itf;
              networkConfig = {
                Address = val.address;
                DNSSEC = true;
                DNSOverTLS = false;
                MulticastDNS = true;
                LLMNR = false;
                Domains = "~.";
              };
              linkConfig = {
                Multicast = true;
              };
            } else {
              # DHCP configuration
              matchConfig.Name = itf;
              networkConfig = {
                DHCP = lib.mkForce "ipv4";
                DNSSEC = true;
                DNSOverTLS = false;
                MulticastDNS = true;
                LLMNR = false;
                Domains = "~.";
                LLDP = false;
              };
              linkConfig = {
                Multicast = true;
              };
            })
        )
        config.my.interfaces //
      {
        # USB tethering
        usb = {
          matchConfig.Name = "enp0s*u*";
          networkConfig = {
            DHCP = "yes";
            DNSOverTLS = false;
            LLMNR = false;
            Domains = "~.";
          };
        };
      };
      # config.networking.interfaces;
      wait-online.anyInterface = true;
    };
    services.resolved = {
      enable = true;
      llmnr = "false";
      dnssec = "true";
      fallbackDns = [ "8.8.8.8" "2001:4860:4860::8844" ]; # fbx: fd0f:ee:b0::1
      dnsovertls = "opportunistic";
    };
    networking = {
      nftables.enable = true;
      firewall = {
        enable = true;
        allowPing = true;
        pingLimit = "1/minute burst 5 packets";
        allowedUDPPorts = [ 5353 ]; # mDNS
      };
      hosts = {
        "${inputs.self.lib.network.publicIP}" = [ "bambi" ];
      };
    };
  };
}
