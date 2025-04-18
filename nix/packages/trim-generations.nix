# https://nixos.wiki/wiki/NixOS_Generations_Trimmer
{ pkgs }:
pkgs.writeTextFile rec {
  name = "trim-generations";
  executable = true;
  destination = "/bin/${name}";
  text = builtins.readFile ./trim-generations.sh;
}
