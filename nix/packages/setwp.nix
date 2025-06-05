{ pkgs }:
pkgs.writeScriptBin "setwp" ''
  #!${pkgs.stdenv.shell}
  set -Eeuo pipefail

  cd /tmp
  ${pkgs.curl}/bin/curl -o wp.jpg $(${pkgs.curl}/bin/curl https://peapix.com/bing/feed?country=fr | ${pkgs.jq}/bin/jq -r '.[0].imageUrl')
  ${pkgs.wbg}/bin/wbg wp.jpg
''
