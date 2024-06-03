# Minimal user configuration (headless system for example)
{ config, pkgs, lib, inputs, ... }: {
  imports = with inputs.self.homeModules; [
    fish
    fzf
    git
    lf
    nnn
    helix
    starship
    ssh
    yazi
  ]; # ++ pkgs.lib.optionals config.home.guiApps [ ./gui ];

  # enable unfree packages
  nixpkgs.config.allowUnfree = true;

  home = {
    packages = with pkgs; [
      pv
      duf
      fd
      btop
      mosh
      ncdu
      ripgrep
      tig
      tree
      lnav
      curl
      procs
      just
      age
      ssh-to-age
      sops
      neofetch
      tcpdump
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

    stateVersion = "23.11";

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
      enableAliases = true;
      icons = true;
      extraOptions = [ "--group-directories-first" ];
    };
    home-manager.enable = true;
  };

  targets.genericLinux.enable = true;

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
    };
  };

  sops = {
    age = {
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      generateKey = false;
    };
    defaultSopsFile = ./secrets.yaml;
  };

  # Workaround home-manager bug with flakes
  # - https://github.com/nix-community/home-manager/issues/2033
  news.display = "silent";

  # Nicely reload system units when changing configs
  systemd.user.startServices = lib.mkIf pkgs.stdenv.isLinux "sd-switch";
}
