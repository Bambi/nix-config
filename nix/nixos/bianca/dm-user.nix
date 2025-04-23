{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.dm = {
    hashedPassword = "$y$j9T$gnbdTw.SyjFsl82aWGKzj0$yDoP35i/sMQ/iaKwla3IngMMLFKirPgCdVC9XL6E2TB";
    isNormalUser = true;
    description = "dm";
    extraGroups = [ "input" "wheel" "video" "audio" ];
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    users.dm = { pkgs, ... }: {
      imports = [
        ../../homeModules/firefox.nix
        {
          _module.args = {
            FFextensions = with inputs.firefox-addons.packages.${pkgs.system}; [
              ublock-origin
              bitwarden
              french-dictionary
            ];
          };
        }
      ];
      programs.bash.enable = true;
      home = {
        username = "dm";
        homeDirectory = "/home/dm";
        stateVersion = "24.11";
      };
    };
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
