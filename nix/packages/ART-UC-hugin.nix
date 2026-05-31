{ pkgs }:

pkgs.writeShellApplication {
  name = "ART-UC-hugin";

  runtimeInputs = [
    pkgs.zenity
    pkgs.art
    pkgs.hugin
  ];

  text = builtins.readFile ./scripts/ART-UC-hugin;
}
