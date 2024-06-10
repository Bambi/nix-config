{ pkgs, config, lib, inputs, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  options.my.user = inputs.self.lib.mkOpt lib.types.str null "Main user name.";

  config = lib.mkIf (config.my.user != null) {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.as = {
      hashedPassword = "$y$j9T$5z.blnJWISrsCPyU6Li5.0$OyJ01uHXr.piHLHBesWg/LLPufFTLoS5jVYLGVqLNL3";
      isNormalUser = true;
      description = "antoine";
      extraGroups = [ "input" "wheel" "video" "audio" ]
        ++ ifTheyExist [ "networkmanager" "tss" "podman" "docker" "libvirtd" "adbusers" "dialout" ];
      shell = pkgs.fish;
      packages = with pkgs; [
        tree
      ];
      openssh = {
        authorizedKeys.keys = [
          (builtins.readFile ../../../identities/id_rsa_as.pub)
          (builtins.readFile ../../../identities/id_ed25519_as.pub)
          "cert-authority ${builtins.readFile ../../../identities/id_ed25519_ca_sk.pub}"
        ];
        authorizedPrincipals = [ "as" ];
      };
    };
    programs.fish.enable = true;
    # users with additional rights for the Nix daemon
    nix.settings.trusted-users = [ "root" "as" ];

    # Change runtime directory size
    # services.logind.extraConfig = "RuntimeDirectorySize=8G";
  };
}
