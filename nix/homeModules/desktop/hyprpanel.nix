_: {
  programs.hyprpanel = {
    enable = true;
    # dontAssertNotificationDaemons = false;
    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {

      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      bar = {
        launcher.autoDetectIcon = true;
        workspaces = {
          show_icons = true;
          applicationIconMap = {
            "1" = "";
            "2" = {
              "icon" = "";
              "color" = "#94e2d5";
            };
            "3" = "󰓇";
          };
        };
        clock.format = "%a %d %b  %H:%M";
        layouts = {
          "0" = {
            left = [ "dashboard" "workspaces" "windowtitle" ];
            middle = [ "media" ];
            right = [ "volume" "network" "clock" "systray" "notifications" ];
          };
        };
      };

      menus = {
        clock = {
          time = {
            military = true;
            hideSeconds = true;
          };
          weather = {
            unit = "metric";
            location = "Paris";
            key = "/home/as/.config/sops-nix/secrets/weather_key";
          };
        };

        dashboard = {
          directories.enabled = false;
          stats.enable_gpu = false;
          shortcuts.left = {
            shortcut1.tooltip = "Firefox";
            shortcut1.command = "firefox";
          };
        };
      };

      theme = {
        bar = {
          transparent = true;
          outer_spacing = "0.5em";
        };

        font = {
          name = "CaskaydiaCove NF";
          size = "16px";
        };
      };
    };
  };
}
