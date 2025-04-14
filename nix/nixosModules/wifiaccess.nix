{ config, ... }: {
  sops.secrets.bambi_psk = {
    sopsFile = ../nixos/${config.networking.hostName}/secrets.yaml;
    owner = "root";
    group = "root";
    mode = "400";
  };
  # wireless access point
  services.hostapd = {
    enable = true;
    radios = {
      # 802.11n
      wlan = {
        band = "2g";
        countryCode = "FR";
        channel = 3; # 0: Enable automatic channel selection (ACS).
        wifi4.enable = true;
        networks.wlan = {
          ssid = "bambi";
          authentication = {
            wpaPasswordFile = config.sops.secrets.bambi_psk.path;
            mode = "wpa2-sha1";
          };
          apIsolate = true;
        };
        settings = {
          ieee80211d = true;
        };
      };
    };
  };
  systemd.network = {
    networks.wlan = {
      matchConfig = {
        Name = "wlan";
      };
      networkConfig = {
        Description = "Wifi interface";
        Address = "192.168.1.254/24";
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
        DNS = "192.168.1.254";
      };
      dhcpPrefixDelegationConfig = {
        SubnetId = "0xe";
      };
    };
  };
  # Firewalling
  networking = {
    nftables.enable = true;
    firewall = {
      filterForward = true;
      extraForwardRules = "iifname wlan oifname byteldata accept";
      interfaces.wlan = {
        allowedUDPPorts = [ 53 67 ];
        allowedTCPPorts = [ 53 ];
      };
    };
  };
}
