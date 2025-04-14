{ config, lib, inputs, ... }: {
  options.my.syncthing = {
    id = inputs.self.lib.mkOpt lib.types.str null "Syncthing device id.";
    backup = inputs.self.lib.mkBoolOpt false "Is the device used as a backup server.";
  };

  config = {
    sops.secrets.syncthing_key = {
      sopsFile = ../nixos/${config.networking.hostName}/secrets.yaml;
      owner = "${config.my.user}";
      mode = "0440";
    };
    services.syncthing =
      let
        # all devices with a syncthingId
        syncHosts = lib.filterAttrs (_: v: (builtins.hasAttr "syncthing" v.config.my)) inputs.self.nixosConfigurations;
        backupHosts = lib.filterAttrs (_: v: v.config.my.syncthing.backup) syncHosts;
        # non backup syncthing servers
        userHosts = lib.filterAttrs (_: v: !v.config.my.syncthing.backup) syncHosts;
        backupHostsList = lib.mapAttrsToList (n: _: "${n}") backupHosts;
        folder = name: devices: {
          path = "~/Sync/${name}";
          id = "${name}";
          inherit devices;
          ignorePerms = true;
        };
        # folders configured on the backup server
        backupConf = lib.mapAttrs (n: _: folder n [ "${n}" ]) userHosts;
        # folder configured on each non backup servers
        localConf = lib.mapAttrs (_: _: folder config.networking.hostName backupHostsList) backupHosts;
      in
      {
        enable = true;
        openDefaultPorts = true;
        # do not put configDir in ~/.config: as this is a NixOS service
        # ~/.config will be created as root and home-manager will fail
        # to start because of wrong permissions on ~/.config.
        configDir = "/home/${config.my.user}/.syncthing";
        user = "${config.my.user}";
        group = "users";
        key = "${config.sops.secrets.syncthing_key.path}";
        cert = "/etc/syncthing/cert.pem";
        guiAddress = "0.0.0.0:8384";
        overrideFolders = true;
        overrideDevices = true;
        settings = {
          devices = lib.mapAttrs (_: v: { inherit (v.config.my.syncthing) id; }) syncHosts;
          folders = lib.mkMerge
            [
              # common folder shared by all devices
              { common = folder "common" (lib.mapAttrsToList (n: _: "${n}") syncHosts); }
              (if config.my.syncthing.backup then backupConf else localConf)
            ];
        };
      };
    # networking.firewall.allowedTCPPorts = [ 8384 ]; # GUI
    environment.etc."syncthing/cert.pem".source = ../nixos/${config.networking.hostName}/syncthing_cert.pem;
  };
}
