{ pkgs, config, ... }: {
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
        user.signingkey = "~/.ssh/${config.my.sshIdFile}";
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
      enable = true;
      settings = {
        user = {
          name = "Antoine Sgambato";
          email = "176003+Bambi@users.noreply.github.com";
        };
        signing = {
          behavior = "own";
          backend = "ssh";
          key = "/home/as/.ssh/${config.my.sshIdFile}";
        };
        ui.default-command = "log";
        aliases = {
          tug = [ "bookmark" "move" "--from" "closest_bookmark(@)" "--to" "closest_nonempty(@)" ];
          difft = [ "diff" "--tool" "${pkgs.difftastic}/bin/difft" ];
        };
        revset-aliases = {
          "closest_bookmark(to)" = "heads(::to & bookmarks())";
          "closest_nonempty(to)" = "heads(::to ~ empty())";
        };
        colors = {
          "diff removed token" = { bg = "#3F0001"; underline = false; };
          "diff added token" = { bg = "#002800"; underline = false; };
        };
      };
    };
  };
  home = {
    file.".ssh/allowed_signers".text =
      "* ${builtins.readFile ../../../../identities/id_ed25519_as.pub}";
    packages = with pkgs; [ tig git-subrepo jjui jj-fzf onefetch lazygit ];
  };
}
