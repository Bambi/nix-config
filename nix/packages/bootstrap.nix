{ pkgs }:
pkgs.writeShellApplication {
  name = "boostrap";
  text = "${builtins.readFile ../../bootstrap}";
  runtimeInputs = with pkgs; [
    bitwarden-cli
    ssh-to-age
  ];
}
