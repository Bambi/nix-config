{ inputs, ... }: {
  nodes = {
    popeye = {
      hostname = "popeye.local";
      sshUser = "as";
      profilesOrder = [ "system" ];
      profiles.system = {
        user = "root";
        autoRollback = false;
        magicRollback = false;
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.popeye;
      };
      profiles.as = {
        path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager inputs.self.homeConfigurations.as-minimal;
      };
    };
    babar = {
      hostname = "babar.local";
      profiles.system = {
        sshUser = "as";
        user = "root";
        autoRollback = false;
        magicRollback = false;
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.babar;
      };
    };
  };
}
