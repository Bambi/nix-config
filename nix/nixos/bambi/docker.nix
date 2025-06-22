_: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    logDriver = "json-file";
    daemon.settings = {
      fixed-cidr-v6 = "fd00::/80";
      ipv6 = true;
    };
  };
  # Allow forwarding to all Docker networks (https://dzx.fr/blog/nftables-docker-drop-policy/)
  networking.firewall.extraForwardRules = ''
    ip saddr 172.17.0.0/12 accept
    ip daddr 172.17.0.0/12 accept
  '';
}
