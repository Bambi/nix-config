# Minimal HM configuration.
{ inputs, pkgs, lib, ... }: {
  services.ssh-agent.enable = true;
  home.packages = [
    pkgs.assh
  ];
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    package = lib.mkDefault pkgs.nix;
    settings = {
      auto-optimise-store = true;
    };
  };
}
