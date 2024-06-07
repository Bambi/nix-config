{ lib, config, inputs, ... }:
let
  inherit (config.networking) hostName;
  pubKey = host: ../../nixos/${host}/ssh_host_ed25519.pub;
in
{
  services.openssh = {
    enable = true;
    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };

    # the host key (ed25519) should be created during the host installation
    # along with its certificate with nixos-anywhere.
    hostKeys = [{
      path = "/etc/ssh/ssh_host_ed25519";
      type = "ed25519";
    }];

    extraConfig = ''
      TrustedUserCAKeys /etc/ssh/trusted_user_ca
      HostCertificate /etc/ssh/ssh_host_rsa-cert.pub
      HostCertificate /etc/ssh/ssh_host_ed25519-cert.pub
    '';
  };

  environment.etc."ssh/trusted_user_ca".source = ../../../identities/id_ed25519_ca_sk.pub;

  programs.ssh = {
    startAgent = true;
    # Each hosts public key
    knownHosts = builtins.mapAttrs
      (name: _: {
        publicKeyFile = pubKey name;
        extraHostNames =
          (lib.optional (name == hostName) "localhost"); # Alias for localhost if it's the same host
      })
      inputs.self.nixosConfigurations // {
      "*" = {
        publicKeyFile = ../../../identities/id_ed25519_ca_sk.pub;
        certAuthority = true;
      };
    };
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;
}
