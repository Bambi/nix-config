{ pkgs, lib, config, inputs, ... }:
let
  interfaceOpts = {
    options = {
      address = inputs.self.lib.mkOpt (lib.types.nullOr lib.types.str) null "Set interface IP address (DHCP otherwise)";
      networkAccess = inputs.self.lib.mkBoolOpt false "Is this interface used for Internet access?";
      trusted = inputs.self.lib.mkBoolOpt false "Untrusted interfaces will be firewalled.";
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
          itf: val: lib.nameValuePair "10-${itf}"
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
      firewall.allowedUDPPorts = [ 5353 ]; # mDNS
      hosts = {
        "${inputs.self.lib.network.publicIP}" = [ "popeye" ];
      };
    };
  };
}
