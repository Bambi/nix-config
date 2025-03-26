{ pkgs, lib, config, inputs, lanItf, wanItf, boxMacAddr, ... }: {
  systemd.network = {
    # bbox data is accessible on vlan 100 / IPv6 only
    netdevs.bytel = {
      netdevConfig = {
        Description = "Btel Data VLAN";
        Name = "byteldata";
        Kind = "vlan";
        MACAddress = boxMacAddr;
      };
      vlanConfig.Id = 100;
    };
    # wan physical interface
    networks.bytel = {
      matchConfig = {
        Name = wanItf;
        Type = "ether";
      };
      networkConfig = {
        Description = "Bytel Data Network";
        VLAN = "byteldata";
        # No autoconf of the physical ethernet interface (trunk)
        LinkLocalAddressing = false;
        LLDP = false;
        EmitLLDP = false;
        IPv6AcceptRA = false;
        IPv6SendRA = false;
      };
    };
    # internet pseudo interface based on bytel vlan
    networks.internet = {
      matchConfig = {
        Name = "byteldata";
        Type = "vlan";
      };
      networkConfig = {
        Description = "Internet Access";
        DHCP = true;
        IPv6AcceptRA = true;
        IPv4Forwarding = true;
        IPv6Forwarding = true;
        # LinkLocalAddressing = "ipv6";
        # Address = "82.64.181.55/24"; # bambi.hd.free.fr
        # Gateway = "";
      };
      dhcpV4Config = {
        VendorClassIdentifier = "BYGTELIAD";
        UseHostname = false;
        # SendHostName = false;
      };
      dhcpV6Config = {
        UseAddress = false;
        WithoutRA = "solicit";
        DUIDType = "link-layer";
        PrefixDelegationHint = "::/64";
        IAID = 1;
        # SendHostname = false;
        UseHostname = false;
        UseDNS = false;
      };
    };
    # LAN Interface
    networks.lan = {
      matchConfig = {
        Name = lanItf;
        Type = "ether";
      };
      networkConfig = {
        Description = "LAN interface";
        Address = "192.168.0.254/24";
        DHCPServer = true;
        IPMasquerade = "ipv4";
        IPv6Forwarding = true;
        IPv6AcceptRA = false;
        IPv6SendRA = true;
        LLDP = false;
        EmitLLDP = false;
      };
      dhcpServerConfig = {
        PoolOffset = 10;
        PoolSize = 50;
        EmitDNS = true;
        DNS = "192.168.0.254";
      };
      dhcpServerStaticLeases = [
        {
          Address = "192.168.0.50";
          MACAddress = "84:7b:eb:1e:eb:d8";
        }
      ];
    };
    # Forwarding
    config.networkConfig = {
      IPv4Forwarding = true;
      IPv6Forwarding = true;
    };
  };
  # Firewalling
  networking = {
    nftables.enable = true;
    firewall = {
      filterForward = true;
      trustedInterfaces = [ "${lanItf}" ];
    };
  };
}
