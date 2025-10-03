{ config, ... }: {
  sops = {
    secrets = {
      taskwarrior_sync = { };
      weather_key = { };
    };
    age = {
      sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519_as" ];
      generateKey = false;
    };
    defaultSopsFile = ./secrets.yaml;
  };
}
