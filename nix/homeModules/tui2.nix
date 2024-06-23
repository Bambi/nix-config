# More terminal user configuration
{ config, pkgs, lib, inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./common/bash.nix
    ./common/kakoune.nix
    ./common/tmux
    ./common/dev.nix
    ./common/nixvim.nix
    ./common/bottom.nix
  ]; # ++ pkgs.lib.optionals config.home.guiApps [ ./gui ];

  home = {
    packages = with pkgs; [
      glow
      btop
      jq
      keychain
      lazygit
      tree
      diffsitter
      # joshuto
      kmon
      trippy
      moar
      solo2-cli
      libfido2
      clipboard-jh
      # podman
      distrobox
      fira-code-nerdfont
      nushell
      bitwarden-cli
      neofetch
      onefetch
      cpufetch
      # docs
      zk
      # archives
      unzip
      zip
      p7zip
      unrar
      # compression
      gzip
      bzip2
      xz
      lz4
    ];

    file.".config/zk/config.toml".text = ''
      [notebook]
      dir = "~/.technotes/notes"
    '';

    # add support for ~/.local/bin
    sessionPath = [
      "$HOME/.local/bin"
    ];

    sessionVariables = {
      PAGER = "bat -p --wrap=never";
    };
  };

  programs = {
    direnv = {
      enable = true;
      config = {
        # whitelist.prefix = [ "${config.homeDirectory}/dev" ];
        whitelist.prefix = [ "/home/as/dev" ];
      };
      nix-direnv.enable = true;
    };
  };

  fonts.fontconfig.enable = true;
  xdg.configFile."glow/glow.yml".text =
    ''
      # show local files only; no network (TUI-mode only)
      local: true
      # mouse support (TUI-mode only)
      mouse: true
      # use pager to display markdown
      pager: true
      # word-wrap at width
      # width: 80
    '';

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        indent_style = "space";
        indent_size = 4;
      };
      "Makefile,configure" = {
        ident_style = "tab";
      };
    };
  };
}
