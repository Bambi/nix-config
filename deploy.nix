{ inputs, ... }:
let
  mkDeploy = hostname: confname: userConf: {
    inherit hostname;
    sshUser = "as";
    profilesOrder = [ "system" ];
    profiles.system = {
      user = "root";
      autoRollback = true;
      magicRollback = true;
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.${confname};
    };
    profiles.as = {
      path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager inputs.self.homeConfigurations.${userConf};
    };
  };
in
{
  nodes = {
    popeye = mkDeploy "paea.duckdns.org" "popeye" "as-minimal";
    babar = mkDeploy "babar.local" "babar" "as-gui";
    bianca = mkDeploy "bianca.local" "bianca" "as-gui";
  };
}
