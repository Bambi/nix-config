{ pkgs, ... }: {
  imports = [
    ./screen-brightness.nix
    ./services.nix
    ./opengl.nix
    ./security.nix
    ./python.nix
    ./sound.nix
    ./system.nix
  ];

  environment.systemPackages = with pkgs; [
    libva-utils
  ];

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
