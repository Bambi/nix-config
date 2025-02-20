# Minimal HM configuration for terminal.
{ inputs, pkgs, lib, ... }: {
  imports = [
    ./common/fish.nix
    ./common/fzf.nix
    ./common/lf
    ./common/helix.nix
    ./common/yazi.nix
  ];
  services.ssh-agent.enable = true;
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    package = lib.mkDefault pkgs.nix;
    settings = {
      auto-optimise-store = true;
    };
  };

  home = {
    packages = with pkgs; [
      duf
      fd
      btop
      mosh
      ncdu
      ripgrep
      tree
      lnav
      curl
      procs
      neofetch
      tcpdump
      comma
      restic
    ];

    # add support for ~/.local/bin
    sessionPath = [
      "$HOME/.local/bin"
    ];

    language = {
      base = "fr_FR.utf8";
      ctype = "fr_FR.utf8";
      numeric = "fr_FR.utf8";
      time = "fr_FR.utf8";
      collate = "fr_FR.utf8";
      monetary = "fr_FR.utf8";
      messages = "fr_FR.utf8";
      paper = "fr_FR.utf8";
      name = "fr_FR.utf8";
      address = "fr_FR.utf8";
      telephone = "fr_FR.utf8";
      measurement = "fr_FR.utf8";
    };

    sessionVariables = {
      PAGER = "bat -p --wrap=never";
    };
  };

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
      };
    };
    eza = {
      enable = true;
      icons = "auto";
      extraOptions = [ "--group-directories-first" ];
    };
    home-manager.enable = true;
  };

  targets.genericLinux.enable = true;

  # Workaround home-manager bug with flakes
  # - https://github.com/nix-community/home-manager/issues/2033
  news.display = "silent";

  # Nicely reload system units when changing configs
  systemd.user.startServices = lib.mkIf pkgs.stdenv.isLinux "sd-switch";
}
