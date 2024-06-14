# Minimal HM configuration.
{ inputs, pkgs, ... }: {
  services.ssh-agent.enable = true;
  home.packages = [
    pkgs.assh
  ];
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
    };
  };
}
