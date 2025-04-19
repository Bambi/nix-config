{ config, ... }: {
  sops = {
    secrets.taskwarrior_sync = { };
    age = {
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      generateKey = false;
    };
    defaultSopsFile = ./secrets.yaml;
  };
}
