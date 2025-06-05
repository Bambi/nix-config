{ pkgs, lib, config, ... }:
{
  # Enable Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe config.programs.hyprland.package} --config /etc/greetd/hyprland.conf";
        user = "greeter";
      };
    };
  };

  environment = {
    etc."greetd/environments".text = ''
      Hyprland
      fish
    '';
    etc."greetd/hyprland.conf".text = ''
      exec-once = ${lib.getExe config.programs.regreet.package}; ${pkgs.hyprland}/bin/hyprctl dispatch exit
      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        disable_hyprland_qtutils_check = true
      }
    '';
  };

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "${../../assets/wallpaper/canyon.jpg}";
      };
      appearance.greeting_msg = "Bienvenue";
      widget.clock.format = "%A %d %B %Y - %H:%M";
    };
  };
}
