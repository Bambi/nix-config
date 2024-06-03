{ inputs, pkgs, config, ... }:
let
  hostnames = builtins.attrNames inputs.self.nixosConfigurations;
  localHostnames = builtins.map (x: x + ".local") hostnames;
in
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      myhosts = {
        host = builtins.concatStringsSep " " localHostnames;
        identityFile = "~/.ssh/id_ed25519_as";
        forwardAgent = true;
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
      github = {
        host = "github github.com";
        forwardAgent = true;
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519_as";
      };
      cubie = {
        identityFile = [ "~/.ssh/id_ed25519_as" "~/.ssh/id_rsa_as" ];
      };
    };
  };
  services.ssh-agent.enable = true;
  home.packages = [
    pkgs.assh
  ];
}
