{ config, pkgs, ... }:
let
  emanote = import (builtins.fetchTarball {
    url = "https://github.com/srid/emanote/archive/refs/tags/1.2.0.tar.gz";
    sha256 = "sha256:03b6wpl08r3h7r6wgxx6wbqkr95vn6w49z62ji19nw3i96r03idn";
  });
in
{
  imports = [ emanote.homeManagerModule ];
  services.emanote = {
    enable = true;
    # host = "127.0.0.1"; # default listen address is 127.0.0.1
    # port = 7000;        # default http port is 7000
    notes = [
      "${config.home.homeDirectory}/.technotes/notes"
    ];
    package = emanote.packages.x86_64-linux.default;
  };
}
