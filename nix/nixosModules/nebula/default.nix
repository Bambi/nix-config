{ config, lib, bindIps, LHMeshIP, isLH, ... }: {
  # node key stored through sops
  sops.secrets =
    let
      sopsSecrets = {
        sopsFile = ../../nixos/${config.networking.hostName}/secrets.yaml;
        owner = "nebula-mesh";
        mode = "0400";
      };
    in
    {
      nebula_key = sopsSecrets;
      nebula_ssh_host_key = sopsSecrets;
    };
  services.nebula.networks.mesh = {
    isLighthouse = isLH;
    enable = true;
    cert = ../../nixos/${config.networking.hostName}/nebula.crt;
    key = config.sops.secrets.nebula_key.path;
    ca = ./ca.crt;
    lighthouses = lib.mkIf (!isLH) [ LHMeshIP ];
    staticHostMap = lib.mkIf (!isLH) {
      "${LHMeshIP}" = bindIps;
    };
    # (builtins.listToAttrs (lib.lists.forEach lighthouseIPs (v: { name = "${v}"; value = [ "${config.my.nebula.publicIp}:4242" ]; })));
    # "192.168.100.1" = [ "176.177.24.32:4242" ];
    listen.host = "[::]";
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
    settings =
    let
      sshd = lib.optionalAttrs (config.sops.secrets ? nebula_ssh_host_key) {
        enabled = true;
        listen = "127.0.0.1:2222";
        host_key = config.sops.secrets.nebula_ssh_host_key.path;
        trusted_cas = [ "${builtins.readFile ../../../identities/id_ed25519_ca_sk.pub}" ];
        authorized_users = [{
          user = "as";
          keys = [ "${builtins.readFile ../../../identities/id_ed25519_as.pub}" ];
        }];
      };
    in
    if isLH then {
      lighthouse = {
        serve_dns = true;
        dns = {
          # take only one lighthouse !?
          host = LHMeshIP;
          # using 53 for the DNS would require to set the net capability for the
          # nebula executable as it runs with a normal user (nebula-mesh)
          port = 5354;
        };
      };
      inherit sshd;
    } else {
      lighthouse = {
        interval = 55;
      };
      punchy = {
        punch = true;
        respond = true;
      };
      inherit sshd;
    };
  };
  networking.firewall = {
    allowedUDPPorts = [ 5354 ];
    trustedInterfaces = [ "nebula.mesh" ];
  };
  # systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
  systemd.network = {
    networks."60-nebula" = {
      matchConfig.Name = "nebula.mesh";
      networkConfig = {
        # KeepMaster = true;
        KeepConfiguration = true;
        DHCP = false;
        IPv6SendRA = false;
        IPv6AcceptRA = false;
        LLMNR = false;
        MulticastDNS = false;
        DNSSEC = false;
        DNSOverTLS = false;
        Domains = "~mesh";
        DNS = "192.168.100.1:5354";
        DNSDefaultRoute = false;
      };
    };
  };
}
