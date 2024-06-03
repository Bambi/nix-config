{ config, pkgs, ... }:
{
  programs.git.package = pkgs.git;
  home = {
    file.".ssh/id_rsa_as.pub".source = ../../../identities/id_rsa_as.pub;
    file.".ssh/id_rsa_as-cert.pub".source = ../../../identities/id_rsa_as-cert.pub;
    file.".ssh/id_ed25519_as.pub".source = ../../../identities/id_ed25519_as.pub;
    file.".ssh/id_ed25519_as-cert.pub".source = ../../../identities/id_ed25519_as-cert.pub;
  };
  sops = {
    secrets = { };
  };
}
