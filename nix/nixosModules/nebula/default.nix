{ config, lib, inputs, ... }: {
  options.my.nebula = with inputs.self.lib; {
    enable = mkBoolOpt false "Enable Nebula Overlay.";
    isLighthouse = mkBoolOpt false "Is the node a lighthouse.";
    nodeIP = mkOpt lib.types.str "" "Node Nebula IP. Only for the lighthouse. Must match the certificate IP.";
  };

  config =
    let
      nebulaHosts = lib.filterAttrs (n: v: (builtins.hasAttr "nebula" v.config.my)) inputs.self.nixosConfigurations;
      lighthouseHosts = lib.filterAttrs (n: v: (v.config.my.nebula.isLighthouse)) nebulaHosts;
      lighthouseIPs = lib.mapAttrsToList (n: v: "${v.config.my.nebula.nodeIP}") lighthouseHosts;
    in
    lib.mkIf config.my.nebula.enable {
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
        inherit (config.my.nebula) isLighthouse;
        enable = true;
        cert = ../../nixos/${config.networking.hostName}/nebula.crt;
        key = config.sops.secrets.nebula_key.path;
        ca = ./ca.crt;
        lighthouses = lib.mkIf (!config.my.nebula.isLighthouse) lighthouseIPs;
        staticHostMap = lib.mkIf (!config.my.nebula.isLighthouse)
          (builtins.listToAttrs (lib.lists.forEach lighthouseIPs (v: { name = "${v}"; value = [ "82.64.181.55:4242" ]; })));
        # "192.168.100.1" = [ "82.64.181.55:4242" ];
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
        settings = {
          lighthouse =
            if config.my.nebula.isLighthouse then {
              serve_dns = true;
              dns = {
                # take only one lighthouse !?
                host = "${lib.lists.last lighthouseIPs}";
                # using 53 for the DNS would require to set the net capability for the
                # nebula executable as it runs with a normal user (nebula-mesh)
                port = 5354;
              };
            } else {
              interval = 60;
            };
          sshd = {
            enabled = true;
            listen = "127.0.0.1:2222";
            host_key = config.sops.secrets.nebula_ssh_host_key.path;
            trusted_cas = [ "${builtins.readFile ../../../identities/id_ed25519_ca_sk.pub}" ];
            authorized_users = [{
              user = "as";
              keys = [ "${builtins.readFile ../../../identities/id_ed25519_as.pub}" ];
            }];
          };
        };
      };
      networking.firewall.allowedUDPPorts = [ 5354 ];
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
            DNS = builtins.map (x: x + ":5354") lighthouseIPs;
            DNSDefaultRoute = false;
          };
        };
      };
    };
}
