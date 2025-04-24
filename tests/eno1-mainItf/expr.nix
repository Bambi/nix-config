{ nixosConfs, ... }:
let
  hosts = [ "bianca" "babar" "musclor" ];
in
  builtins.map (x: { ${x} = nixosConfs.${x}.config.systemd.network.networks."40-eno1".networkConfig; }) hosts
