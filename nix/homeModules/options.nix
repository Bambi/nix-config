{ lib, ... }:
with lib;
{
  options.my = {
    bash = mkOption {
      type = types.bool;
      description = "Include bash configuration";
      default = true;
    };
    sshIdFile = mkOption {
      type = types.str;
      description = "User ssh identity file";
      default = "id_ed25519_as";
    };
  };
}
