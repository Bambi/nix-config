{ inputs, config, ... }:
let
  hostnames = builtins.attrNames inputs.self.nixosConfigurations;
  localHostnames = map (x: x + ".local") hostnames;
in
{
  imports = [
    inputs.self.homeModules.minimal
  ];
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      myhosts = {
        host = (builtins.concatStringsSep " " localHostnames) + " *.as.dedyn.io *.mesh";
        identityFile = "~/.ssh/${config.my.sshIdFile}";
        forwardAgent = true;
        # extraOptions = {
        #   AddKeysToAgent = "yes";
        # };
      };
      github = {
        host = "github github.com";
        forwardAgent = true;
        hostname = "github.com";
        identityFile = "~/.ssh/${config.my.sshIdFile}";
      };
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
    settings = {
      myhosts = {
        AddKeysToAgent = "yes";
      };
    };
  };
  home = {
    file = {
      ".ssh/id_rsa_as.pub".source = ../../../identities/id_rsa_as.pub;
      ".ssh/id_rsa_as-cert.pub".source = ../../../identities/id_rsa_as-cert.pub;
      ".ssh/id_ed25519_as.pub".source = ../../../identities/id_ed25519_as.pub;
      ".ssh/id_ed25519_as-cert.pub".source = ../../../identities/id_ed25519_as-cert.pub;
    };
  };
}
