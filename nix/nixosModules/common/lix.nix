{ pkgs, ... }: {
  nix = {
    package = pkgs.lix;
    settings = {
      build-dir = "/var/tmp";
    };
  };
}
