{ config, lib, inputs, ... }: {
  imports = [
    ./bootloader.nix
    ./services.nix
    ./wireless.nix
    ./ssh.nix
    ./nebula
  ];

  options.my = {
    desktop.enable = inputs.self.lib.mkBoolOpt false "Enable services for a desktop.";
    laptop.enable = inputs.self.lib.mkBoolOpt false "Enable services for a laptop.";
  };
  config = {
    # Optimize storage and automatic scheduled GC running
    # If you want to run GC manually, use commands:
    # `nix-store --optimize` for finding and eliminating redundant copies of identical store paths
    # `nix-store --gc` for optimizing the nix store and removing unreferenced and obsolete store paths
    # `nix-collect-garbage -d` for deleting old generations of user profiles
    nix.settings.auto-optimise-store = true;
    nix.optimise.automatic = true;
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  } //
  lib.mkIf config.my.laptop.enable {
    # a laptop is a desktop
    my.desktop.enable = true;
    my.wireless.enable = true;
  };
}
