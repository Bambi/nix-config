{ inputs, config, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    users.${config.my.user} = import ../homeModules/users/${config.my.user}-user.nix;
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
