{ config, ... }: {
  my = {
    bash = false;
    sshIdFile = "id_ed25519";
  };
  sops = {
    secrets = {
      taskwarrior_sync = { };
      weather_key = { };
    };
    age = {
      sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/${config.sshIdFile}" ];
      generateKey = false;
    };
    defaultSopsFile = ./secrets.yaml;
  };
  home = {
    username = "asg";
    homeDirectory = "/var/home/asg";
  };
}
