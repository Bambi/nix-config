# Module for configuring libvirt with static NixOS networking
# instead of using libvirt managed bridge.

{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.virtualisation.libvirtd.networking;
  v6Enabled = cfg.ipv6.network != null;
  v6PLen = toInt (elemAt (splitString "/" cfg.ipv6.network) 1);
in
{
  options = {
    virtualisation.libvirtd.networking = {
      enable = mkEnableOption "Enable nix-managed networking for libvirt";

      bridgeName = mkOption {
        type = types.str;
        default = "br0";
        description = "Name of the bridged interface for use by libvirt guests";
      };

      externalInterface = mkOption {
        type = types.str;
        example = "venet0";
        description = "Name of the external interface for NAT masquerade";
      };

      ipv6 = {
        network = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "fda7:1646:3af8:af4e::/64";
          description = ''
            IPv6 subnet for guest network. No value means IPv6 networking is not set up.

            NOTE: only tested with private networks w/ Unique Local Addresses + NAT.
          '';
        };

        hostAddress = mkOption {
          type = types.str;
          example = "fda7:1646:3af8:af4e::1";
          description = ''
            Address from the IPv6 subnet assigned to the host side of the bridge.
          '';
        };

        nameServers = mkOption {
          type = types.listOf types.str;
          default = [ "2001:4860:4860::8888" "2001:4860:4860::8844" ]; # google dns
          description = ''
            List of v6 nameservers advertised via SLAAC.
          '';
        };

        forwardPorts = mkOption {
          type = with types; listOf (submodule {
            options = {
              sourcePort = mkOption {
                type = types.int;
                example = 8080;
                description = "Source port of the external interface";
              };

              destination = mkOption {
                type = types.str;
                example = "[fda7:1646:3af8:af4e:5054:ff:fe76:a97c]:80";
                description = "Forward connection to destination [ip]:port";
              };

              proto = mkOption {
                type = types.str;
                default = "tcp";
                example = "udp";
                description = "Protocol of forwarded connection";
              };
            };
          });
          default = [ ];
          example = [{ sourcePort = 8080; destination = "[fda7:1646:3af8:af4e:5054:ff:fe76:a97c]:80"; }];
          description = ''
            List of forwarded ports from the external interface to internal destinations by using DNAT.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.libvirtImages = ''
      mkdir -p /var/lib/libvirt/images
    '';

    networking.nat = {
      enable = true;
      internalInterfaces = [ cfg.bridgeName ];
      inherit (cfg) externalInterface;

    } // optionalAttrs v6Enabled {
      extraCommands = (flip concatMapStrings cfg.ipv6.forwardPorts (f: ''
        ip6tables -w -t nat -I PREROUTING -i ${cfg.externalInterface} -p ${f.proto} --dport ${toString f.sourcePort} -j DNAT --to-destination ${f.destination}
      ''))
      + ''
        ip6tables -w -t nat -I POSTROUTING -o ${cfg.externalInterface} -j MASQUERADE
      '';

      # XXX removing element from forwardPorts won't work, we should use custom chain and flush it instead
      extraStopCommands = (flip concatMapStrings cfg.ipv6.forwardPorts (f: ''
        ip6tables -w -t nat -D PREROUTING -i ${cfg.externalInterface} -p ${f.proto} --dport ${toString f.sourcePort} -j DNAT --to-destination ${f.destination} || true
      ''))
      + ''
        ip6tables -w -t nat -D POSTROUTING -o ${cfg.externalInterface} -j MASQUERADE || true
      '';
    };

    # libvirt uses 192.168.122.0
    systemd.network.networks."15-${cfg.bridgeName}" = {
      matchConfig = {
        Name = cfg.bridgeName;
        Driver = "bridge";
      };
      networkConfig = {
        DHCPServer = true;
        MulticastDNS = true;
        Address = "192.168.122.1/24";
      };
      dhcpServerConfig = {
        UplinkInterface = ":auto";
        BindToInterface = true;
        PoolOffset = 100;
        PoolSize = 100;
        EmitDNS = true;
        Timezone = config.time.timeZone;
        EmitTimezone = true;
      };
    };
    systemd.network.netdevs."15-${cfg.bridgeName}".netdevConfig = {
      Name = cfg.bridgeName;
      Kind = "bridge";
    };

    # Allow DHCP and DNS on bridge interface
    networking.firewall.interfaces = {
      "${cfg.bridgeName}" = {
        allowedUDPPorts = [ 53 67 ];
        allowedTCPPorts = [ 53 67 ];
      };
    };

    boot.kernel.sysctl = mkIf v6Enabled {
      "net.ipv6.conf.all.forwarding" = true;
      "net.ipv6.conf.default.forwarding" = true;
    };

    services.radvd = mkIf v6Enabled {
      enable = true;
      config = ''
        interface ${cfg.bridgeName}
        {
          AdvSendAdvert on;
          AdvManagedFlag off;     # on = also get address from dhcp
          AdvOtherConfigFlag off; # on = get dns from dhcp

          prefix ${cfg.ipv6.network}
          {
            AdvOnLink on;
            AdvAutonomous on;
          };

          route ::/0 {};

          ${optionalString (cfg.ipv6.nameServers != []) ''
            RDNSS ${builtins.concatStringsSep " " cfg.ipv6.nameServers} {};
          ''}
        };
      '';
    };

    # NixOS guests obtain address, routes, and DNS from router advertisements.
    # So there's no need to run DHCP if you're OK with SLAAC addresses.
    /*
      services.dhcpd6 = mkIf v6Enabled {
      enable = true;
      interfaces = [ cfg.bridgeName ];
      extraConfig = ''
        ${optionalString (cfg.ipv6.nameServers != []) ''
          option dhcp6.name-servers ${builtins.concatStringsSep ", " cfg.ipv6.nameServers};
        ''}

        ${optionalString cfg.infiniteLeaseTime  ''
        default-lease-time -1;
        max-lease-time -1;
        ''}
        subnet6 ${cfg.ipv6.network} {
        }
      '';
      };
    */
  };
}

