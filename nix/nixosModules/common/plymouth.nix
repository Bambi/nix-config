{ pkgs, ... }: {
  boot = {
    plymouth = {
      enable = true;
      theme = "glfos";
      themePackages = [ pkgs.plymouth-glfos ];
    };
  };
}
