{ config, ... }: {
  sops = {
    secrets = {
      taskwarrior_sync = { };
      weather_key = { };
    };
    age = {
      sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/${config.my.sshIdFile}" ];
      generateKey = false;
    };
    defaultSopsFile = ./secrets.yaml;
  };
}
