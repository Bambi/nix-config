{ pkgs, lib, config, inputs, lanItf, wanItf, boxMacAddr, hostList, ... }:
let
  faiItf = "byteldata"; # FAI interface name
in
{
  systemd.network = {
    # wan physical interface
    networks.bytel = {
      matchConfig = {
        Name = wanItf;
        Type = "ether";
      };
      networkConfig = {
        Description = "Bytel Data Network";
        VLAN = faiItf;
        # No autoconf of the physical ethernet interface (trunk)
        LinkLocalAddressing = false;
        LLDP = false;
        EmitLLDP = false;
        IPv6AcceptRA = false;
        IPv6SendRA = false;
      };
    };
    # bbox data is accessible on vlan 100 / IPv6 only
    netdevs.bytel = {
      netdevConfig = {
        Description = "Btel Data VLAN";
        Name = faiItf;
        Kind = "vlan";
        MACAddress = boxMacAddr;
      };
      vlanConfig.Id = 100;
    };
    # internet pseudo interface based on bytel vlan
    networks.internet = {
      matchConfig = {
        Name = faiItf;
        Type = "vlan";
      };
      networkConfig = {
        Description = "Internet Access";
        DHCP = true;
        IPv6AcceptRA = true;
        IPv4Forwarding = true;
        IPv6Forwarding = true;
        LinkLocalAddressing = "ipv6";
        DHCPPrefixDelegation = true;
      };
      dhcpV4Config = {
        VendorClassIdentifier = "BYGTELIAD";
        UseHostname = false;
        # SendHostName = false;
      };
      dhcpV6Config = {
        UseDelegatedPrefix = true;
        UseAddress = false;
        WithoutRA = "solicit";
        DUIDType = "link-layer";
        PrefixDelegationHint = "::/60";
        IAID = 1;
        UseHostname = false;
        UseDNS = false;
        # UseMTU = true;
      };
      dhcpPrefixDelegationConfig = {
        UplinkInterface = ":self";
        SubnetId = 1;
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
        MulticastDNS = true;
        DHCPPrefixDelegation = true;
      };
      dhcpServerConfig = {
        PoolOffset = 10;
        PoolSize = 50;
        EmitDNS = true;
        DNS = "192.168.0.254";
      };
      dhcpServerStaticLeases =
        map (host: { inherit (host) Address; inherit (host) MACAddress; })
          hostList.hosts;
      dhcpPrefixDelegationConfig = {
        UplinkInterface = faiItf;
        SubnetId = "0xf";
      };
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
      extraForwardRules = "iifname ${lanItf} accept";
    };
  };
}
