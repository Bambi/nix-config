{ config, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      clang-tools
      universal-ctags
      passh
      pet
    ];
    file.".ssh/id_rsa_ipanema.pub".source = ../../../identities/id_rsa_ipanema.pub;
    file.".ssh/id_ed25519_as.pub".source = ../../../identities/id_ed25519_as.pub;
    file.".ssh/id_rsa_as.pub".source = ../../../identities/id_rsa_as.pub;
    activation.setupEtc = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      /usr/bin/systemctl start --user sops-nix
    '';
  };
  xdg.configFile."pet/config.toml".source = ./pet/config.toml;
  sops = {
    secrets = {
      pet_snippet.path = "${config.home.homeDirectory}/.config/pet/snippet.toml";
      id_rsa_ipanema.path = "${config.home.homeDirectory}/.ssh/id_rsa_ipanema";
    };
  };
  programs = {
    git.package = pkgs.gitSVN;
    ssh = {
      matchBlocks = {
        extremenetworks = {
          host = "*.extremenetworks.com";
          user = "asgambato";
          identityFile = "~/.ssh/id_rsa_ipanema";
        };
        frfonagn01 = {
          hostname = "frfonagn01.extremenetwork.com";
        };
        frfonagn02 = {
          hostname = "frfonagn02.extremenetwork.com";
        };
        local = {
          host = "*.local";
          identityFile = "~/.ssh/id_rsa_ipanema";
        };
      };
    };
  };
}
