{ pkgs, lib, config, inputs, lanItf, wanItf, fbMacAddr, ... }: {
  systemd.network = {
    # Free data is accessible on vlan 836 / IPv6 only
    netdevs.free = {
      netdevConfig = {
        Description = "Btel Data VLAN";
        Name = "bteldata";
        Kind = "vlan";
        MACAddress = fbMacAddr;
      };
      vlanConfig.Id = 100;
    };
    networks.free = {
      matchConfig = {
        Name = wanItf;
        Type = "ether";
      };
      networkConfig = {
        Description = "Btel Data Network";
        VLAN = "bteldata";
        # No autoconf of the physical ethernet interface (trunk)
        LinkLocalAddressing = false;
        LLDP = false;
        EmitLLDP = false;
        IPv6AcceptRA = false;
        IPv6SendRA = false;
      };
    };
    networks.internet = {
      matchConfig = {
        Name = "bteldata";
        Type = "vlan";
      };
      networkConfig = {
        Description = "Internet Access";
        DHCP = "ipv4";
        IPv6AcceptRA = true;
        LinkLocalAddressing = "ipv6";
        # Address = "82.64.181.55/24"; # bambi.hd.free.fr
        # IPMasquerade = "ipv4";
        # Gateway = "";
      };
      dhcpV4Config = {
        VendorClassIdentifier = "BYGTELIAD";
        UseHostname = false;
        # SendHostName = false;
      };
      dhcpV6Config = {
        # SendHostname = false;
        UseHostname = false;
        UseDNS = false;
      };
    };
    # LAN Interface
    # networks.lan = {
    #   matchConfig = {
    #     Name = lanItf;
    #     Type = "ether";
    #   };
    #   networkConfig = {
    #     Description = "LAN interface";
    #     Address = "192.168.0.253/24";
    #     DHCPServer = true;
    #   };
    #   dhcpServerConfig = {
    #     PoolOffset = 10;
    #     PoolSize = 50;
    #     EmitDNS = true;
    #     DNS = "192.168.0.253";
    #   };
    # };
  };
  # Forwarding
  # boot.kernel.sysctl = {
  #   "net.ipv4.ip_forward" = true;
  #   "net.ipv6.conf.all.forwarding" = true;
  # };
}
