{ lib, ... }:
with lib;
{
  options.my = {
    bash = mkOption {
      type = types.bool;
      description = "Include bash configuration";
      default = true;
    };
  };
}
