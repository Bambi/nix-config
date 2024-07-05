{ inputs, ... }:
let
  mkDeploy = host: userConf: {
    hostname = host + ".local";
    sshUser = "as";
    profilesOrder = [ "system" ];
    profiles.system = {
      user = "root";
      autoRollback = false;
      magicRollback = false;
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.${host};
    };
    profiles.as = {
      path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager inputs.self.homeConfigurations.${userConf};
    };
  };
in
{
  nodes = {
    popeye = mkDeploy "popeye" "as-minimal";
    babar = mkDeploy "babar" "as-gui";
  };
}
