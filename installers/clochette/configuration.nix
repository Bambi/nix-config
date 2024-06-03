{ inputs, lib, pkgs, config, ... }: {

  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    inputs.disko.nixosModules.disko
  ];

  environment.systemPackages = with pkgs; [
    curl
    rsync
    diskrsync
    helix
    partclone
    bat
    inputs'.disko.packages.disko
  ];

  # The default compression-level is (6) and takes too long on some machines (>30m). 3 takes <2m
  isoImage.squashfsCompression = "zstd -Xcompression-level 22";

  # we don't want to generate filesystem entries on this image
  disko.enableConfig = lib.mkDefault false;

  # Use helix as the default editor
  environment.variables.EDITOR = "hx";
  environment.etc = {
    "ssh/authorized_principals".text = ''
      cert-authority,principals=as ${builtins.readFile ../../identities/id_ed25519_ca_sk.pub}
    '';
    "ssh/ca.pub".source = ../../identities/id_ed25519_ca_sk.pub;
  };

  networking = {
    hostName = "clochette";
    firewall.enable = false;
  };

  services = {
    resolved.enable = false;
    qemuGuest.enable = true;
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        AuthorizedPrincipalsFile = "/etc/ssh/authorized_principals";
      };
      extraConfig = ''
        TrustedUserCAKeys /etc/ssh/ca.pub
      '';
    };
    # useful for 'ssh root@clochette.local'
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        workstation = true;
        addresses = true;
      };
    };
  };

  systemd = {
    # network.enable = true;
    services.update-prefetch.enable = false;
    services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  documentation = {
    enable = false;
    nixos.options.warningsAreErrors = false;
    info.enable = false;
  };

  nix = {
    gc.automatic = true;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };

    nixPath = [
      "nixpkgs=${pkgs.path}"
    ];
  };

  users.users.root.openssh.authorizedKeys.keyFiles =
    [ ../../identities/id_ed25519_as.pub ];
  environment.etc."ssh/trusted_user_ca".source = ../../identities/id_ed25519_ca_sk.pub;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "24.05";
}
