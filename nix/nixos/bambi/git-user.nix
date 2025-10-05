{ pkgs, ... }: {
  # git user to host local depots (git ssh access only)
  users.users.git = {
    isSystemUser = true;
    description = "Git Local Depots";
    home = "/home/git";
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    group = "git";
    openssh = {
      authorizedKeys.keys = [
        "cert-authority ${builtins.readFile ../../../identities/id_ed25519_ca_sk.pub}"
      ];
      authorizedPrincipals = [ "as" "asg" ];
    };
  };
  users.groups.git = { };
}
