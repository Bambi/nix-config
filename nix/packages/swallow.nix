{ pkgs }:
let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  jq = "${pkgs.jq}/bin/jq";
in
pkgs.writeScriptBin "swallow" ''
  #!${pkgs.stdenv.shell}
  # Window swallower for Hyprland

  pid=$(${hyprctl} activewindow -j | ${jq} '.pid')
  workspace=$(${hyprctl} activeworkspace -j | ${jq} '.id')

  ${hyprctl} dispatch movetoworkspacesilent special
  cmd=$1; shift 1; $cmd "$@"
  ${hyprctl} dispatch movetoworkspacesilent "$workspace",pid:"$pid"
''
