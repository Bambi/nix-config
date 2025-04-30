{ nixosConfs }:
with nixosConfs.bambi.config.systemd.network.networks;
[ bytel.networkConfig lan.networkConfig ]
