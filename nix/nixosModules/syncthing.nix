{ pkgs, config, lib, inputs, ... }: {
  options.my.syncthingId = inputs.self.lib.mkOpt lib.types.str null "Syncthing device id.";

  config = {
    sops.secrets.syncthing_key = {
      sopsFile = ../nixos/${config.networking.hostName}/secrets.yaml;
      owner = "${config.my.user}";
      mode = "0440";
    };
    services.syncthing =
      let
        # all devices with a syncthingId
        syncHosts = lib.filterAttrs (n: v: (builtins.hasAttr "syncthingId" v.config.my)) inputs.self.nixosConfigurations;
      in
      {
        enable = true;
        openDefaultPorts = true;
        # dataDir = "/home/${user}/.local/share/syncthing";
        configDir = "/home/${config.my.user}/.config/syncthing";
        user = "${config.my.user}";
        group = "users";
        key = "${config.sops.secrets.syncthing_key.path}";
        cert = "/etc/syncthing/cert.pem";
        guiAddress = "0.0.0.0:8384";
        overrideFolders = true;
        overrideDevices = true;
        settings = {
          devices = lib.mapAttrs (n: v: { id = v.config.my.syncthingId; }) syncHosts;
          folders = {
            sync = {
              path = "~/.local/share/sync";
              devices = lib.mapAttrsToList (n: v: "${n}") syncHosts;
              ignorePerms = true;
            };
          };
        };
      };
    # networking.firewall.allowedTCPPorts = [ 8384 ]; # GUI
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
    environment.etc."syncthing/cert.pem".source = ../nixos/${config.networking.hostName}/syncthing_cert.pem;
  };
}
