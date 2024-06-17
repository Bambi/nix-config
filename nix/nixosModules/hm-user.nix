{ inputs, config, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    users.${config.my.user} = import ../home/${config.my.user}/home.nix;
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
