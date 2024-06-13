{ inputs, ... }: {
  nodes = {
    popeye = {
      hostname = "popeye.local";
      profiles.system = {
        sshUser = "as";
        user = "root";
        autoRollback = false;
        magicRollback = false;
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.popeye;
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
