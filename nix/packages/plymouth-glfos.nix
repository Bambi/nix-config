{ inputs, stdenvNoCC, lib, ... }:
let
    plymouth-glfos = import "${inputs.glf-os}/pkgs/plymouth-glfos/default.nix";
in
    plymouth-glfos { inherit stdenvNoCC; inherit lib; }
