{ pkgs, config, ... }:

let
  my-python-packages = ps: with ps; [
  ];
in
{
  environment.systemPackages = with pkgs; [
    (pkgs.python3.withPackages my-python-packages)
  ];
}
