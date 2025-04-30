{ pkgs, ... }: {
  programs = {
    git = {
      enable = true;
      userName = "Antoine Sgambato";
      userEmail = "176003+Bambi@users.noreply.github.com";
      delta.enable = true;
      extraConfig = {
        core = {
          editor = "hx";
        };
        color = {
          diff = "auto";
          status = "auto";
          branch = "auto";
          ui = true;
        };
        pager = {
          diff = "delta";
          log = "delta";
          reflog = "delta";
          show = "delta";
        };
        user.signingkey = "~/.ssh/id_ed25519_as";
        commit.gpgSign = true;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
      includes = [
        { path = ./git-delta.conf; }
      ];
    };
    gh = {
      enable = true;
      extensions = with pkgs; [ gh-markdown-preview ];
      settings = {
        version = "1";
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
    jujutsu = {
      enable = false;
      settings = {
        user = {
          name = "Antoine Sgambato";
          email = "176003+Bambi@users.noreply.github.com";
        };
        signing = {
          sign-all = true;
          backend = "ssh";
          key = "/home/as/.ssh/id_ed25519_as";
        };
      };
    };
  };
  home = {
    file.".ssh/allowed_signers".text =
      "* ${builtins.readFile ../../../../identities/id_ed25519_as.pub}";
    packages = [ pkgs.tig pkgs.git-subrepo ];
  };
}
