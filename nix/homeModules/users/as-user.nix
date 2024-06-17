{ inputs, config, pkgs, ... }:
let
  hostnames = builtins.attrNames inputs.self.nixosConfigurations;
  localHostnames = builtins.map (x: x + ".local") hostnames;
in
{
  imports = [
    ./minimal.nix
    ./tui.nix
    ./tui2.nix
    ../desktop
  ];
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
    };
  };
  home = {
    file.".ssh/id_rsa_as.pub".source = ../../../identities/id_rsa_as.pub;
    file.".ssh/id_rsa_as-cert.pub".source = ../../../identities/id_rsa_as-cert.pub;
    file.".ssh/id_ed25519_as.pub".source = ../../../identities/id_ed25519_as.pub;
    file.".ssh/id_ed25519_as-cert.pub".source = ../../../identities/id_ed25519_as-cert.pub;

    stateVersion = "23.11";
  };
}
