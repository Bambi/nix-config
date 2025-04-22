{ pkgs, ... }: {
  imports = [
    ./screen-brightness.nix
    ./services.nix
    ./opengl.nix
    ./security.nix
    ./python.nix
    ./sound.nix
    ./system.nix
    ./plymouth.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      libva-utils
    ];
    etc = {
      "wallpapers/glf/white.jpg".source = ../../../assets/wallpaper/white.jpg;
      "wallpapers/glf/dark.jpg".source = ../../../assets/wallpaper/dark.jpg;
    };
  };

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        autohint = false;
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "light";
      };
    };
  };
}
