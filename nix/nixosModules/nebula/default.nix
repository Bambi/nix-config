{ config, ... }: {
  # node key stored through sops
  sops.secrets.nebula_key = {
    sopsFile = ../../nixos/${config.networking.hostName}/secrets.yaml;
    owner = "nebula-mesh";
    mode = "0440";
  };
  services.nebula.networks.mesh = {
    enable = true;
    isLighthouse = false;
    cert = ../../nixos/${config.networking.hostName}/nebula.crt;
    key = config.sops.secrets.nebula_key.path;
    ca = ./ca.crt;
    lighthouses = [ "192.168.100.1" ];
    staticHostMap = {
      "192.168.100.1" = [ "82.64.181.55:4242" ];
    };
    firewall = {
      inbound = [{
        host = "any";
        proto = "any";
        port = "any";
      }];
      outbound = [{
        host = "any";
        proto = "any";
        port = "any";
      }];
    };
  };
  # TODO: making nebula dns working with systemd/networkd/resolved seems complicated...
  # in the mean time use the hosts file
  networking.extraHosts = ''
    192.168.100.1 lighthouse.mesh
    192.168.100.3 bambi.mesh
    192.168.100.5 babar.mesh
  '';
  # systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
  # systemd.network = {
  #   networks."60-nebula" = {
  #     matchConfig.Name = "nebula.mesh";
  #     networkConfig = {
  #       DHCP = "no";
  #       LinkLocalAddressing = "ipv4";
  #       IPv6SendRA = "no";
  #       LLMNR = false;
  #       MulticastDNS = false;
  #       DNSSEC = false;
  #       DNSOverTLS = false;
  #       Domains = "mesh";
  #       DNS = [ "192.168.100.1" ];
  #     };
  #   };
  # };
}
