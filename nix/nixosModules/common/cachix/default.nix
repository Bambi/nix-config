{ pkgs, lib, ... }:
let
  toImport = name: value: ./. + ("/" + name);
  filter = key: value: value == "regular" && lib.hasSuffix ".nix" key && key != "default.nix";
  imports = lib.mapAttrsToList toImport (lib.filterAttrs filter (builtins.readDir ./.));
in
{
  inherit imports;
  environment.systemPackages = [ pkgs.cachix ];
}
