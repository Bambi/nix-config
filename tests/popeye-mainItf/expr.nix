{ nixosConfs }:
with nixosConfs.popeye.config.systemd.network.networks;
[ bytel.networkConfig lan.networkConfig ]
