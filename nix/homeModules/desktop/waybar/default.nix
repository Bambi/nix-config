{ pkgs, ... }: {
  programs.waybar = {
    enable = false;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        margin-bottom = 0;
        margin-top = 0;

        modules-left = [ "custom/launcher" "custom/browser" "custom/filemanager" "cpu" "memory" "network" "hyprland/window" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "tray" "idle_inhibitor" "pulseaudio" "backlight" "battery" "clock" "custom/power" ];

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}&#8239;{capacity}%";
          format-charging = "&#8239;{capacity}%";
          format-plugged = "&#8239;{capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" ];
        };
        "custom/launcher" = {
          format = "";
          on-click = "${pkgs.fuzzel}/bin/fuzzel";
          on-click-right = "killall rofi";
        };
        "custom/browser" = {
          format = "";
          on-click = "firefox";
          tooltip = false;
        };
        "custom/filemanager" = {
          format = "";
          on-click = "thunar";
          tooltip = false;
        };
        "custom/power" = {
          format = " ";
          on-click = "${pkgs.wlogout}/bin/wlogout";
        };
        "hyprland/workspaces" = {
          sort-by-name = true;
          on-click = "activate";
        };
        "hyprland/window" = {
          max-length = 200;
          separate-outputs = true;
        };
        tray = {
          icon-size = 16;
          spacing = 6;
        };
        clock = {
          locale = "C";
          format = "  {:%H:%M}";
          format-alt = "  {:%a %d %b}"; # Icon: calendar-alt
        };
        cpu = {
          format = "&#8239; {usage}%";
          tooltip = false;
          on-click = "${pkgs.ghostty}/bin/ghostty -e '${pkgs.htop}/bin/htop'";
        };
        memory = {
          interval = 30;
          format = "  {used:0.2f}GB";
          max-length = 10;
          tooltip = false;
          warning = 70;
          critical = 90;
        };
        network = {
          interval = 10;
          format-wifi = "  {signalStrength}%";
          format-ethernet = "  {ipaddr}";
          format-linked = " {ipaddr}";
          format-disconnected = " Disconnected";
          format-disabled = "";
          tooltip = false;
          max-length = 20;
          min-length = 6;
          format-alt = "{essid}";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "  ";
            deactivated = "  ";
          };
        };
        backlight = {
          # device = "acpi_video1";
          format = "{icon}&#8239; {percent}%";
          format-icons = [ "" "" ];
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl -c backlight set 1%-";
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl -c backlight set +1%";
        };
        pulseaudio = {
          # scroll-step= 1; # %, can be a float
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{icon} {volume}% {format_source}";
          format-bluetooth-muted = " {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "🎧";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
      };
    };
  };
  # conf files from https://github.com/7KIR7/dots.git
  home.file.".config/waybar/style.css".source = ./minimal/style.css;

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "FiraCodeNerdFont:weight=bold:size=16";
        line-height = 24;
        fields = "name,generic,comment,categories,filename,keywords";
        terminal = "${pkgs.ghostty}/bin/ghostty -e";
        prompt = "❯   ";
        layer = "overlay";
        lines = 15;
        width = 40;
      };
      colors = {
        background = "1e1e2eaa";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "585b70ff";
        selection-match = "f38ba8ff";
        selection-text = "cdd6f4ff";
        border = "b4befeff";
      };
      border = {
        radius = 20;
        width = 3;
      };
    };
  };
}
