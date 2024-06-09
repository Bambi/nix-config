{ pkgs, config, lib, inputs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./bootloader.nix
    ./services.nix
    ./wireless.nix
    ./users.nix
    ./security.nix
    ./networking.nix
    ./usb.nix
    ./ssh.nix
    ./nebula
  ];

  options.my = {
    desktop.enable = inputs.self.lib.mkBoolOpt false "Enable services for a desktop.";
    laptop.enable = inputs.self.lib.mkBoolOpt false "Enable services for a laptop.";
  };
  config = lib.mkMerge [
    (import ./headless.nix { inherit pkgs; })
    (lib.mkIf config.my.desktop.enable
      (import ./desktop.nix { inherit pkgs; }) //
      (import ./display-manager.nix { inherit pkgs; }) //
      (import ./python.nix { inherit pkgs config; }) //
      (import ./sound.nix { inherit pkgs; }))
    (lib.mkIf config.my.laptop.enable {
      # a laptop is a desktop
      my.desktop.enable = true;
      my.wireless.enable = true;
    })
  ];
}
