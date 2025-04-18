{ config, pkgs, lib, ... }: {
  home = {
    packages = with pkgs; [
      clang-tools
      universal-ctags
      passh
      pet
    ];
    file = {
      ".ssh/id_rsa_ipanema.pub".source = ../../../identities/id_rsa_ipanema.pub;
      ".ssh/id_ed25519_as.pub".source = ../../../identities/id_ed25519_as.pub;
      ".ssh/id_rsa_as.pub".source = ../../../identities/id_rsa_as.pub;
    };
    activation.setupEtc = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      /usr/bin/systemctl start --user sops-nix
    '';
    stateVersion = "23.11";
  };
  xdg.configFile."pet/config.toml".source = ./pet/config.toml;
  sops = {
    secrets = {
      pet_snippet.path = "${config.home.homeDirectory}/.config/pet/snippet.toml";
      id_rsa_ipanema.path = "${config.home.homeDirectory}/.ssh/id_rsa_ipanema";
    };
    age = {
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      generateKey = false;
    };
    defaultSopsFile = ./secrets.yaml;
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
  services.ssh-agent.enable = true;
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
    };
  };
}
